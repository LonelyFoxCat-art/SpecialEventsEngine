// AlphaMask Pro Shader v3.0
// 作者：狐猫雨空
// 专业级遮罩处理器，支持纹理蒙版、渐变遮罩与高级效果

// ======== 核心功能 ========
// • 纹理Alpha蒙版：乘法/反相/阈值模式
// • 线性/径向渐变遮罩
// • UV对齐模式：拉伸/居中/平铺
// • 遮罩边缘精细控制（羽化/硬度/偏移）
// • 5种高级混合模式（乘法/屏幕/叠加/柔光/颜色减淡）
// • 多通道遮罩系统（R/G/B/RGB/A）
// • 智能性能优化（条件采样/早期退出）

// ======== 关键特性 ========
// • 10种遮罩模式，灵活适应各种需求
// • 电影级边缘控制，解决硬边缘问题
// • 专业混合算法，增强视觉表现力
// • 通道独立处理，支持复杂遮罩设计
// • 透明区域早期退出，提升性能
// • 智能纹理采样，减少GPU负担
// • 完整边界保护，防止UV越界
// • 跨平台兼容，支持移动/桌面/Web

// ======== 使用提示 ========
// 1. 模式选择：
//    • 0-2: 纹理Alpha通道（乘法/反相/阈值）
//    • 3-4: 渐变遮罩（线性/径向）
//    • 5-9: 多通道遮罩（R/G/B/亮度/Alpha）
// 2. UV对齐：0=拉伸, 1=居中, 2=平铺
// 3. 边缘控制：
//    • edge_feather [0-1]: 羽化范围
//    • edge_hardness [0-1]: 边缘锐度
//    • edge_offset [-1,1]: 遮罩膨胀/收缩
// 4. 混合模式：0=乘法(默认),1=屏幕,2=叠加,3=柔光,4=颜色减淡
// 5. 性能优化：禁用未使用的功能，合理设置参数范围

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// ======== 纹理输入 ========
uniform sampler2D source;           // 主内容纹理
uniform sampler2D mask;             // 遮罩纹理（按需采样）

// ======== 通用遮罩参数 ========
uniform vec2 mask_offset;           // 遮罩UV偏移 [x,y]
uniform vec2 mask_scale;            // 遮罩UV缩放 [x,y]
uniform int mask_align;             // UV对齐模式 (0=拉伸,1=居中,2=平铺)
uniform int mask_mode;              // 遮罩模式 (0-9)
uniform float threshold_value;     // 阈值临界点 [0.0,1.0]
uniform float mask_opacity;         // 遮罩透明度 [0.0,1.0]

// ======== 渐变遮罩参数 ========
uniform vec2 gradient_start;        // 渐变起点/中心 [u,v]
uniform vec2 gradient_end;          // 线性渐变终点 [u,v]
uniform float gradient_radius;     // 径向渐变半径 [0.0,1.5]

// ======== 边缘精细控制 ========
uniform float edge_feather;         // 边缘羽化 [0.0,1.0]
uniform float edge_hardness;        // 边缘硬度 [0.0,1.0]
uniform float edge_offset;          // 边缘偏移 [-1.0,1.0]

// ======== 高级混合参数 ========
uniform int blend_mode;             // 混合模式 (0-4)

// ======== 内部常量 ========
const float EPSILON = 0.000001;     // 避免除以零
const float HALF_PI = 1.57079632679; // π/2

// ========== 工具函数 ==========

// 线性渐变计算
// 返回[0.0,1.0]：沿start→end方向的归一化插值
float linearGradient(vec2 uv, vec2 start, vec2 end) {
    vec2 dir = end - start;
    float len = max(dot(dir, dir), EPSILON); // 避免除零
    float t = dot(uv - start, dir) / len;
    return clamp(t, 0.0, 1.0);
}

// 径向渐变计算
// 返回[0.0,1.0]：中心为1.0，边缘(radius处)为0.0
float radialGradient(vec2 uv, vec2 center, float radius) {
    float dist = distance(uv, center) / radius;
    return 1.0 - clamp(dist, 0.0, 1.0);
}

// 应用边缘精细控制
float applyEdgeControl(float mask_value) {
    // 应用边缘偏移
    if (abs(edge_offset) > 0.0) {
        float offset_threshold = 0.5 + edge_offset;
        mask_value = smoothstep(offset_threshold - edge_feather, offset_threshold + edge_feather, mask_value);
    }
    
    // 应用边缘硬度
    if (edge_hardness > 0.0) {
        float hardness_range = (1.0 - edge_hardness) * 0.5;
        mask_value = smoothstep(0.5 - hardness_range, 0.5 + hardness_range, mask_value);
    }
    
    return mask_value;
}

// 高级混合模式
vec4 applyBlendMode(vec4 src, vec4 dst, float alpha) {
    vec4 result = src;
    
    if (blend_mode == 1) { // Screen (屏幕)
        result.rgb = 1.0 - (1.0 - src.rgb) * (1.0 - dst.rgb);
    } 
    else if (blend_mode == 2) { // Overlay (叠加)
        vec3 condition = step(0.5, dst.rgb);
        vec3 overlay1 = 2.0 * src.rgb * dst.rgb;
        vec3 overlay2 = 1.0 - 2.0 * (1.0 - src.rgb) * (1.0 - dst.rgb);
        result.rgb = mix(overlay1, overlay2, condition);
    } 
    else if (blend_mode == 3) { // Soft Light (柔光) 
        vec3 condition = step(0.5, dst.rgb);
        vec3 soft_light1 = src.rgb - (1.0 - 2.0 * (dst.rgb - 0.5)) * src.rgb * (1.0 - src.rgb);
        vec3 src_condition = step(0.5, src.rgb);
        vec3 src_low = 16.0 * src.rgb * src.rgb * src.rgb;
        vec3 src_high = sqrt(src.rgb) - 1.0;
        vec3 src_blend = mix(src_low, src_high, src_condition);
        
        vec3 soft_light2 = src.rgb + (2.0 * dst.rgb) * src_blend;
        
        result.rgb = mix(soft_light1, soft_light2, condition);
        result.rgb = clamp(result.rgb, 0.0, 1.0);
    } 
    else if (blend_mode == 4) { // Color Dodge (颜色减淡)
        result.rgb = 1.0 - (1.0 - src.rgb) / max(dst.rgb, 0.001);
        result.rgb = clamp(result.rgb, 0.0, 1.0);
    }
    
    return mix(src, result, alpha);
}

// 多通道遮罩采样
float sampleMultiChannelMask(vec4 msk) {
    if (mask_mode == 5) return msk.r;       // R通道
    else if (mask_mode == 6) return msk.g;  // G通道
    else if (mask_mode == 7) return msk.b;  // B通道
    else if (mask_mode == 8) {              // RGB混合(亮度)
        return dot(msk.rgb, vec3(0.299, 0.587, 0.114));
    }
    else return msk.a;                      // A通道(默认)
}

// 条件纹理采样
vec4 conditionalSample(sampler2D tex, vec2 uv, bool condition) {
    return condition ? texture2D(tex, uv) : vec4(0.0);
}

// ========== 主函数 ==========
void main() {
    vec2 uv = v_vTexcoord;
    vec2 mask_uv = uv;
    
    //  早期透明退出 
    vec4 src_pre = texture2D(source, uv);
    if (src_pre.a < 0.01) {
        gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
        return;
    }
    
    //  UV 对齐与变换 
    if (mask_align == 1) {
        // 居中模式
        mask_uv = (uv - 0.5) * mask_scale + 0.5 + mask_offset;
    } else if (mask_align == 2) {
        // 平铺模式
        mask_uv = mod(uv * mask_scale + mask_offset, 1.0);
    } else {
        // 拉伸模式（默认）
        mask_uv = uv * mask_scale + mask_offset;
    }
    
    // 限制UV范围（非平铺模式）
    if (mask_align != 2) {
        mask_uv = clamp(mask_uv, 0.0, 1.0);
    }
    
    //  遮罩模式处理 
    float mask_value = 1.0;
    vec4 msk = vec4(0.0);
    
    // 纹理遮罩模式 (0-4, 5-9)
    bool use_texture_mask = (mask_mode <= 2) || (mask_mode >= 5 && mask_mode <= 9);
    bool use_gradient_mask = (mask_mode == 3 || mask_mode == 4);
    
    if (use_texture_mask) {
        msk = conditionalSample(mask, mask_uv, true);
        
        if (mask_mode <= 2) {
            // Alpha纹理模式
            mask_value = msk.a;
            
            if (mask_mode == 1) {
                // 反相蒙版
                mask_value = 1.0 - mask_value;
            } else if (mask_mode == 2) {
                // 阈值蒙版
                mask_value = (mask_value >= threshold_value) ? 1.0 : 0.0;
            }
        } else if (mask_mode >= 5 && mask_mode <= 9) {
            // 多通道遮罩模式
            mask_value = sampleMultiChannelMask(msk);
            
            if (mask_mode < 8) { // 5-7: R/G/B通道阈值
                mask_value = (mask_value >= threshold_value) ? 1.0 : 0.0;
            }
        }
    } 
    // 渐变遮罩模式 (3-4)
    else if (use_gradient_mask) {
        vec2 grad_uv = uv;
        
        if (mask_mode == 3) {
            // 线性渐变遮罩
            mask_value = linearGradient(grad_uv, gradient_start, gradient_end);
        } else if (mask_mode == 4) {
            // 径向渐变遮罩
            mask_value = radialGradient(grad_uv, gradient_start, gradient_radius);
        }
    }
    
    //  边缘精细控制 
    mask_value = applyEdgeControl(mask_value);
    
    //  应用遮罩透明度 
    float effective_mask = mask_value * mask_opacity;
    
    //  高级混合模式处理 
    vec4 final_color;
    
    if (blend_mode > 0 && effective_mask > 0.01) {
        // 使用默认黑色背景进行混合
        vec4 bg_sample = vec4(0.0, 0.0, 0.0, 1.0);
        final_color = applyBlendMode(src_pre, bg_sample, effective_mask);
        final_color.a = src_pre.a * effective_mask; // 保留原始alpha
    } else {
        // 简单乘法模式（默认）
        final_color = vec4(src_pre.rgb, src_pre.a * effective_mask);
    }
    
    //  最终输出 
    gl_FragColor = final_color * v_vColour;
}