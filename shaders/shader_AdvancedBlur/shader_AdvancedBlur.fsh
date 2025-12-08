// Advanced Blur Shader v1.2
// 作者：狐猫雨空
// 专业级多重模糊效果处理器，支持11种模糊算法

// ======== 核心功能 ========
// • 高斯模糊：标准正态分布模糊
// • 方框模糊：均匀权重模糊
// • 径向模糊：从中心向外发散
// • 缩放模糊：模拟变焦效果
// • 运动模糊：沿指定方向的拖尾
// • 圆盘模糊：圆形采样区域
// • 锐化：增强边缘细节
// • 倾斜模糊：模拟浅景深
// • 十字模糊：十字形模糊
// • 星芒模糊：可配置射线数量
// • 方向模糊：传统线性模糊

// ======== 关键特性 ========
// • 所有效果可独立开关，动态切换
// • 透明区域早期退出优化
// • 智能边界检查防止越界采样
// • 可配置采样数量（性能/质量平衡）
// • 统一强度控制（简化参数调整）
// • 支持随机函数和越界保护
// • 优化的星芒效果（固定最大射线数）

// ======== 使用提示 ========
// 1. 高斯模糊适合常规模糊，方框模糊性能更高
// 2. 径向/缩放模糊以u_center为基准点
// 3. 星芒效果(u_blur_type=10)可通过u_star_points控制射线数(2-16)
// 4. 倾斜模糊(u_blur_type=8)使用水平景深，焦点在u_center.y
// 5. 性能优化：低配设备减少SAMPLE_COUNT
// 6. 所有模糊强度归一化处理，统一通过u_blur_amount控制

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// ======== 模糊控制参数 ========
uniform int u_blur_type;       // 模糊类型 (0-10)
uniform vec2 u_resolution;     // 屏幕分辨率 [width, height]
uniform float u_blur_amount;   // 模糊强度 [0,1] (统一映射)
uniform vec2 u_axis;           // 高斯/方框模糊轴向 [x,y]
uniform vec2 u_direction;      // 传统方向模糊向量
uniform vec2 u_center;         // 径向/缩放模糊中心 [0,1]
uniform float u_angle;         // 运动模糊角度 [弧度]
uniform float u_star_points;   // 星芒效果射线数量 [2,16]

// ======== 内部常量 ========
const int SAMPLE_COUNT = 32;       // 全局采样数（径向/缩放/运动/圆盘/星芒）
const int STAR_MAX_POINTS = 16;    // 星芒最大射线数
const float EPSILON = 0.000001;    // 避免除以零

// ========== 工具函数 ==========

// 高斯分布函数
float gaussian(float x, float sigma) {
    return exp(-(x * x) / (2.0 * sigma * sigma)) * 0.3989422804 / sigma;
}

// 伪随机数生成器
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// 越界检查（返回是否有效）
bool in_bounds(vec2 uv) {
    return (uv.x >= 0.0 && uv.x <= 1.0 && uv.y >= 0.0 && uv.y <= 1.0);
}

// ========== 主函数 ==========
void main() {
    vec2 uv = v_vTexcoord;
    vec4 base_color = texture2D(gm_BaseTexture, uv);
    vec2 pixel_size = 1.0 / u_resolution;
    float blur_strength = u_blur_amount * 0.02; // 统一强度映射
    
    // 星芒点数处理
    int star_points = 6;
    if (u_star_points > 0.5) {
        star_points = int(u_star_points + 0.5);
        if (star_points < 2) star_points = 2;
        if (star_points > STAR_MAX_POINTS) star_points = STAR_MAX_POINTS;
    }
    
    // ======== 模糊类型分发 ========
    if (u_blur_type == 0) {
        // 高斯模糊（沿 u_axis）
        vec4 acc = vec4(0.0);
        float total = 0.0;
        float sigma = 1.0;
        for (int i = -4; i <= 4; i++) {
            float w = gaussian(float(i), sigma);
            acc += texture2D(gm_BaseTexture, uv + float(i) * pixel_size * u_axis) * w;
            total += w;
        }
        gl_FragColor = (total > 0.0) ? acc / total : base_color;
        
    } else if (u_blur_type == 1) {
        // 方框模糊（沿 u_axis）
        vec4 acc = vec4(0.0);
        for (int i = -4; i <= 4; i++) {
            acc += texture2D(gm_BaseTexture, uv + float(i) * pixel_size * u_axis);
        }
        gl_FragColor = acc / 9.0;
        
    } else if (u_blur_type == 2) {
        // 方向模糊（兼容旧版）
        vec4 acc = vec4(0.0);
        for (int i = 0; i < 8; i++) {
            float t = float(i) / 7.0;
            acc += texture2D(gm_BaseTexture, uv + u_direction * blur_strength * (t - 0.5) * 2.0);
        }
        gl_FragColor = acc / 8.0;
        
    } else if (u_blur_type == 3) {
        // 径向模糊（从中心向外）
        vec4 acc = vec4(0.0);
        vec2 dir = uv - u_center;
        int count = 0;
        for (int i = 0; i < SAMPLE_COUNT; i++) {
            float t = float(i) / float(SAMPLE_COUNT - 1);
            float offset = (t - 0.5) * 2.0 * blur_strength;
            vec2 sample_uv = uv - dir * offset;
            if (in_bounds(sample_uv)) {
                acc += texture2D(gm_BaseTexture, sample_uv);
                count++;
            }
        }
        gl_FragColor = (count > 0) ? acc / float(count) : base_color;
        
    } else if (u_blur_type == 4) {
        // 缩放模糊（模拟变焦）
        vec4 acc = vec4(0.0);
        vec2 dir = uv - u_center;
        int count = 0;
        for (int i = 0; i < SAMPLE_COUNT; i++) {
            float t = float(i) / float(SAMPLE_COUNT - 1);
            float offset = (t - 0.5) * 2.0 * blur_strength;
            vec2 sample_uv = u_center + dir * (1.0 - offset);
            if (in_bounds(sample_uv)) {
                acc += texture2D(gm_BaseTexture, sample_uv);
                count++;
            }
        }
        gl_FragColor = (count > 0) ? acc / float(count) : base_color;
        
    } else if (u_blur_type == 5) {
        // 运动模糊（指定角度）
        vec4 acc = vec4(0.0);
        vec2 motion_dir = vec2(cos(u_angle), sin(u_angle));
        int count = 0;
        for (int i = 0; i < SAMPLE_COUNT; i++) {
            float t = float(i) / float(SAMPLE_COUNT - 1);
            float offset = (t - 0.5) * 2.0 * blur_strength;
            vec2 sample_uv = uv + motion_dir * offset;
            if (in_bounds(sample_uv)) {
                acc += texture2D(gm_BaseTexture, sample_uv);
                count++;
            }
        }
        gl_FragColor = (count > 0) ? acc / float(count) : base_color;
        
    } else if (u_blur_type == 6) {
        // 圆盘模糊（随机采样）
        vec4 acc = vec4(0.0);
        int count = 0;
        for (int i = 0; i < SAMPLE_COUNT; i++) {
            float angle = random(vec2(float(i), uv.x)) * 6.283185307; // 2π
            float radius = random(vec2(float(i), uv.y)) * blur_strength;
            vec2 sample_uv = uv + vec2(cos(angle), sin(angle)) * radius;
            if (in_bounds(sample_uv)) {
                acc += texture2D(gm_BaseTexture, sample_uv);
                count++;
            }
        }
        gl_FragColor = (count > 0) ? acc / float(count) : base_color;
        
    } else if (u_blur_type == 7) {
        // 锐化（反向模糊）
        vec4 blur = vec4(0.0);
        float w_center = 5.0;
        float w_edge = 2.0;
        float w_corner = 1.0;
        float total = w_center + 4.0 * w_edge + 4.0 * w_corner;
        blur += texture2D(gm_BaseTexture, uv) * w_center;
        blur += (texture2D(gm_BaseTexture, uv + vec2(1,0)*pixel_size) +
                 texture2D(gm_BaseTexture, uv + vec2(-1,0)*pixel_size) +
                 texture2D(gm_BaseTexture, uv + vec2(0,1)*pixel_size) +
                 texture2D(gm_BaseTexture, uv + vec2(0,-1)*pixel_size)) * w_edge;
        blur += (texture2D(gm_BaseTexture, uv + vec2(1,1)*pixel_size) +
                 texture2D(gm_BaseTexture, uv + vec2(1,-1)*pixel_size) +
                 texture2D(gm_BaseTexture, uv + vec2(-1,1)*pixel_size) +
                 texture2D(gm_BaseTexture, uv + vec2(-1,-1)*pixel_size)) * w_corner;
        blur /= total;
        float amount = blur_strength * 2.0; // 增强锐化响应
        gl_FragColor = base_color + (base_color - blur) * amount;
        
    } else if (u_blur_type == 8) {
        // 倾斜模糊（水平景深）
        float focus_y = u_center.y;
        float range = 0.2; // 固定景深范围
        float dy = abs(uv.y - focus_y);
        float strength = (dy > range) ? blur_strength * dy : 0.0;
        vec4 acc = vec4(0.0);
        int count = 0;
        for (int i = -4; i <= 4; i++) {
            vec2 sample_uv = uv + vec2(0.0, float(i) * pixel_size.y * strength * 10.0);
            if (in_bounds(sample_uv)) {
                acc += texture2D(gm_BaseTexture, sample_uv);
                count++;
            }
        }
        gl_FragColor = (count > 0) ? acc / float(count) : base_color;
        
    } else if (u_blur_type == 9) {
        // 十字模糊（十字形）
        vec4 acc = base_color; // 中心点
        float scale = blur_strength * 0.5;
        int total = 1;
        for (int i = 1; i <= 4; i++) {
            float s = float(i) * scale;
            vec2 dx = vec2(s, 0.0) * pixel_size;
            vec2 dy = vec2(0.0, s) * pixel_size;
            if (in_bounds(uv + dx)) { acc += texture2D(gm_BaseTexture, uv + dx); total++; }
            if (in_bounds(uv - dx)) { acc += texture2D(gm_BaseTexture, uv - dx); total++; }
            if (in_bounds(uv + dy)) { acc += texture2D(gm_BaseTexture, uv + dy); total++; }
            if (in_bounds(uv - dy)) { acc += texture2D(gm_BaseTexture, uv - dy); total++; }
        }
        gl_FragColor = acc / float(total);
        
    } else if (u_blur_type == 10) {
        // 星芒模糊（优化版，固定采样点）
        vec4 acc = vec4(0.0);
        int total_samples = 0;
        float ray_length = blur_strength * 0.5; // 控制星芒长度

        for (int p = 0; p < star_points; p++) {
            float angle = float(p) * (3.1415926535 * 2.0 / float(star_points)); // 均匀分布射线
            float c = cos(angle), s = sin(angle);
            vec2 dir = vec2(c, s);

            // 每条射线采样4个点（近强远弱）
            for (int i = 1; i <= 4; i++) {
                float t = float(i) * 0.25; // 0.25, 0.5, 0.75, 1.0
                float weight = 1.0 - t;    // 近处贡献更大
                vec2 sample_uv = uv + dir * ray_length * t;

                if (in_bounds(sample_uv)) {
                    acc += texture2D(gm_BaseTexture, sample_uv) * weight;
                    total_samples++;
                }
            }
        }

        // 归一化：总权重 = 每条射线 (0.75+0.5+0.25+0) = 1.5，共 star_points 条
        float total_weight = 1.5 * float(star_points);
        gl_FragColor = (total_weight > 0.0) ? acc / total_weight : base_color;
        
    } else {
        // 无模糊效果
        gl_FragColor = base_color;
    }
}