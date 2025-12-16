/// @func Delaunay_EarClipping(vertices)
/// @desc 使用耳切法（Ear Clipping）对简单多边形进行三角剖分，返回三角形索引列表
/// @arg {array<Vector2>} vertices - 多边形的顶点数组（按顺序，不重复首尾点）
/// @returns {array<array<int>>} 三角剖分结果，每个元素为包含三个顶点索引的数组

function Delaunay_EarClipping(vertices) {
	var Length = array_length(vertices);
    if (Length < 3) return [];

    var indices = [];
    for (var i = 0; i < Length; i++) array_push(indices, i);

    var triangles = [];

    if (Delaunay_IsConvex(vertices)) {
        var last = Length - 1;
        for (var i = 0; i < last - 1; i++) {
            array_push(triangles, [i, i + 1, last]);
        }
        return triangles;
    }

    while (array_length(indices) > 3) {
        var m = array_length(indices);
        var ear_found = false;

        for (var i = 0; i < m; i++) {
            var curr_i = indices[i];
            var prev_i = indices[wrap_index(i - 1, m)];
            var next_i = indices[wrap_index(i + 1, m)];

            var prev_v = vertices[prev_i];
            var curr_v = vertices[curr_i];
            var next_v = vertices[next_i];

            var v1 = Vector2.Subtract(curr_v, prev_v);
            var v2 = Vector2.Subtract(next_v, curr_v);
            var cross = v1.x * v2.y - v1.y * v2.x;

            if (cross >= 0) continue;

            var diagonal_intersects = false;
            for (var j = 0; j < m; j++) {
                var k = wrap_index(j + 1, m);
                if (j == i || k == i || j == wrap_index(i - 1, m) || k == wrap_index(i + 1, m)) continue;

                var a = vertices[indices[j]];
                var b = vertices[indices[k]];
                var o1 = sign((b.x - a.x) * (prev_v.y - a.y) - (b.y - a.y) * (prev_v.x - a.x));
                var o2 = sign((b.x - a.x) * (next_v.y - a.y) - (b.y - a.y) * (next_v.x - a.x));
                var o3 = sign((next_v.x - prev_v.x) * (a.y - prev_v.y) - (next_v.y - prev_v.y) * (a.x - prev_v.x));
                var o4 = sign((next_v.x - prev_v.x) * (b.y - prev_v.y) - (next_v.y - prev_v.y) * (b.x - prev_v.x));

                if (o1 != o2 && o3 != o4) {
                    diagonal_intersects = true;
                    break;
                }
            }

            if (!diagonal_intersects) {
                array_push(triangles, [prev_i, curr_i, next_i]);
                array_delete(indices, i, 1);
                ear_found = true;
                break;
            }
        }

        if (!ear_found) break;
    }

    if (array_length(indices) == 3) array_push(triangles, [indices[0], indices[1], indices[2]]);

    return triangles;
}