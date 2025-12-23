/// @func Delaunay_Triangulate(points)
/// @desc 使用 Bowyer-Watson 算法对一组 Vector2 点进行 Delaunay 三角剖分
/// @arg {array<Vector2>} points - 无序的点集（至少3个点）
/// @returns {array<array<int>>} 三角剖分结果，每个元素为 [i, j, k] 的原始索引三元组

function Delaunay_Triangulate(points) {
    var n = array_length(points);
    if (n < 3) return [];

    // === 构建超级三角形 ===
    var min_x = points[0].x, max_x = points[0].x;
    var min_y = points[0].y, max_y = points[0].y;
    for (var i = 1; i < n; i++) {
        var p = points[i];
        min_x = min(min_x, p.x);
        max_x = max(max_x, p.x);
        min_y = min(min_y, p.y);
        max_y = max(max_y, p.y);
    }

    var dx = max_x - min_x;
    var dy = max_y - min_y;
    var delta = max(dx, dy) * 10;

    var cx = (min_x + max_x) * 0.5;
    var cy = (min_y + max_y) * 0.5;

    // 超级三角形三点（足够大，包围所有点）
    var super_a = Vector2(cx - delta, cy - delta * 0.5); // 左下
    var super_b = Vector2(cx + delta, cy - delta * 0.5); // 右下
    var super_c = Vector2(cx,           cy + delta);     // 顶部

    // 扩展点列表：原始点 + 超级三角形三点
    var all_points = array_slice(points, 0, n);
    array_push(all_points, super_a); // index n
    array_push(all_points, super_b); // index n+1
    array_push(all_points, super_c); // index n+2

    // 初始三角形（超级三角形）
    var triangles = [[n, n+1, n+2]];

    // === 逐个插入点 ===
    for (var i = 0; i < n; i++) {
        var p = points[i];
        var bad_triangles = [];

        // ---- 内联：判断点是否在外接圆内 ----
        for (var j = 0; j < array_length(triangles); j++) {
            var tri = triangles[j];
            var a = all_points[tri[0]];
            var b = all_points[tri[1]];
            var c = all_points[tri[2]];

            var ax = a.x, ay = a.y;
            var bx = b.x, by = b.y;
            var cx = c.x, cy = c.y;
            var px = p.x, py = p.y;

            var ax2 = ax*ax + ay*ay;
            var bx2 = bx*bx + by*by;
            var cx2 = cx*cx + cy*cy;
            var px2 = px*px + py*py;

            var det = ax*(by*cx2 - cy*bx2 + (cy - by)*px2) -
                      ay*(bx*cx2 - cx*bx2 + (cx - bx)*px2) +
                      ax2*(bx*cy - cx*by + (cx - bx)*py - (cy - by)*px) -
                      1*(bx*(cy*px2 - py*cx2) - by*(cx*px2 - py*cx2) + (cx*cy - cy*cx)*px2); // 最后一行展开

            // 更可靠的方式：使用偏移行列式（避免大数）
            var m11 = ax - px;
            var m12 = ay - py;
            var m13 = (ax*ax - px*px) + (ay*ay - py*py);
            var m21 = bx - px;
            var m22 = by - py;
            var m23 = (bx*bx - px*px) + (by*by - py*py);
            var m31 = cx - px;
            var m32 = cy - py;
            var m33 = (cx*cx - px*px) + (cy*cy - py*py);

            var determinant = m11 * (m22*m33 - m32*m23) -
                              m12 * (m21*m33 - m31*m23) +
                              m13 * (m21*m32 - m31*m22);

            if (determinant > 0) {
                array_push(bad_triangles, tri);
            }
        }

        // === 提取 boundary edges ===
        var polygon = [];
        for (var j = 0; j < array_length(bad_triangles); j++) {
            var tri = bad_triangles[j];
            var edges = [[tri[0], tri[1]], [tri[1], tri[2]], [tri[2], tri[0]]];
            for (var k = 0; k < 3; k++) {
                var edge = edges[k];
                var reverse = [edge[1], edge[0]];

                // 查找反向边是否已存在
                var found = false;
                for (var m = 0; m < array_length(polygon); m++) {
                    if (polygon[m][0] == reverse[0] && polygon[m][1] == reverse[1]) {
                        array_delete(polygon, m, 1);
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    array_push(polygon, edge);
                }
            }
        }

        // === 移除 bad triangles ===
        for (var j = array_length(triangles) - 1; j >= 0; j--) {
            var tri = triangles[j];
            for (var k = 0; k < array_length(bad_triangles); k++) {
                if (tri == bad_triangles[k]) {
                    array_delete(triangles, j, 1);
                    break;
                }
            }
        }

        // === 用新点连接边界形成新三角形 ===
        for (var j = 0; j < array_length(polygon); j++) {
            array_push(triangles, [polygon[j][0], polygon[j][1], i]);
        }
    }

    // === 剔除包含超级三角形顶点的三角形 ===
    var result = [];
    for (var i = 0; i < array_length(triangles); i++) {
        var tri = triangles[i];
        if (tri[0] < n && tri[1] < n && tri[2] < n) {
            array_push(result, tri);
        }
    }

    return result;
}