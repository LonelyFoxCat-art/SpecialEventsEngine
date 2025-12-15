/// @func Delaunay_IsConvex(vertices)
/// @desc 判断给定顶点序列（按顺序）构成的多边形是否为凸多边形
/// @arg {array<Vector2>} vertices - 多边形的顶点数组（按顺时针或逆时针顺序排列）
/// @returns {bool} 若多边形为凸多边形则返回 true，否则返回 false；顶点数小于 3 时视为凸

function Delaunay_IsConvex(vertices) {
    var Length = array_length(vertices);
    if (Length < 3) return true;

    var has_positive = false;
    var has_negative = false;

    for (var i = 0; i < Length; i++) {
        var p0 = vertices[i];
        var p1 = vertices[wrap_index(i + 1, Length)];
        var p2 = vertices[wrap_index(i + 2, Length)];

        var v1 = Vector2.Subtract(p1, p0);
        var v2 = Vector2.Subtract(p2, p1);
        var cross = v1.x * v2.y - v1.y * v2.x;

        if (cross > 0) has_positive = true;
        else if (cross < 0) has_negative = true;

        if (has_positive && has_negative) return false;
    }

    return true;
}