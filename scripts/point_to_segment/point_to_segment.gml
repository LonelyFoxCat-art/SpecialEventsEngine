/// @desc 计算点到线段的最近点和距离
/// @param px 点 P 的 x
/// @param py 点 P 的 y
/// @param x1 线段起点 A 的 x
/// @param y1 线段起点 A 的 y
/// @param x2 线段终点 B 的 x
/// @param y2 线段终点 B 的 y
/// @returns 数组 [closest_x, closest_y, distance]
function point_to_segment(px, py, x1, y1, x2, y2) {
    var dx = x2 - x1;
    var dy = y2 - y1;
    var length_sq = dx * dx + dy * dy;

    if (length_sq == 0) {
        // A 和 B 重合
        var dist = point_distance(px, py, x1, y1);
        return [x1, y1, dist];
    }

    // 计算投影参数 t（0=起点，1=终点）
    var t = ((px - x1) * dx + (py - y1) * dy) / length_sq;
    t = clamp(t, 0, 1);

    var closest_x = x1 + t * dx;
    var closest_y = y1 + t * dy;
    var dist = point_distance(px, py, closest_x, closest_y);

    return [closest_x, closest_y, dist];
}