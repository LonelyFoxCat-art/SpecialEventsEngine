/// @desc 将点 (x, y) 绕 (cx, cy) 旋转 angle 弧度
/// @param x 待旋转点的 x
/// @param y 待旋转点的 y
/// @param cx 旋转中心 x
/// @param cy 旋转中心 y
/// @param angle 旋转角度（弧度，逆时针为正）
/// @returns 数组 [rx, ry]
function point_rotate_around(x, y, cx, cy, angle) {
    var s = dsin(angle);
    var c = dcos(angle);
    var dx = x - cx;
    var dy = y - cy;
    var rx = cx + c * dx - s * dy;
    var ry = cy + s * dx + c * dy;
    return [rx, ry];
}