/// @desc 检测一个轴对齐矩形是否与当前房间视图（room）相交
/// 
/// 此函数用于快速剔除屏幕外的对象，常用于渲染优化（Frustum Culling）。
/// 矩形由中心点 (_x, _y) 和尺寸 (_w, _h) 定义，视图为整个 room。
/// 
/// 用法示例：
///   // 优化绘制：仅当 sprite 在屏幕内时才绘制
///   var w = sprite_get_width_safe(sprite_index);
///   var h = sprite_get_height_safe(sprite_index);
///   if (rect_intersects_view(x, y, w, h)) {
///       draw_self();
///   }
/// 
///   // 检测 UI 元素是否可见
///   if (rect_intersects_view(ui_x, ui_y, 200, 50)) {
///       // 更新逻辑
///   }
/// 
/// @param _x 矩形中心 x 坐标
/// @param _y 矩形中心 y 坐标
/// @param _w 矩形宽度（像素）
/// @param _h 矩形高度（像素）
/// @returns bool（true = 相交或部分在视图内）
function rect_intersects_view(_x, _y, _w, _h) {
    // 计算矩形边界
    var left = _x - _w * 0.5;
    var right = _x + _w * 0.5;
    var top = _y - _h * 0.5;
    var bottom = _y + _h * 0.5;
    
    // 检测是否与 room [0, room_width] x [0, room_height] 相交
    return (right > 0) && (left < room_width) && (bottom > 0) && (top < room_height);
}