/// @function                  collision_mouse_rectangle(X, Y, Width, Height, [Angle], [OriginX], [OriginY])
/// @param      {real}         X           - 矩形左上角X坐标（未旋转时）
/// @param      {real}         Y           - 矩形左上角Y坐标（未旋转时）
/// @param      {real}         Width       - 矩形宽度
/// @param      {real}         Height      - 矩形高度
/// @param      {real}         [Angle]     - 旋转角度（度，默认0）
/// @param      {real}         [OriginX]   - 旋转原点X（相对于矩形，默认Width/2）
/// @param      {real}         [OriginY]   - 旋转原点Y（相对于矩形，默认Height/2）
/// @returns    {bool}                     - 鼠标在矩形内返回true
/// @description               检测鼠标是否与矩形区域碰撞，支持旋转和自定义原点
function collision_mouse_rectangle(X, Y, w, h) {
    var MousePosition = {
		x: device_mouse_x_to_gui(0),
		y: device_mouse_y_to_gui(0)
	}
    // Check if the converted mouse position is within the rectangle
    return (MousePosition.x > X && MousePosition.x < X + w && MousePosition.y > Y && MousePosition.y < Y + h);
}