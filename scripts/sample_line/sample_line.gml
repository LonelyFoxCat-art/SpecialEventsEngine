/// @desc 在 (x1,y1) 到 (x2,y2) 之间生成 n 个等距点（含端点）
/// @param x1 起点 x
/// @param y1 起点 y
/// @param x2 终点 x
/// @param y2 终点 y
/// @param count 点数量（≥2）
/// @returns 数组 [[x0,y0], [x1,y1], ...]
function sample_line(x1, y1, x2, y2, count) {
    if (count < 2) count = 2;
    var points = [];
    for (var i = 0; i < count; i++) {
        var t = i / (count - 1);
        var _x = lerp(x1, x2, t);
        var _y = lerp(y1, y2, t);
        array_push(points, [_x, _y]);
    }
    return points;
}