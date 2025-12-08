/// @description 创建专业颜色测试纹理（直接绘制到房间）
/// @param _x 绘制起始X坐标（可选，默认0）
/// @param _y 绘制起始Y坐标（可选，默认0）
/// @param _width 纹理宽度（可选，默认512）
/// @param _height 纹理高度（可选，默认512）
/// @return 0（成功）或 -1（失败）
function create_color_test_texture(_x = 0, _y = 0, _width = 512, _height = 512) {
    // 验证基础参数
    if (_width <= 0 || _height <= 0) {
        show_debug_message("颜色测试纹理创建失败：无效尺寸 " + string(_width) + "x" + string(_height));
        return -1;
    }
    
    // 确保尺寸不超过房间边界
    _width = min(_width, room_width - _x);
    _height = min(_height, room_height - _y);
    
    // 保存原始绘制状态
    var _original_color = draw_get_color();
    
    // ===== 1. 标准色卡（3行×4列）=====
    var _block_size = min(80, floor(_width / 5.0)); // 减小色块比例
    var _margin = 12; // 间隔增大到12像素
    var _cols = 4;
    var _rows = 3;
    var _start_x = _x;
    var _start_y = _y;
    
    // 预定义测试颜色（12色）
    var _test_colors = [
        c_black,        // 0: 纯黑
        c_white,        // 1: 纯白
        make_color_rgb(128, 128, 128),   // 2: 中灰
        make_color_rgb(74, 74, 74),       // 3: 深灰
        
        c_red,          // 4: 红
        c_lime,         // 5: 绿
        c_blue,         // 6: 蓝
        c_yellow,       // 7: 黄
        
        c_fuchsia,      // 8: 品红
        c_aqua,         // 9: 青
        make_color_rgb(255, 128, 0),     // 10: 橙
        make_color_rgb(128, 0, 128)      // 11: 紫
    ];
    
    for (var _i = 0; _i < array_length(_test_colors); _i++) {
        var _row = _i div _cols;
        var _col = _i mod _cols;
        var __x = _start_x + _col * (_block_size + _margin);
        var __y = _start_y + _row * (_block_size + _margin);
        
        draw_set_color(_test_colors[_i]);
        draw_rectangle(__x, __y, __x + _block_size, __y + _block_size, false);
        
        // 标注位置精确对齐参考图（上方18像素）
        if (_i == 0 || _i == 1) {
            draw_set_color(c_white);
            draw_text(__x + 4, __y - 18, _i == 0 ? "0% (0,0,0)" : "100% (255,255,255)");
        }
    }
    
    // ===== 2. 高精度灰阶条（32级）=====
    var _gray_start_y = _start_y + _rows * (_block_size + _margin) + 30;
    var _gray_height = min(40, floor(_height * 0.08));
    var _gray_steps = 32;
    
    for (var _i = 0; _i < _gray_steps; _i++) {
        var _gray_val = _i / (_gray_steps - 1);
        var _c = make_color_rgb(_gray_val * 255, _gray_val * 255, _gray_val * 255);
        var __x1 = _x + _i * (_width / _gray_steps);
        var __x2 = _x + (_i + 1) * (_width / _gray_steps);
        var __y1 = _gray_start_y;
        var __y2 = _gray_start_y + _gray_height;
        
        draw_set_color(_c);
        draw_rectangle(__x1, __y1, __x2, __y2, false);
        
        // 参考图标注位置（0%, 25%, 51%, 77%）
        if (_i == 0) {
            draw_set_color(c_white);
            draw_text(__x1 + 2, __y1 - 18, "0%");
        } else if (_i == 8) {
            draw_set_color(c_white);
            draw_text(__x1 + 2, __y1 - 18, "25%");
        } else if (_i == 16) {
            draw_set_color(c_white);
            draw_text(__x1 + 2, __y1 - 18, "51%");
        } else if (_i == 24) {
            draw_set_color(c_white);
            draw_text(__x1 + 2, __y1 - 18, "77%");
        }
    }
    
    // ===== 3. 极端值验证区（关键修改）=====
    var _ext_y = _gray_start_y + _gray_height + 30;
    var _ext_block = min(45, floor(_width * 0.07)); // 增大色块大小
    var _ext_colors = [
        make_color_rgb(1, 1, 1),       // 1,1,1
        make_color_rgb(8, 8, 8),       // 8,8,8
        make_color_rgb(31, 31, 31),    // 31,31,31
        make_color_rgb(224, 224, 224), // 224,224,224
        make_color_rgb(248, 248, 248), // 248,248,248
        make_color_rgb(254, 254, 254)  // 254,254,254
    ];
    
    var _ext_count = array_length(_ext_colors);
    
    // ===== 核心修改：宽度对齐计算 =====
    // 使极端值验证区总宽度 = 灰阶条宽度 (100%)
    var _ext_margin = max(15, (_width - _ext_count * _ext_block) / (_ext_count - 1));
    var _ext_total_width = _ext_count * _ext_block + (_ext_count - 1) * _ext_margin;
    var _ext_start_x = _x; // 左对齐，不再居中
    
    for (var _i = 0; _i < _ext_count; _i++) {
        var __x = _ext_start_x + _i * (_ext_block + _ext_margin);
        var __y = _ext_y;
        
        draw_set_color(_ext_colors[_i]);
        draw_rectangle(__x, __y, __x + _ext_block, __y + _ext_block, false);
        
        // 标注位置精确匹配参考图（上方16像素）
        var _r = color_get_red(_ext_colors[_i]);
        var _g = color_get_green(_ext_colors[_i]);
        var _b = color_get_blue(_ext_colors[_i]);
        draw_set_color(c_white);
        draw_text(__x + 2, __y - 16, string(_r) + "," + string(_g) + "," + string(_b));
    }
    
    // ===== 4. 色相环验证区（底部）=====
    var _hue_y = _ext_y + _ext_block + 30;
    var _hue_height = min(35, floor(_height * 0.07));
    var _hue_steps = 360;
    
    // 确保色相环区域可见
    if (_hue_y + _hue_height < _y + _height) {
        var _hue_block_width = _width / _hue_steps;
        
        for (var _i = 0; _i < _hue_steps; _i++) {
            var _hue = _i;
            var _c = hsv_to_rgb(_hue, 1.0, 1.0);
            var __x1 = _x + _i * _hue_block_width;
            var __x2 = _x + (_i + 1) * _hue_block_width;
            var __y1 = _hue_y;
            var __y2 = _hue_y + _hue_height;
            
            draw_set_color(_c);
            draw_rectangle(__x1, __y1, __x2, __y2, false);
            
            // 每60度标记（与参考图一致）
            if (_i % 60 == 0) {
                draw_set_color(c_white);
                draw_text(__x1 + 2, __y1 - 18, string(_i) + "°");
            }
        }
    }
    
    // 恢复原始绘制状态
    draw_set_color(_original_color);
    return 0;
}

// HSV to RGB 转换函数 (H:0-360, S:0-1, V:0-1)
function hsv_to_rgb(_h, _s, _v) {
    _h = _h mod 360;
    var _c = _v * _s;
    var _x = _c * (1 - abs((_h / 60) mod 2 - 1));
    var _m = _v - _c;
    
    var _r, _g, _b;
    
    if (_h < 60) {
        _r = _c; _g = _x; _b = 0;
    } else if (_h < 120) {
        _r = _x; _g = _c; _b = 0;
    } else if (_h < 180) {
        _r = 0; _g = _c; _b = _x;
    } else if (_h < 240) {
        _r = 0; _g = _x; _b = _c;
    } else if (_h < 300) {
        _r = _x; _g = 0; _b = _c;
    } else {
        _r = _c; _g = 0; _b = _x;
    }
    
    _r = (_r + _m) * 255;
    _g = (_g + _m) * 255;
    _b = (_b + _m) * 255;
    
    return make_color_rgb(_r, _g, _b);
}