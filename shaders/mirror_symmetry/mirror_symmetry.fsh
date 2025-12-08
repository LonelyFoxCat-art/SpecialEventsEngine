varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float symmetry_mode;     // 0=无, 1=水平, 2=垂直, 3=双向
uniform float symmetry_axis;    // 对称轴位置 (0-1)
uniform float symmetry_strength; // 对称强度 (0-1)

void main() {
    vec2 coord = v_vTexcoord;
    vec4 base_color = v_vColour * texture2D(gm_BaseTexture, coord);
    
    // 无对称效果
    if (symmetry_mode == 0.0 || symmetry_strength <= 0.0) {
        gl_FragColor = base_color;
        return;
    }
    
    // 关键修正：确保镜像坐标在[0,1]范围内
    vec2 mirror_coord = coord;
    bool in_valid_region = true;
    
    // 水平对称处理
    if (symmetry_mode == 1.0 || symmetry_mode == 3.0) {
        mirror_coord.x = symmetry_axis + (symmetry_axis - coord.x);
        // 防止镜像坐标超出纹理范围
        if (mirror_coord.x < 0.0 || mirror_coord.x > 1.0) {
            in_valid_region = false;
        }
    }
    
    // 垂直对称处理
    if (symmetry_mode == 2.0 || symmetry_mode == 3.0) {
        mirror_coord.y = symmetry_axis + (symmetry_axis - coord.y);
        // 防止镜像坐标超出纹理范围
        if (mirror_coord.y < 0.0 || mirror_coord.y > 1.0) {
            in_valid_region = false;
        }
    }
    
    // 采样镜像纹理（仅在有效区域内）
    vec4 mirror_color = base_color; // 默认使用原始颜色
    if (in_valid_region) {
        mirror_color = texture2D(gm_BaseTexture, mirror_coord);
    }
    
    // 核心逻辑：两侧完整显示（100%可见）
    vec4 final_color;
    
    // 水平对称
    if (symmetry_mode == 1.0 || symmetry_mode == 3.0) {
        if (coord.x < symmetry_axis) {
            final_color = base_color; // 原始区域
        } else {
            final_color = mirror_color; // 镜像区域
        }
    }
    // 垂直对称（类似处理）
    else if (symmetry_mode == 2.0) {
        if (coord.y < symmetry_axis) {
            final_color = base_color;
        } else {
            final_color = mirror_color;
        }
    }
    
    // 应用对称强度
    if (symmetry_strength < 1.0) {
        final_color = mix(base_color, final_color, symmetry_strength);
    }
    
    // 保留原始透明度
    gl_FragColor = vec4(final_color.rgb, base_color.a);
}