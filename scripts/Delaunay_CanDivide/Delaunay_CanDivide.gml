/// @func Delaunay_CanDivide(i, vertices)
/// @desc 判断多边形中第 i 个顶点是否可以用于三角剖分中的合法耳切（ear clipping），即该顶点构成的三角形是否在多边形内部且不与任何边相交
/// @arg {int} i - 当前顶点在顶点数组中的索引
/// @arg {array<Vector2>} vertices - 多边形的顶点列表（按顺序）
/// @returns {bool} 若该顶点可安全用于三角剖分（构成有效“耳”）则返回 true，否则返回 false

function Delaunay_CanDivide(i, vertices) {
    var Length = array_length(vertices);
    if (Length < 3) return false;

    var prev = vertices[wrap_index(i - 1, Length)];
    var curr = vertices[i];
    var next = vertices[wrap_index(i + 1, Length)];

    var v1 = Vector2.Subtract(curr, prev);
    var v2 = Vector2.Subtract(next, curr);
    var cross = v1.x * v2.y - v1.y * v2.x;
    if (cross >= 0) return false;

    for (var j = 0; j < Length; j++) {
        var k = wrap_index(j + 1, Length);
        if (j == i || k == i || j == wrap_index(i - 1, Length) || k == wrap_index(i + 1, Length)) continue;

        var a = vertices[j];
        var b = vertices[k];
        var o1 = sign((b.x - a.x) * (prev.y - a.y) - (b.y - a.y) * (prev.x - a.x));
        var o2 = sign((b.x - a.x) * (next.y - a.y) - (b.y - a.y) * (next.x - a.x));
        var o3 = sign((next.x - prev.x) * (a.y - prev.y) - (next.y - prev.y) * (a.x - prev.x));
        var o4 = sign((next.x - prev.x) * (b.y - prev.y) - (next.y - prev.y) * (b.x - prev.x));

        if (o1 != o2 && o3 != o4) return false;
    }

    return true;
}
