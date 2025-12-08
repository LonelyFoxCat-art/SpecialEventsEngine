/// @desc 在圆内生成均匀随机点
/// @param _center_x 圆心 x
/// @param _center_y 圆心 y
/// @param _radius 半径
/// @returns [x, y]
function random_point_in_circle(_center_x, _center_y, _radius) {
    var r = _radius * sqrt(random(1)); // 关键：sqrt 保证均匀
    var theta = random(360);
    var _x = _center_x + r * dcos(theta);
    var _y = _center_y + r * dsin(theta);
    return [_x, _y];
}