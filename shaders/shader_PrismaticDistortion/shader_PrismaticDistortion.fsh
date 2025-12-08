// Prismatic Distortion Shader v1.4
// 作者：狐猫雨空
// 专业级视觉效果处理器，支持六合一动态效果

// ======== 核心功能 ========
// • 像素化/马赛克：带抖动和颜色量化
// • 动态镜像：四象限对称/单轴镜像
// • 波形扭曲：水平波动效果
// • 故障效果：RGB分离、扫描线噪点
// • 屏幕扰动：噪声扭曲效果
// • CRT模拟：扫描线、RGB像素条纹、隔行扫描、曲面畸变

// ======== 关键特性 ========
// • 所有功能可独立开关，无性能损失
// • 透明区域早期退出优化
// • 多级Bayer矩阵抖动支持 (2x2/4x4/8x8)
// • 双噪声模式：纹理/程序化
// • 智能效果叠加流水线
// • 安全坐标钳位防止纹理越界
// • 兼容标准GPU架构

// ======== 使用提示 ========
// 1. 效果流水线顺序：镜像→曲面畸变→扰动→波形→马赛克→故障→CRT
// 2. CRT效果与故障效果可同时启用创造复合效果
// 3. 曲面畸变会影响所有空间效果（镜像/扰动/波形/马赛克）
// 4. 性能优化：禁用未使用的功能模块
// 5. 混合模式：调整u_blend参数实现平滑过渡

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec2 v_vScreenPos; // 屏幕空间坐标 [0,1]

// ======== 全局控制 ========
uniform bool u_enable_mosaic;      // 启用像素化/马赛克效果
uniform bool u_enable_mirror;      // 启用镜像效果
uniform bool u_enable_glitch;      // 启用故障效果
uniform bool u_enable_wave;        // 启用波形扭曲
uniform bool u_enable_distortion;  // 启用屏幕空间扰动
uniform bool u_enable_crt;         // 启用CRT效果主开关

// ======== CRT效果开关 (需u_enable_crt=true) ========
uniform bool u_enable_crt_scanline; // CRT扫描线
uniform bool u_enable_rgb_stripe;   // RGB像素条纹
uniform bool u_enable_interlaced;   // 隔行扫描闪烁
uniform bool u_enable_curvature;    // 屏幕曲面畸变

// ======== 镜像参数 (u_enable_mirror=true时使用) ========
uniform bool u_quad_mode;          // 四象限对称模式
uniform bool u_horizontal;         // 单轴镜像方向 (非四象限模式)
uniform float u_mirror_line;       // 镜像线位置 [0.0,1.0]
uniform float u_center_x;          // 四象限对称中心X [0.0,1.0]
uniform float u_center_y;          // 四象限对称中心Y [0.0,1.0]

// ======== 马赛克参数 (u_enable_mosaic=true时使用) ========
uniform vec2 u_resolution;         // 屏幕分辨率
uniform float u_pixelSize;         // 像素/马赛克块大小
uniform float u_ditherStrength;    // 抖动强度 [0,1]
uniform float u_colorLevels;       // 颜色量化等级 (≥1)
uniform float u_modeA;             // 模式A: 0=马赛克, 1=像素
uniform float u_modeB;             // 模式B: 同上 (用于过渡)
uniform float u_blend;             // 混合比率 [0,1]: 0=A, 1=B
uniform float u_bayerSize;         // Bayer矩阵尺寸: 2.0,4.0,8.0

// ======== 波形参数 (u_enable_wave=true时使用) ========
uniform float time;                // 时间 (秒)
uniform float wave_amp;            // 波幅 [0,0.1]
uniform float wave_freq;           // 频率 [1,50]

// ======== 故障参数 (u_enable_glitch=true时使用) ========
uniform float glitch_amt;          // 故障强度 [0,1]
uniform float seed;                // 随机种子

// ======== 扰动参数 (u_enable_distortion=true时使用) ========
uniform sampler2D texture_noise;   // 噪声纹理 (可选)
uniform float u_dist_strength;     // 扰动强度 [0.01,0.1]
uniform vec2 u_scroll_speed;       // 噪声滚动速度
uniform bool u_use_noise_texture;  // true=纹理, false=程序化噪声

// ======== CRT参数 (u_enable_crt=true时使用) ========
uniform float u_crt_scanline_intensity; // 扫描线强度 [0,1]
uniform float u_rgb_stripe_intensity;   // RGB条纹强度 [0,1]
uniform float u_interlaced_intensity;   // 隔行闪烁强度 [0,1]
uniform float u_curvature;               // 曲面畸变量 [0.1,0.5]

// ======== 内部常量 ========
const float EPSILON = 0.000001;

// ========== 工具函数 ==========

// 伪随机数生成器
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// 应用波形扭曲
vec2 apply_wave(vec2 uv, float time) {
    float wave_offset = sin(uv.y * wave_freq + time) * wave_amp;
    uv.x += wave_offset;
    return uv;
}

// 应用屏幕空间扰动
vec2 apply_distortion(vec2 uv, vec2 screenPos, float time) {
    vec2 noise_uv = screenPos + u_scroll_speed * time;
    float displacement;
    
    if (u_use_noise_texture) {
        vec4 noise_sample = texture2D(texture_noise, noise_uv);
        displacement = noise_sample.r * 2.0 - 1.0; // [-1,1]
    } else {
        displacement = random(noise_uv) * 2.0 - 1.0;
    }
    
    return uv + vec2(displacement * u_dist_strength, 0.0); // 水平扰动
}

// 应用CRT曲面畸变
vec2 apply_curvature(vec2 uv, vec2 resolution) {
    vec2 centered = (uv - 0.5) * 2.0;
    float aspect = resolution.x / resolution.y;
    centered.x *= aspect; // 保持宽高比
    
    float distortion = dot(centered, centered) * u_curvature;
    centered *= (1.0 + distortion);
    
    // 恢复宽高比
    centered.x /= aspect;
    uv = centered * 0.5 + 0.5;
    
    return uv;
}

// 应用镜像变换
vec2 apply_mirror(vec2 uv) {
    if (u_quad_mode) {
        // 四象限对称
        if (uv.x > u_center_x) uv.x = u_center_x - (uv.x - u_center_x);
        if (uv.y > u_center_y) uv.y = u_center_y - (uv.y - u_center_y);
        uv.x = clamp(uv.x, 0.0, u_center_x);
        uv.y = clamp(uv.y, 0.0, u_center_y);
    } else {
        // 单轴镜像
        if (u_horizontal) {
            if (uv.x > u_mirror_line) uv.x = u_mirror_line - (uv.x - u_mirror_line);
        } else {
            if (uv.y > u_mirror_line) uv.y = u_mirror_line - (uv.y - u_mirror_line);
        }
        uv = clamp(uv, 0.0, 1.0);
    }
    return uv;
}

// Bayer矩阵值计算
float bayer_value(vec2 p, float size) {
    p = mod(floor(p), size);
    
    // 2x2 Bayer矩阵
    if (size <= 2.0) {
        if (p.y < 1.0) return (p.x < 1.0) ? 0.0 : 2.0;
        else return (p.x < 1.0) ? 3.0 : 1.0;
    }
    
    // 4x4 Bayer矩阵
    if (size <= 4.0) {
        if (p.y == 0.0) {
            if (p.x == 0.0) return 0.0;
            if (p.x == 1.0) return 8.0;
            if (p.x == 2.0) return 2.0;
            if (p.x == 3.0) return 10.0;
        } else if (p.y == 1.0) {
            if (p.x == 0.0) return 12.0;
            if (p.x == 1.0) return 4.0;
            if (p.x == 2.0) return 14.0;
            if (p.x == 3.0) return 6.0;
        } else if (p.y == 2.0) {
            if (p.x == 0.0) return 3.0;
            if (p.x == 1.0) return 11.0;
            if (p.x == 2.0) return 1.0;
            if (p.x == 3.0) return 9.0;
        } else if (p.y == 3.0) {
            if (p.x == 0.0) return 15.0;
            if (p.x == 1.0) return 7.0;
            if (p.x == 2.0) return 13.0;
            if (p.x == 3.0) return 5.0;
        }
        return 0.0;
    }
    
    // 8x8 Bayer矩阵
    if (p.y == 0.0) {
        if (p.x == 0.0) return 0.0;   if (p.x == 1.0) return 32.0; if (p.x == 2.0) return 8.0;  if (p.x == 3.0) return 40.0;
        if (p.x == 4.0) return 2.0;   if (p.x == 5.0) return 34.0; if (p.x == 6.0) return 10.0; if (p.x == 7.0) return 42.0;
    } else if (p.y == 1.0) {
        if (p.x == 0.0) return 48.0;  if (p.x == 1.0) return 16.0; if (p.x == 2.0) return 56.0; if (p.x == 3.0) return 24.0;
        if (p.x == 4.0) return 50.0;  if (p.x == 5.0) return 18.0; if (p.x == 6.0) return 58.0; if (p.x == 7.0) return 26.0;
    } else if (p.y == 2.0) {
        if (p.x == 0.0) return 12.0;  if (p.x == 1.0) return 44.0; if (p.x == 2.0) return 4.0;  if (p.x == 3.0) return 36.0;
        if (p.x == 4.0) return 14.0;  if (p.x == 5.0) return 46.0; if (p.x == 6.0) return 6.0;  if (p.x == 7.0) return 38.0;
    } else if (p.y == 3.0) {
        if (p.x == 0.0) return 60.0;  if (p.x == 1.0) return 28.0; if (p.x == 2.0) return 52.0; if (p.x == 3.0) return 20.0;
        if (p.x == 4.0) return 62.0;  if (p.x == 5.0) return 30.0; if (p.x == 6.0) return 54.0; if (p.x == 7.0) return 22.0;
    } else if (p.y == 4.0) {
        if (p.x == 0.0) return 3.0;   if (p.x == 1.0) return 35.0; if (p.x == 2.0) return 11.0; if (p.x == 3.0) return 43.0;
        if (p.x == 4.0) return 1.0;   if (p.x == 5.0) return 33.0; if (p.x == 6.0) return 9.0;  if (p.x == 7.0) return 41.0;
    } else if (p.y == 5.0) {
        if (p.x == 0.0) return 51.0;  if (p.x == 1.0) return 19.0; if (p.x == 2.0) return 59.0; if (p.x == 3.0) return 27.0;
        if (p.x == 4.0) return 49.0;  if (p.x == 5.0) return 17.0; if (p.x == 6.0) return 57.0; if (p.x == 7.0) return 25.0;
    } else if (p.y == 6.0) {
        if (p.x == 0.0) return 15.0;  if (p.x == 1.0) return 47.0; if (p.x == 2.0) return 7.0;  if (p.x == 3.0) return 39.0;
        if (p.x == 4.0) return 13.0;  if (p.x == 5.0) return 45.0; if (p.x == 6.0) return 5.0;  if (p.x == 7.0) return 37.0;
    } else if (p.y == 7.0) {
        if (p.x == 0.0) return 63.0;  if (p.x == 1.0) return 31.0; if (p.x == 2.0) return 55.0; if (p.x == 3.0) return 23.0;
        if (p.x == 4.0) return 61.0;  if (p.x == 5.0) return 29.0; if (p.x == 6.0) return 53.0; if (p.x == 7.0) return 21.0;
    }
    return 0.0;
}

// 应用马赛克/像素模式
vec3 apply_mode(float mode, vec2 blockCoord, vec3 origColor) {
    if (mode < 0.5) {
        return origColor; // 马赛克模式
    } else {
        // 像素模式带抖动
        float levels = max(u_colorLevels, 1.0);
        vec3 quantized = floor(origColor * levels) / levels;
        
        float maxVal = (u_bayerSize == 2.0) ? 4.0 : (u_bayerSize == 4.0 ? 16.0 : 64.0);
        float bayerVal = bayer_value(blockCoord, u_bayerSize);
        float threshold = bayerVal / maxVal;
        
        return quantized + (threshold * u_ditherStrength) / levels;
    }
}

// ======== 主函数 ========
void main() {
    vec2 uv = v_vTexcoord;
    vec3 finalColor;
    float alpha = 1.0;
    
    //  应用镜像效果
    if (u_enable_mirror) {
        uv = apply_mirror(uv);
    }
    
    //  应用CRT曲面畸变
    bool curvatureApplied = false;
    if (u_enable_crt && u_enable_curvature && u_curvature > 0.001) {
        vec2 prevUV = uv;
        uv = apply_curvature(uv, u_resolution);
        
        // 检查曲面畸变后是否超出边界
        if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
            gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
            return;
        }
        curvatureApplied = true;
    }
    
    //  应用屏幕空间扰动
    if (u_enable_distortion) {
        uv = apply_distortion(uv, v_vScreenPos, time);
    }
    
    //  应用波形扭曲
    if (u_enable_wave) {
        uv = apply_wave(uv, time);
    }
    
    //  获取基础颜色与Alpha 
    vec4 baseSample = texture2D(gm_BaseTexture, uv);
    vec3 baseColor = baseSample.rgb;
    alpha = baseSample.a;
    
    // 透明区域早期退出
    if (alpha < 0.1) {
        gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
        return;
    }
    
    //  应用马赛克效果
    if (u_enable_mosaic) {
        vec2 blockCoord = floor(uv * u_resolution / u_pixelSize);
        vec2 blockCenterUV = (blockCoord + 0.5) * (u_pixelSize / u_resolution);
        
        vec2 sampledUV = blockCenterUV;
        if (u_enable_mirror && !curvatureApplied) {
            sampledUV = apply_mirror(blockCenterUV);
        }
        
        if (u_enable_crt && u_enable_curvature && u_curvature > 0.001) {
            sampledUV = apply_curvature(sampledUV, u_resolution);
        }
        
        if (u_enable_distortion) {
            sampledUV = apply_distortion(sampledUV, v_vScreenPos, time);
        }
        if (u_enable_wave) {
            sampledUV = apply_wave(sampledUV, time);
        }
        
        vec3 blockColor = texture2D(gm_BaseTexture, sampledUV).rgb;
        vec3 colorA = apply_mode(u_modeA, blockCoord, blockColor);
        vec3 colorB = apply_mode(u_modeB, blockCoord, blockColor);
        finalColor = mix(colorA, colorB, u_blend);
    } else {
        finalColor = baseColor;
    }
    
    //  应用故障效果
    if (u_enable_glitch) {
        vec2 glitch_offset = vec2(
            (random(floor(uv * seed)) - 0.5) * glitch_amt * 0.05,
            (random(floor(uv * seed * 2.0)) - 0.5) * glitch_amt * 0.05
        );
        
        vec4 r = texture2D(gm_BaseTexture, uv + vec2(-glitch_offset.x, 0.0));
        vec4 g = texture2D(gm_BaseTexture, uv + glitch_offset * 0.3);
        vec4 b = texture2D(gm_BaseTexture, uv + vec2(glitch_offset.x, 0.0));
        
        finalColor = vec3(r.r, g.g, b.b);
        
        if (mod(gl_FragCoord.y + seed * 100.0, 2.0) < 1.0) {
            if (random(vec2(gl_FragCoord.x, time)) > 0.95) {
                finalColor = vec3(0.5); // 50%灰
            }
            if (random(vec2(gl_FragCoord.x, time * 0.5)) > 0.98) {
                finalColor = mix(finalColor, vec3(0.7), 0.3);
            }
        }
    }
    
    //  应用CRT效果
    if (u_enable_crt) {
        // CRT扫描线
        if (u_enable_crt_scanline) {
            float scan = sin(uv.y * u_resolution.y * 0.5 + time * 6.0);
            finalColor *= (1.0 - u_crt_scanline_intensity * 0.5 * (1.0 + scan));
        }
        
        // RGB像素条纹
        if (u_enable_rgb_stripe && u_rgb_stripe_intensity > 0.01) {
            float stripe_freq = u_resolution.x * 3.0;
            float phase = mod(uv.x * stripe_freq + time * 2.0, 3.0);
            vec3 mask = vec3(
                smoothstep(0.9, 1.1, phase),
                smoothstep(1.9, 2.1, phase),
                smoothstep(2.9, 3.1, mod(phase, 3.0))
            );
            finalColor *= mix(vec3(1.0), mask, u_rgb_stripe_intensity);
        }
        
        // 隔行扫描闪烁
        if (u_enable_interlaced) {
            float line = floor(uv.y * u_resolution.y);
            float field = floor(mod(time * 60.0, 2.0));
            float is_inactive = step(0.5, mod(line - field, 2.0));
            finalColor *= (1.0 - u_interlaced_intensity * is_inactive);
        }
    }
    
    //  最终输出 
    gl_FragColor = vec4(clamp(finalColor, 0.0, 1.0), alpha) * v_vColour;
}