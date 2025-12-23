/// @func Delaunay_EarClipping(vertices)
/// @desc 使用耳切法（Ear Clipping）对简单多边形进行三角剖分，返回三角形索引列表
/// @arg {array<Vector2>} vertices - 多边形的顶点数组（按顺序，不重复首尾点）
/// @returns {array<array<int>>} 三角剖分结果，每个元素为包含三个顶点索引的数组

function Delaunay_EarClipping(vertices) {
    var Length = array_length(vertices);
    if (Length < 3) return [];

    // 快速路径：凸多边形直接扇形剖分
    if (Delaunay_IsConvex(vertices)) {
        var triangles = [];
        var last = Length - 1;
        for (var i = 0; i < last - 1; i++) {
            array_push(triangles, [i, i + 1, last]);
        }
        return triangles;
    }

    var indices = [];
    for (var i = 0; i < Length; i++) array_push(indices, i);

    var triangles = [];
    var max_iterations = array_length(indices); // 防止无限循环

    while (array_length(indices) > 3 && max_iterations > 0) {
        max_iterations -= 1;
        var m = array_length(indices);
        var ear_found = false;

        var curr_vertices = [];
        for (var idx = 0; idx < m; idx++) {
            array_push(curr_vertices, vertices[indices[idx]]);
        }

        for (var i = 0; i < m; i++) {
            if (Delaunay_CanDivide(i, curr_vertices)) {
                var prev_i = indices[wrap_index(i - 1, m)];
                var curr_i = indices[i];
                var next_i = indices[wrap_index(i + 1, m)];
                array_push(triangles, [prev_i, curr_i, next_i]);
                array_delete(indices, i, 1);
                ear_found = true;
                break;
            }
        }

        if (!ear_found) {
            show_debug_message("Delaunay_EarClipping: 无法找到合法耳（可能输入非简单多边形、有重复点或自相交）");
            
            // 备用策略：强制取前三个点构成一个三角形（风险：可能无效，但避免卡死）
            if (array_length(indices) >= 3) {
                array_push(triangles, [indices[0], indices[1], indices[2]]);
                show_debug_message("Delaunay_EarClipping: 提前终止，返回部分三角剖分结果");
                break;
            }
        }
    }

    // 处理最后的三角形
    if (array_length(indices) == 3) {
        array_push(triangles, [indices[0], indices[1], indices[2]]);
    } else if (array_length(indices) > 3) {
        // 极端情况：仍有多于3个点但无法剖分
        show_debug_message("Delaunay_EarClipping: 剩余 " + string(array_length(indices)) + " 个顶点未剖分");
    }

    return triangles;
}