/// @func draw_application(_x = 0, _y = 0)
/// @desc 在指定位置绘制应用主表面（application_surface）
/// @arg {real} [_x] - 绘制的 X 坐标，默认为 0
/// @arg {real} [_y] - 绘制的 Y 坐标，默认为 0

function draw_application(_x = 0, _y = 0){
	draw_surface(application_surface, _x, _y)
}