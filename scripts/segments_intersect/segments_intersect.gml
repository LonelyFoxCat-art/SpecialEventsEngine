/// @desc 检测两条线段是否相交，并可选返回交点
/// @param x1 起点 A 的 x
/// @param y1 起点 A 的 y
/// @param x2 终点 B 的 x
/// @param y2 终点 B 的 y
/// @param x3 起点 C 的 x
/// @param y3 起点 C 的 y
/// @param x4 终点 D 的 x
/// @param y4 终点 D 的 y
/// @param [return_point=false] 是否返回交点（若相交）
/// @returns 若 return_point=false：bool；否则：[true, ix, iy] 或 [false]
function segments_intersect(x1, y1, x2, y2, x3, y3, x4, y4, return_point = false) {
    var dx1 = x2 - x1;
    var dy1 = y2 - y1;
    var dx2 = x4 - x3;
    var dy2 = y4 - y3;

    var denom = dx1 * dy2 - dy1 * dx2;
    if (denom == 0) {
        // 平行或共线
        if (return_point) return [false];
        return false;
    }

    var t = ((x3 - x1) * dy2 - (y3 - y1) * dx2) / denom;
    var u = ((x3 - x1) * dy1 - (y3 - y1) * dx1) / denom;

    if (t >= 0 && t <= 1 && u >= 0 && u <= 1) {
        if (!return_point) return true;
        var ix = x1 + t * dx1;
        var iy = y1 + t * dy1;
        return [true, ix, iy];
    }

    if (return_point) return [false];
    return false;
}