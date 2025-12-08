// CinemaGradePro Shader v1.4
// 作者：狐猫雨空
// 专业级电影调色着色器，支持完整色彩处理流程

// ======== 功能 ========
// • 色彩校正：白平衡、色阶、曲线、色轮
// • 色彩分级：阴影/中间调/高光独立调色
// • 色彩空间：RGB/XYZ/Lab/YUV转换与诊断
// • 色调映射：多种HDR→LDR算法 (ACES/Reinhard/Uncharted2)
// • 高级效果：色键抠图、色差校正、通道混合、色彩溢出控制
// • 多通道输出：RGBA通道独立处理

// ======== 特性 ========
// • 所有功能可独立开关，无性能损失
// • 透明区域早期退出优化
// • 自动钳位至[0,1]范围
// • Rec.709/Rec.2020/sRGB色彩标准支持
// • 三模式饱和度控制 (RGB/HSL/HSV)
// • 12种灰度算法支持
// • 兼容标准GPU架构

// ======== 使用提示 ========
// 1. 功能流水线顺序：色差→白平衡→色阶→色彩校正→色调映射→特效
// 2. 高饱和保护：先应用色彩校正，再启用饱和度限制
// 3. 色键抠图：建议在色彩校正后、最终输出前应用
// 4. 多通道输出：作为最后一道处理工序
// 5. 性能优化：禁用未使用的功能模块

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec2 v_vScreenPos;								// 屏幕空间坐标 [0,1]

// ======== 全局控制 ========
uniform bool u_enable_dissolve;							// 启用溶解/淡入淡出
uniform float u_dissolveAmount;							// 溶解比例 [0=原图, 1=完全溶解]

// ======== 功能总开关 ========
uniform bool u_enable_color_modulation;					// 颜色调制
uniform bool u_enable_levels;							// 色阶
uniform bool u_enable_white_balance;					// 色温/白平衡
uniform bool u_enable_grayscale;						// 灰度/黑白
uniform bool u_enable_saturation;						// 饱和度
uniform bool u_enable_contrast_brightness;				// 对比度/亮度
uniform bool u_enable_keying;							// 色键抠图
uniform bool u_enable_batch_grade;						// 批量调色（LUT模拟）
uniform bool u_enable_tonemap;							// 色调映射
uniform bool u_enable_invert_desaturate;				// 去色/反色
uniform bool u_enable_chromatic_aberration;				// 色差校正
uniform bool u_enable_auto_grade;						// 自动调色
uniform bool u_enable_colorspace_convert;				// 色彩空间转换（内部使用）
uniform bool u_enable_curves;							// RGB曲线
uniform bool u_enable_hsl;								// HSL/HSV调整
uniform bool u_enable_color_grading;					// 色彩分级
uniform bool u_enable_color_correction;					// 色彩校正（色轮）
uniform bool u_enable_channel_mixer;					// 通道混合
uniform bool u_enable_saturation_clamp;					// 色彩溢出控制
uniform bool u_enable_multi_output;						// 多通道输出

// ======== 颜色调制 ========
uniform vec3 u_color_tint;								// RGB偏移 [0,1]

// ======== 色阶控制 ========
uniform vec3 u_input_black;								// 输入黑点 [0,1]
uniform vec3 u_input_white;								// 输入白点 [0,1]
uniform vec3 u_gamma;									// 伽马 [0.1, 5.0]
uniform vec3 u_output_black;							// 输出黑点
uniform vec3 u_output_white;							// 输出白点

// ======== 白平衡 ========
uniform float u_temperature;							// 色温 [-1,1] → 2000K~10000K
uniform float u_tint;									// 绿-品红偏移 [-1,1]

// ======== 灰度控制 ========
uniform int u_grayscale_method;							// 0=平均,1=BT.601,2=Rec.709,3=最大值,4=最小值,5=Luma,6=Perceptual,7=HSV值,8=HSL亮度,9=R通道,10=G通道,11=B通道
uniform float u_grayscale_strength;						// 灰度强度 [0,1] → 0=原色,1=完全灰度

// ======== 饱和度控制 ========
uniform int u_saturation_mode;							// 0=RGB,1=HSL,2=HSV
uniform float u_saturation;								// [-1,1] → -1=去色,0=原色,+1=双倍饱和

// ======== 对比度/亮度 ========
uniform float u_brightness;								// [-1,1]
uniform float u_contrast;								// [-1,1]

// ======== 色键抠图 ========
uniform vec3 u_keyColor;								// 要抠出的颜色 (RGB)
uniform float u_keyTolerance;							// 容差 [0,1]
uniform float u_keyFalloff;								// 边缘柔化 [0,1]
uniform float u_keyAlpha;								// 抠像后透明度 [0,1]

// ======== 批量调色 ========
uniform vec3 u_batch_tint_shadows;
uniform vec3 u_batch_tint_midtones;
uniform vec3 u_batch_tint_highlights;

// ======== 色调映射 ========
uniform int u_tonemap_algorithm;						// 0=Linear, 1=Reinhard, 2=Uncharted2, 3=ACES, 4=Filmic
uniform float u_exposure;								// [-3, 3]
uniform float u_gamma_tonemap;							// [0.1, 3.0]

// ======== 去色/反色 ========
uniform bool u_invert;									// 反色
uniform bool u_desaturate;								// 去色

// ======== 色差校正 ========
uniform float u_aberration_strength;					// [0, 0.1] → 校正强度

// ======== 自动调色 ========
uniform float u_auto_tone_black;						// 自动色调黑场 [0,1]（由CPU预计算）
uniform float u_auto_tone_white;						// 自动色调白场 [0,1]（由CPU预计算）

// ======== 色彩空间诊断模式 ========
uniform int u_colorspace_debug_mode;					// 0=无, 1=XYZ, 2=Lab L*, 3=Lab a/b, 4=YUV, 5=通道分离, 6=色相环
uniform int u_colorspace_standard;						// 0=Rec.709, 1=Rec.2020, 2=sRGB
uniform int u_selected_channel;							// 0=R,1=G,2=B (用于通道分离视图)
uniform float u_luminance_boost;						// 亮度增强 [0,2]

// ======== RGB曲线（三次贝塞尔）=====
uniform vec4 u_curve_red;								// (x0,y0,x1,y1) 控制点
uniform vec4 u_curve_green;
uniform vec4 u_curve_blue;

// ======== HSL调整 ========
uniform float u_hue_shift;								// 色相偏移 [-180,180] 度
uniform float u_saturation_hsl;							// 额外饱和度调整 [-1,1]
uniform float u_lightness;								// 亮度调整 [-1,1]

// ======== 色彩分级 ========
uniform vec3 u_shadows_tint;
uniform vec3 u_midtones_tint;
uniform vec3 u_highlights_tint;
uniform float u_shadows_range;
uniform float u_highlights_range;

// ======== 色彩校正 ========
uniform vec3 u_lift;									// 阴影偏移
uniform vec3 u_gamma_corr;								// 中间调（伽马）
uniform vec3 u_gain;									// 高光增益

// ======== 通道混合 ========
uniform vec3 u_red_mixer;								// [R_from_R, R_from_G, R_from_B]
uniform vec3 u_green_mixer;
uniform vec3 u_blue_mixer;

// ======== 色彩溢出控制 ========
uniform float u_saturation_clamp_threshold;				// 饱和阈值 [0,1]
uniform float u_saturation_clamp_strength;				// 压缩强度 [0,1]

// ======== 多通道输出控制 ========
uniform bool u_multi_output_enable_rgb_mix;				// 启用RGB通道混合
uniform bool u_multi_output_enable_alpha_processing;	// 启用Alpha通道处理
uniform vec3 u_multi_output_r_channel;					// R输出通道的RGB混合系数
uniform vec3 u_multi_output_g_channel;					// G输出通道的RGB混合系数
uniform vec3 u_multi_output_b_channel;					// B输出通道的RGB混合系数
uniform float u_multi_output_a_gamma;					// Alpha通道伽马 [0.1, 3.0]
uniform float u_multi_output_a_gain;					// Alpha通道增益 [0.0, 2.0]
uniform vec3 u_multi_output_channel_offset;				// RGB通道偏移 [-0.5, 0.5]
uniform float u_multi_output_a_offset;					// Alpha通道偏移 [-0.5, 0.5]

// ======== 内部常量 ========
const vec3 LUMA_WEIGHTS = vec3(0.2126, 0.7152, 0.0722); // Rec.709 亮度权重
const vec3 WHITE_D65 = vec3(0.95047, 1.00000, 1.08883); // D65 标准白点
const float EPSILON = 0.000001;							// 避免除以零

// 色彩空间标准矩阵
const mat3 RGB_TO_XYZ_REC709 = mat3(
    0.4124564, 0.3575761, 0.1804375,
    0.2126729, 0.7151522, 0.0721750,
    0.0193339, 0.1191920, 0.9503041
);

const mat3 XYZ_TO_RGB_REC709 = mat3(
    3.2404542, -1.5371385, -0.4985314,
    -0.9692660, 1.8760108, 0.0415560,
    0.0556434, -0.2040259, 1.0572252
);

const mat3 RGB_TO_XYZ_REC2020 = mat3(
    0.6369580, 0.1446169, 0.1688810,
    0.2627002, 0.6779981, 0.0593017,
    0.0000000, 0.0280727, 1.0609851
);

// ========== 工具函数 ==========

// RGB → XYZ 色彩空间转换
vec3 rgb_to_xyz(vec3 rgb, int standard) {
    if (standard == 1) {
        return RGB_TO_XYZ_REC2020 * rgb;
    } else {
        return RGB_TO_XYZ_REC709 * rgb;
    }
}

// XYZ → RGB 色彩空间转换
vec3 xyz_to_rgb(vec3 xyz, int standard) {
    vec3 rgb;
    if (standard == 1) {
        mat3 XYZ_TO_RGB_REC2020 = mat3(
            1.716651, -0.355671, -0.253366,
            -0.666684, 1.616481, 0.015768,
            0.017640, -0.042771, 0.942103
        );
        rgb = XYZ_TO_RGB_REC2020 * xyz;
    } else {
        rgb = XYZ_TO_RGB_REC709 * xyz;
    }
  
    if (standard == 2) {
        rgb = mix(pow(rgb, vec3(1.0/2.4)) * 1.055 - 0.055, rgb * 12.92, 
                 step(rgb, vec3(0.0031308)));
    }
    
    return clamp(rgb, 0.0, 1.0);
}

// XYZ → Lab
vec3 xyz_to_lab(vec3 xyz) {
    vec3 xyz_norm = xyz / WHITE_D65;

    float fx = (xyz_norm.x > 0.008856) ? pow(xyz_norm.x, 1.0/3.0) : (7.787 * xyz_norm.x + 16.0/116.0);
    float fy = (xyz_norm.y > 0.008856) ? pow(xyz_norm.y, 1.0/3.0) : (7.787 * xyz_norm.y + 16.0/116.0);
    float fz = (xyz_norm.z > 0.008856) ? pow(xyz_norm.z, 1.0/3.0) : (7.787 * xyz_norm.z + 16.0/116.0);
    float L = (xyz_norm.y > 0.008856) ? (116.0 * fy - 16.0) : (903.3 * xyz_norm.y);

    float a = 500.0 * (fx - fy);
    float b = 200.0 * (fy - fz);
    
    return vec3(L / 100.0, a / 127.0, b / 127.0);
}

// RGB → Lab
vec3 rgb_to_lab(vec3 rgb) {
    return xyz_to_lab(rgb_to_xyz(rgb, u_colorspace_standard));
}

// 优化的RGB → HSL 色彩空间转换
vec3 rgb_to_hsl(vec3 rgb) {
    float minv = min(rgb.r, min(rgb.g, rgb.b));
    float maxv = max(rgb.r, max(rgb.g, rgb.b));
    float delta = maxv - minv;
    float l = (maxv + minv) * 0.5;
    float h = 0.0, s = 0.0;
    
    if (delta > EPSILON) {
        s = delta / (1.0 - abs(2.0 * l - 1.0));
        
        if (rgb.r == maxv) {
            h = (rgb.g - rgb.b) / delta + (rgb.g < rgb.b ? 6.0 : 0.0);
        } else if (rgb.g == maxv) {
            h = (rgb.b - rgb.r) / delta + 2.0;
        } else {
            h = (rgb.r - rgb.g) / delta + 4.0;
        }
        h /= 6.0;
    }
    
    return vec3(h, s, l);
}

// 优化的HSL → RGB 色彩空间转换
vec3 hsl_to_rgb(vec3 hsl) {
    float h = hsl.x * 6.0;
    float s = hsl.y;
    float l = hsl.z;
    
    float c = (1.0 - abs(2.0 * l - 1.0)) * s;
    float x = c * (1.0 - abs(mod(h, 2.0) - 1.0));
    float m = l - c * 0.5;
    
    vec3 rgb;
    if (h < 1.0) rgb = vec3(c, x, 0);
    else if (h < 2.0) rgb = vec3(x, c, 0);
    else if (h < 3.0) rgb = vec3(0, c, x);
    else if (h < 4.0) rgb = vec3(0, x, c);
    else if (h < 5.0) rgb = vec3(x, 0, c);
    else rgb = vec3(c, 0, x);
    
    return rgb + m;
}

// 优化的RGB → HSV 色彩空间转换
vec3 rgb_to_hsv(vec3 rgb) {
    float minv = min(rgb.r, min(rgb.g, rgb.b));
    float maxv = max(rgb.r, max(rgb.g, rgb.b));
    float delta = maxv - minv;
    float h = 0.0, s = 0.0, v = maxv;
    
    if (delta > EPSILON) {
        s = delta / maxv;
        
        if (rgb.r == maxv) {
            h = (rgb.g - rgb.b) / delta + (rgb.g < rgb.b ? 6.0 : 0.0);
        } else if (rgb.g == maxv) {
            h = (rgb.b - rgb.r) / delta + 2.0;
        } else {
            h = (rgb.r - rgb.g) / delta + 4.0;
        }
        h /= 6.0;
    }
    
    return vec3(h, s, v);
}

// 优化的HSV → RGB 色彩空间转换
vec3 hsv_to_rgb(vec3 hsv) {
    float h = hsv.x * 6.0;
    float s = hsv.y;
    float v = hsv.z;
    
    float c = v * s;
    float x = c * (1.0 - abs(mod(h, 2.0) - 1.0));
    float m = v - c;
    
    vec3 rgb;
    if (h < 1.0) rgb = vec3(c, x, 0);
    else if (h < 2.0) rgb = vec3(x, c, 0);
    else if (h < 3.0) rgb = vec3(0, c, x);
    else if (h < 4.0) rgb = vec3(0, x, c);
    else if (h < 5.0) rgb = vec3(x, 0, c);
    else rgb = vec3(c, 0, x);
    
    return rgb + m;
}

// 改进的灰度转换函数
vec3 apply_grayscale(vec3 color, int method) {
    vec3 gray;
    
    if (method == 0) { // Average
        gray = vec3(dot(color, vec3(1.0/3.0)));
    } else if (method == 1) { // ITU-R BT.601
        gray = vec3(dot(color, vec3(0.299, 0.587, 0.114)));
    } else if (method == 2) { // Rec.709
        gray = vec3(dot(color, vec3(0.2126, 0.7152, 0.0722)));
    } else if (method == 3) { // Max
        gray = vec3(max(color.r, max(color.g, color.b)));
    } else if (method == 4) { // Min
        gray = vec3(min(color.r, min(color.g, color.b)));
    } else if (method == 5) { // Luma (ITU-R BT.601 亮度)
        gray = vec3(0.299 * color.r + 0.587 * color.g + 0.114 * color.b);
    } else if (method == 6) { // Perceptual (Rec.709 亮度)
        gray = vec3(0.2126 * color.r + 0.7152 * color.g + 0.0722 * color.b);
    } else if (method == 7) { // HSV Value
        gray = vec3(max(color.r, max(color.g, color.b)));
    } else if (method == 8) { // HSL Lightness
        float max_val = max(color.r, max(color.g, color.b));
        float min_val = min(color.r, min(color.g, color.b));
        gray = vec3((max_val + min_val) * 0.5);
    } else if (method == 9) { // Red Channel Only
        gray = vec3(color.r);
    } else if (method == 10) { // Green Channel Only
        gray = vec3(color.g);
    } else if (method == 11) { // Blue Channel Only
        gray = vec3(color.b);
    } else { // Default to Rec.709
        gray = vec3(dot(color, LUMA_WEIGHTS));
    }
    
    return gray;
}

// 色彩空间诊断视图
void apply_colorspace_debug(inout vec3 color, int debug_mode) {
    if (debug_mode == 1) { // XYZ色彩空间
        vec3 xyz = rgb_to_xyz(color, u_colorspace_standard);
        xyz = clamp(xyz * 0.8, 0.0, 1.0);
        color = xyz;
    } else if (debug_mode == 2) { // Lab L*通道
        vec3 lab = rgb_to_lab(color);
        float L = lab.x;
        color = vec3(L * (1.0 + u_luminance_boost));
    } else if (debug_mode == 3) { // Lab a/b通道
        vec3 lab = rgb_to_lab(color);
        float a = lab.y * 0.5 + 0.5;
        float b = lab.z * 0.5 + 0.5;
        color = vec3(a, b, 0.0);
    } else if (debug_mode == 4) { // YUV/YCbCr色彩空间
        float Y = dot(color, vec3(0.2126, 0.7152, 0.0722));
        float U = (color.b - Y) * 0.565;
        float V = (color.r - Y) * 0.713;
        
        color = vec3(Y * (1.0 + u_luminance_boost), 0.5 + U, 0.5 + V);
    } else if (debug_mode == 5) { // 通道分离视图
        float channel_value = (u_selected_channel == 0) ? color.r : (u_selected_channel == 1) ? color.g : color.b;
        color = vec3(channel_value);
    } else if (debug_mode == 6) { // 色相环视图
        vec3 hsv = rgb_to_hsv(color);
        float angle = hsv.x * 6.28318530718;
        color = vec3(0.5 + 0.5 * cos(angle), 0.5 + 0.5 * cos(angle + 2.09439510239), 0.5 + 0.5 * cos(angle + 4.18879020479));
    }
}

// Reinhard 色调映射
vec3 tonemap_reinhard(vec3 color) {
    return color / (color + vec3(1.0));
}

// Uncharted2 色调映射（来自 John Hable）
vec3 tonemap_uncharted2(vec3 color) {
    const float A = 0.15;
    const float B = 0.50;
    const float C = 0.10;
    const float D = 0.20;
    const float E = 0.02;
    const float F = 0.30;
    color = ((color*(A*color+C*B)+D*E)/(color*(A*color+B)+D*F))-E/F;
    return color;
}

// ACES 色调映射（电影工业标准）
vec3 tonemap_aces(vec3 color) {
    const mat3 aces_input_mat = mat3(
        0.59719, 0.35458, 0.04823,
        0.07600, 0.90834, 0.01566,
        0.02840, 0.13383, 0.83777
    );
    const mat3 aces_output_mat = mat3(
        1.60475, -0.53108, -0.07367,
        -0.10208, 1.10813, -0.00605,
        -0.00327, -0.07276, 1.07602
    );
    color = aces_input_mat * color;
    color = max(vec3(0.0), color - 0.004);
    color = (color * (6.2 * color + 0.5)) / (color * (6.2 * color + 1.7) + 0.06);
    color = aces_output_mat * color;
    return clamp(color, 0.0, 1.0);
}

// Filmic 色调映射（类似 Unity）
vec3 tonemap_filmic(vec3 color) {
    color = max(vec3(0.0), color - 0.004);
    color = (color * (6.2 * color + 0.5)) / (color * (6.2 * color + 1.7) + 0.06);
    return color;
}

// 贝塞尔曲线插值（用于RGB曲线）
float eval_curve(float x, vec4 p) {
    float t = x;
    return mix(mix(0.0, p.y, t), mix(p.w, 1.0, t), t);
}

// 色温校正（基于R、B通道缩放）
vec3 apply_white_balance(vec3 color, float temperature, float tint) {
    float temp_factor = (temperature + 1.0) * 0.5; // [-1,1] → [0,1]
    float r_scale = 1.0 + (temp_factor - 0.5) * 0.8; // 暖时 R↑, 冷时 R↓
    float b_scale = 1.0 - (temp_factor - 0.5) * 0.8; // 暖时 B↓, 冷时 B↑

    float g_scale = 1.0 - abs(tint) * 0.3;
    if (tint > 0.0) {
        color.r += tint * 0.2;
        color.b += tint * 0.2;
    } else if (tint < 0.0) {
        color.g -= tint * 0.2;
    }

    color.r *= r_scale;
    color.b *= b_scale;
    color.g *= g_scale;

    return clamp(color, 0.0, 1.0);
}

// 色阶调整
vec3 apply_levels(vec3 color, vec3 inBlack, vec3 inWhite, vec3 gamma, vec3 outBlack, vec3 outWhite) {
    vec3 normalized = (color - inBlack) / max((inWhite - inBlack), vec3(EPSILON));
    normalized = pow(clamp(normalized, 0.0, 1.0), 1.0 / max(gamma, vec3(EPSILON)));
    return mix(outBlack, outWhite, normalized);
}

// 色彩分级
vec3 apply_color_grading(vec3 color, vec3 shadows, vec3 midtones, vec3 highlights, float shadows_range, float highlights_range) {
    float luminance = dot(color, LUMA_WEIGHTS);
    float shadow_weight = smoothstep(shadows_range * 0.5, shadows_range, luminance);
    float highlight_weight = smoothstep(1.0 - highlights_range, 1.0 - highlights_range * 0.5, luminance);
    float mid_weight = 1.0 - shadow_weight - highlight_weight;
    return color * (shadow_weight * shadows + mid_weight * midtones + highlight_weight * highlights);
}

// 自动色调（Photoshop 风格）
vec3 applyPhotoshopAutoTone(vec3 color, float black_point, float white_point) {
    float luma = dot(color, LUMA_WEIGHTS);
    float range = max(white_point - black_point, EPSILON);
    float stretched_luma = (luma - black_point) / range;
    stretched_luma = clamp(stretched_luma, 0.0, 1.0);
    
    vec3 result;
    if (luma > EPSILON) {
        result = color * (stretched_luma / luma);
    } else {
        result = vec3(stretched_luma);
    }
    
    float new_luma = dot(result, LUMA_WEIGHTS);
    result = mix(vec3(new_luma), result, 1.05);
    
    return clamp(result, 0.0, 1.0);
}

// 多通道输出处理
vec4 apply_multi_output(vec3 color, float alpha) {
    vec3 original_rgb = color;
    float original_alpha = alpha;
    
    if (u_multi_output_enable_rgb_mix) {
        vec3 new_r = vec3(
            dot(original_rgb, u_multi_output_r_channel),
            dot(original_rgb, u_multi_output_g_channel),
            dot(original_rgb, u_multi_output_b_channel)
        );
        color = new_r;
    }
    
    color += u_multi_output_channel_offset;
    
    if (u_multi_output_enable_alpha_processing) {
        alpha = pow(clamp(original_alpha * u_multi_output_a_gain, 0.0, 1.0), u_multi_output_a_gamma);
        alpha += u_multi_output_a_offset;
    }
    
    color = clamp(color, 0.0, 1.0);
    alpha = clamp(alpha, 0.0, 1.0);
    
    return vec4(color, alpha);
}

// ======== 主函数 ========
void main() {
    vec2 uv = v_vTexcoord;
    vec4 baseColor = texture2D(gm_BaseTexture, uv);
    
    // 透明区域优化
    if (baseColor.a <= 0.0) {
        gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
        return;
    }

    vec3 color = baseColor.rgb;
    float alpha = baseColor.a;

    // ======== 溶解（始终最后应用，但需提前采样） ========
    float dissolve_mask = 1.0;
    if (u_enable_dissolve) {
        dissolve_mask = texture2D(gm_BaseTexture, uv).a; // 使用同一纹理的alpha
    }

    // ======== 功能流水线（按合理顺序） ========

    // 色差校正
	if (u_enable_chromatic_aberration) {
	    vec2 dir = v_vTexcoord - 0.5;
	    float dist = length(dir);
    
	    if (dist > 0.0) {
	        vec2 normalized_dir = normalize(dir);
	        vec2 correction = normalized_dir * dist * (-u_aberration_strength);
        
	        vec3 color_r = texture2D(gm_BaseTexture, v_vTexcoord + correction * 0.5).rgb;
	        vec3 color_g = texture2D(gm_BaseTexture, v_vTexcoord).rgb;
	        vec3 color_b = texture2D(gm_BaseTexture, v_vTexcoord - correction * 0.5).rgb;
        
	        color = vec3(color_r.r, color_g.g, color_b.b);
	    }
	}

    // 白平衡
    if (u_enable_white_balance) {
        color = apply_white_balance(color, u_temperature, u_tint);
    }

    // 色阶
    if (u_enable_levels) {
        color = apply_levels(color, u_input_black, u_input_white, u_gamma, u_output_black, u_output_white);
    }

    // 色彩空间转换
    if (u_enable_colorspace_convert) {
        if (u_colorspace_debug_mode > 0) {
            apply_colorspace_debug(color, u_colorspace_debug_mode);
        }
    }

    // HSL调整
    if (u_enable_hsl) {
        vec3 hsl = rgb_to_hsl(color);
        hsl.x = fract(hsl.x + u_hue_shift / 360.0);
        hsl.y = clamp(hsl.y + u_saturation_hsl, 0.0, 1.0);
        hsl.z = clamp(hsl.z + u_lightness, 0.0, 1.0);
        color = hsl_to_rgb(hsl);
    }
    
    // 饱和度
    if (u_enable_saturation) {
        if (u_saturation_mode == 0) {
            // RGB 饱和度
            float luminance = dot(color, LUMA_WEIGHTS);
            color = mix(vec3(luminance), color, 1.0 + u_saturation);
        } else if (u_saturation_mode == 1) {
            // HSL 饱和度
            vec3 hsl = rgb_to_hsl(color);
            hsl.y = clamp(hsl.y * (1.0 + u_saturation), 0.0, 1.0);
            color = hsl_to_rgb(hsl);
        } else {
            // HSV 饱和度
            vec3 hsv = rgb_to_hsv(color);
            hsv.y = clamp(hsv.y * (1.0 + u_saturation), 0.0, 1.0);
            color = hsv_to_rgb(hsv);
        }
    }

    // 对比度/亮度
    if (u_enable_contrast_brightness) {
        color = (color - 0.5) * (1.0 + u_contrast) + 0.5 + u_brightness;
    }

    // RGB曲线
    if (u_enable_curves) {
        color.r = eval_curve(color.r, u_curve_red);
        color.g = eval_curve(color.g, u_curve_green);
        color.b = eval_curve(color.b, u_curve_blue);
    }

    // 色彩校正（色轮）
    if (u_enable_color_correction) {
        color = color * (1.0 + u_gain) + u_lift;
        color = pow(color, 1.0 / (1.0 + u_gamma_corr));
    }

    // 色彩分级
    if (u_enable_color_grading) {
        color = apply_color_grading(color, u_shadows_tint, u_midtones_tint, u_highlights_tint, u_shadows_range, u_highlights_range);
    }

    // 通道混合
    if (u_enable_channel_mixer) {
        vec3 newColor;
        newColor.r = dot(color, u_red_mixer);
        newColor.g = dot(color, u_green_mixer);
        newColor.b = dot(color, u_blue_mixer);
        color = newColor;
    }

    // 批量调色
    if (u_enable_batch_grade) {
        float lum = dot(color, LUMA_WEIGHTS);
        vec3 tint = mix(u_batch_tint_shadows, u_batch_tint_highlights, smoothstep(0.0, 1.0, lum));
        tint = mix(tint, u_batch_tint_midtones, 1.0 - abs(lum - 0.5) * 2.0);
        color *= tint;
    }

    // 色调映射
    if (u_enable_tonemap) {
        color = color * pow(2.0, u_exposure);

        // 根据算法选择色调映射
        if (u_tonemap_algorithm == 0) {
            // Linear: 无处理（仅曝光）
        } else if (u_tonemap_algorithm == 1) {
            // Reinhard
            color = tonemap_reinhard(color);
        } else if (u_tonemap_algorithm == 2) {
            // Uncharted2
            color = tonemap_uncharted2(color);
        } else if (u_tonemap_algorithm == 3) {
            // ACES
            color = tonemap_aces(color);
        } else if (u_tonemap_algorithm == 4) {
            // Filmic
            color = tonemap_filmic(color);
        }

        color = pow(color, vec3(1.0 / u_gamma_tonemap));
    }

    // 自动调色
    if (u_enable_auto_grade) {
        color = applyPhotoshopAutoTone(color, u_auto_tone_black, u_auto_tone_white);
    }

    // 去色 / 反色
    if (u_enable_invert_desaturate) {
        if (u_desaturate) {
            float gray = dot(color, LUMA_WEIGHTS);
            color = vec3(gray);
        }
        if (u_invert) {
            color = 1.0 - color;
        }
    }

    // 灰度
    if (u_enable_grayscale) {
        vec3 gray = apply_grayscale(color, u_grayscale_method);
        color = mix(color, gray, u_grayscale_strength);
    }
    
    // 颜色调制
    if (u_enable_color_modulation) {
        color = clamp(color + u_color_tint, 0.0, 1.0);
    }

    // 色彩溢出控制
    if (u_enable_saturation_clamp) {
        vec3 intensity = vec3(dot(color, LUMA_WEIGHTS));
        float sat = length(color - intensity);
        if (sat > u_saturation_clamp_threshold) {
            float ratio = 1.0 - (sat - u_saturation_clamp_threshold) * u_saturation_clamp_strength;
            color = intensity + (color - intensity) * ratio;
        }
    }

    // 色键抠图
    if (u_enable_keying) {
        vec3 _diff = abs(color - u_keyColor);
        float max_diff = max(_diff.r, max(_diff.g, _diff.b));
        float alpha_temp = smoothstep(u_keyTolerance, u_keyTolerance + u_keyFalloff, max_diff);
        color = mix(vec3(0.0), color, alpha_temp);
        alpha *= mix(u_keyAlpha, 1.0, alpha_temp);
    }

    // 多通道输出 (RGBA独立处理)
    if (u_enable_multi_output) {
        vec4 multi_output = apply_multi_output(color, alpha);
        color = multi_output.rgb;
        alpha = multi_output.a;
    }

    // 钳位
    color = clamp(color, 0.0, 1.0);
    alpha = clamp(alpha, 0.0, 1.0);

    // 应用溶解
    if (u_enable_dissolve) {
        float final_dissolve = u_dissolveAmount * dissolve_mask;
        color = mix(color, vec3(0.0), final_dissolve);
        alpha *= (1.0 - final_dissolve);
    }

    // 输出最终颜色
    gl_FragColor = vec4(color, alpha);
}