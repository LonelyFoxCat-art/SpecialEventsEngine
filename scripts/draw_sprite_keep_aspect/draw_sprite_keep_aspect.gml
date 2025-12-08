/// @desc 在最大宽/高约束下绘制 sprite（自动保持宽高比，避免拉伸）
/// 
/// 此函数允许你指定 sprite 绘制的最大宽度和/或最大高度。
/// 实际绘制尺寸会按原始宽高比缩放，确保不超出指定约束。
/// 
/// 用法示例：
///   // 限制在 64x64 区域内（居中显示，保持比例）
///   draw_sprite_constrain(spr_icon, 100, 100, 64, 64);
///   
///   // 仅限制最大宽度为 200（高度自动适配）
///   draw_sprite_constrain(spr_banner, 300, 200, 200, -1);
///   
///   // 仅限制最大高度为 50
///   draw_sprite_constrain(spr_portrait, 400, 300, -1, 50);
///   
///   // 无约束（等价于 draw_sprite）
///   draw_sprite_constrain(spr_background, 500, 400);
/// 
/// @param _sprite_index 要绘制的 sprite 索引
/// @param _x 绘制中心 x 坐标
/// @param _y 绘制中心 y 坐标
/// @param _max_width 最大宽度（像素），-1 表示无限制（默认 -1）
/// @param _max_height 最大高度（像素），-1 表示无限制（默认 -1）
/// @param _color 混合颜色（默认 c_white）
/// @param _alpha 透明度（0~1，默认 1）
function draw_sprite_constrain(_sprite_index, _x, _y, _max_width = -1, _max_height = -1, _color = c_white, _alpha = 1) {
    if (!sprite_exists(_sprite_index)) return;
    
    var src_w = sprite_get_width(_sprite_index);
    var src_h = sprite_get_height(_sprite_index);
    if (src_w <= 0 || src_h <= 0) return;
    
    var scale_x = 1;
    var scale_y = 1;
    
    if (_max_width > 0 && _max_height > 0) {
        // 同时限制宽高 → "contain" 模式
        scale_x = _max_width / src_w;
        scale_y = _max_height / src_h;
        var scale = min(scale_x, scale_y);
        scale_x = scale;
        scale_y = scale;
    } else if (_max_width > 0) {
        // 仅限制宽度
        scale_x = _max_width / src_w;
        scale_y = scale_x;
    } else if (_max_height > 0) {
        // 仅限制高度
        scale_y = _max_height / src_h;
        scale_x = scale_y;
    }
    // 若都 ≤0，则按原始尺寸绘制（scale=1）
    
    draw_sprite_ext(_sprite_index, -1, _x, _y, scale_x, scale_y, 0, _color, _alpha);
}