function Earcut(outer, holes) {
    // 节点结构定义
    var NodeStruct = {
        id: -1,        // 原始顶点索引
        x: 0, y: 0,    // 顶点坐标
        prev: -1,      // 前驱节点索引
        next: -1,      // 后继节点索引
        z: 0,          // Z-order 值
        removed: false // 标记是否已移除
    };
    // 核心工具结构
	var Handle = {
        EPSILON: 0.000001,
        INF: 1000000000,
        
        is_clockwise: function(vertices) {									// 检查多边形方向
            var area = 0;
            var n = array_length(vertices);
            for (var i = 0; i < n; i++) {
                var p1 = vertices[i];
                var p2 = vertices[(i + 1) % n];
                area += p1[0] * p2[1] - p2[0] * p1[1];
            }
            return area < 0;
        },
        cross: function(ax, ay, bx, by, cx, cy) {							// 计算叉积
            return (bx - ax) * (cy - ay) - (by - ay) * (cx - ax);
        },
        point_in_triangle_safe: function(px, py, ax, ay, bx, by, cx, cy) {	// 安全三角形检测
            var buffer = 0.001;
            return point_in_triangle(px, py, 
                ax - buffer, ay - buffer,
                bx + buffer, by + buffer,
                cx + buffer, cy + buffer
            );
        },
	    // Z-order 计算
	    z_order: function(x, y) {
	        x = clamp(x, 0, 0.9999999);
	        y = clamp(y, 0, 0.9999999);
        
	        var ix = floor(x * 65535);
	        var iy = floor(y * 65535);
        
	        var z = 0;
	        for (var i = 0; i < 16; i++) {
	            z |= ((ix >> i) & 1) << (2 * i);
	            z |= ((iy >> i) & 1) << (2 * i + 1);
	        }
	        return z;
	    },
    
	    // 完整桥接实现
	    find_bridge: function(outer, hole) {
	        // 1. 找到孔洞最左点（x最小，y最小）
	        var hole_min = [self.INF, self.INF];
	        var hole_idx = -1;
	        var hole_len = array_length(hole);
        
	        for (var i = 0; i < hole_len; i++) {
	            var p = hole[i];
	            if (p[0] < hole_min[0] || (p[0] == hole_min[0] && p[1] < hole_min[1])) {
	                hole_min = p;
	                hole_idx = i;
	            }
	        }
        
	        if (hole_idx < 0) return {outer_idx: -1, hole_idx: -1};
        
	        // 2. 收集外边界候选点（x < hole_min.x）
	        var candidates = [];
	        var outer_len = array_length(outer);
	        var cand_count = 0;
        
	        for (i = 0; i < outer_len; i++) {
	            var q = outer[i];
	            if (q[0] < hole_min[0]) {
	                candidates[cand_count] = i;
	                cand_count++;
	            }
	        }
        
	        // 3. 按y距离排序候选点
	        for (i = 0; i < cand_count; i++) {
	            for (var j = i + 1; j < cand_count; j++) {
	                var y1 = abs(outer[candidates[i]][1] - hole_min[1]);
	                var y2 = abs(outer[candidates[j]][1] - hole_min[1]);
	                if (y1 > y2) {
	                    var temp = candidates[i];
	                    candidates[i] = candidates[j];
	                    candidates[j] = temp;
	                }
	            }
	        }
        
	        // 4. 检查有效桥接
	        for (i = 0; i < cand_count; i++) {
	            var outer_idx = candidates[i];
	            if (self.is_valid_bridge(outer, hole, outer_idx, hole_idx)) {
	                return {outer_idx: outer_idx, hole_idx: hole_idx};
	            }
	        }
        
	        // 5. 如果没有找到，尝试水平右侧点
	        candidates = [];
	        cand_count = 0;
        
	        for (i = 0; i < outer_len; i++) {
	            q = outer[i];
	            if (q[0] >= hole_min[0]) {
	                candidates[cand_count] = i;
	                cand_count++;
	            }
	        }
        
	        // 按x距离排序
	        for (i = 0; i < cand_count; i++) {
	            for (j = i + 1; j < cand_count; j++) {
	                var x1 = abs(outer[candidates[i]][0] - hole_min[0]);
	                var x2 = abs(outer[candidates[j]][0] - hole_min[0]);
	                if (x1 > x2) {
	                    temp = candidates[i];
	                    candidates[i] = candidates[j];
	                    candidates[j] = temp;
	                }
	            }
	        }
        
	        // 检查右侧桥接
	        for (i = 0; i < cand_count; i++) {
	            outer_idx = candidates[i];
	            if (self.is_valid_bridge(outer, hole, outer_idx, hole_idx)) {
	                return {outer_idx: outer_idx, hole_idx: hole_idx};
	            }
	        }
        
	        return {outer_idx: -1, hole_idx: -1};
	    },
    
	    // 检查桥接有效性
	    is_valid_bridge: function(outer, hole, outer_idx, hole_idx) {
	        var p1 = outer[outer_idx];
	        var p2 = hole[hole_idx];
        
	        // 检查与外边界相交
	        var n_outer = array_length(outer);
	        for (var i = 0; i < n_outer; i++) {
	            var a = outer[i];
	            var b = outer[(i + 1) % n_outer];
            
	            // 跳过相邻边
	            if (i == outer_idx || (i + 1) % n_outer == outer_idx) continue;
            
	            // 使用内置 segments_intersect
	            if (segments_intersect(
	                p1[0], p1[1], p2[0], p2[1],
	                a[0], a[1], b[0], b[1]
	            )) return false;
	        }
        
	        // 检查与孔洞相交
	        var n_hole = array_length(hole);
	        for (i = 0; i < n_hole; i++) {
	            a = hole[i];
	            b = hole[(i + 1) % n_hole];
            
	            // 跳过相邻边
	            if (i == hole_idx || (i + 1) % n_hole == hole_idx) continue;
            
	            if (segments_intersect(
	                p1[0], p1[1], p2[0], p2[1],
	                a[0], a[1], b[0], b[1]
	            )) return false;
	        }
        
	        // 检查中点是否在多边形内部
	        var mid = [(p1[0] + p2[0]) * 0.5, (p1[1] + p2[1]) * 0.5];
	        return this.point_in_polygon(mid, outer);
	    },
    
	    // 点在多边形内检测（射线法）
	    point_in_polygon: function(point, polygon) {
	        var _x = point[0];
	        var _y = point[1];
	        var inside = false;
	        var n = array_length(polygon);
        
	        for (var i = 0, j = n - 1; i < n; j = i++) {
	            var xi = polygon[i][0], yi = polygon[i][1];
	            var xj = polygon[j][0], yj = polygon[j][1];
            
	            var intersect = ((yi > _y) != (yj > _y)) &&
	                           (_x < (xj - xi) * (_y - yi) / max(yj - yi, self.EPSILON) + xi);
	            if (intersect) inside = !inside;
	        }
	        return inside;
	    },
    
	    // 连接孔洞到主多边形
	    connect_hole: function(vertices, hole, outer_idx, hole_idx) {
	        var result = [];
	        var n = array_length(vertices);
	        var hole_len = array_length(hole);
        
	        // 复制顶点直到桥接点
	        for (var i = 0; i <= outer_idx; i++) {
	            result[i] = [vertices[i][0], vertices[i][1]];
	        }
        
	        // 插入孔洞顶点（从桥接点开始，逆时针顺序）
	        var insert_pos = outer_idx + 1;
	        for (i = 0; i < hole_len; i++) {
	            var idx = (hole_idx + i) % hole_len;
	            result[insert_pos + i] = [hole[idx][0], hole[idx][1]];
	        }
        
	        // 复制剩余顶点
	        for (i = outer_idx + 1; i < n; i++) {
	            result[insert_pos + hole_len + i - outer_idx - 1] = [vertices[i][0], vertices[i][1]];
	        }
        
	        return result;
	    },
    
	    // 合并两个孔洞
	    merge_holes: function(hole1, hole2, idx1, idx2) {
	        var merged = [];
	        var len1 = array_length(hole1);
	        var len2 = array_length(hole2);
        
	        // 复制第一个孔洞
	        for (var i = 0; i < len1; i++) {
	            merged[i] = [hole1[i][0], hole1[i][1]];
	        }
        
	        // 插入桥接点
	        merged[len1] = [hole1[idx1][0], hole1[idx1][1]];
	        merged[len1 + 1] = [hole2[idx2][0], hole2[idx2][1]];
        
	        // 复制第二个孔洞（从桥接点开始）
	        for (i = 0; i < len2; i++) {
	            var idx = (idx2 + i) % len2;
	            merged[len1 + 2 + i] = [hole2[idx][0], hole2[idx][1]];
	        }
        
	        // 返回合并后的孔洞
	        return merged;
	    },
    
	    // 三角剖分核心
	    earcut_linked: function(nodes, triangles) {
	        var active_count = self.count_active(nodes);
	        if (active_count < 3) return;
        
	        var start = self.find_first_active(nodes);
	        if (start < 0) return;
        
	        var cur = start;
	        var attempts = 0;
	        var max_attempts = array_length(nodes) * 2;
        
	        do {
	            attempts++;
	            if (attempts > max_attempts) break;
            
	            if (self.is_valid_ear(nodes, cur)) {
	                var a_id = nodes[cur].prev;
	                var c_id = nodes[cur].next;
                
	                // 添加三角形
	                triangles[array_length(triangles)] = [
	                    nodes[a_id].id,
	                    nodes[cur].id,
	                    nodes[c_id].id
	                ];
                
	                // 移除当前节点
	                nodes[a_id].next = c_id;
	                nodes[c_id].prev = a_id;
	                nodes[cur].removed = true;
                
	                self.earcut_linked(nodes, triangles);
	                return;
	            }
	            cur = nodes[cur].next;
	        } until (cur == start || attempts > max_attempts);
        
	        self.force_split(nodes, triangles);
	    },
    
	    // 有效耳朵检测
	    is_valid_ear: function(nodes, b_id) {
	        var a_id = nodes[b_id].prev;
	        var c_id = nodes[b_id].next;
	        var a = nodes[a_id];
	        var b = nodes[b_id];
	        var c = nodes[c_id];
        
	        // 凸性检查
	        if (self.cross(a.x, a.y, b.x, b.y, c.x, c.y) <= self.EPSILON) return false;
        
	        // 检查内部点
	        var min_z = min(min(a.z, b.z), c.z);
	        var max_z = max(max(a.z, b.z), c.z);
        
	        for (var i = 0; i < array_length(nodes); i++) {
	            if (nodes[i].removed) continue;
	            if (i == a_id || i == b_id || i == c_id) continue;
            
	            // Z-order 剪枝
	            if (nodes[i].z < min_z - self.EPSILON || nodes[i].z > max_z + self.EPSILON) continue;
            
	            // 三角形内点检测
	            if (self.point_in_triangle_safe(
	                nodes[i].x, nodes[i].y,
	                a.x, a.y, b.x, b.y, c.x, c.y
	            )) return false;
	        }
	        return true;
	    },
    
	    // 强制分割退化多边形
	    force_split: function(nodes, triangles) {
	        var best_dist = self.INF;
	        var split_i = -1;
	        var split_j = -1;
        
	        for (var i = 0; i < array_length(nodes); i++) {
	            if (nodes[i].removed) continue;
            
	            for (var j = 0; j < array_length(nodes); j++) {
	                if (i == j || nodes[j].removed) continue;
	                if (nodes[i].prev == j || nodes[i].next == j) continue;
                
	                // 检查安全对角线
	                if (!self.is_safe_diagonal(nodes, i, j)) continue;
                
	                var dx = nodes[i].x - nodes[j].x;
	                var dy = nodes[i].y - nodes[j].y;
	                var dist = dx * dx + dy * dy;
                
	                if (dist < best_dist) {
	                    best_dist = dist;
	                    split_i = i;
	                    split_j = j;
	                }
	            }
	        }
        
	        if (split_i >= 0) {
	            self.split_polygon(nodes, split_i, split_j, triangles);
	        } else {
	            self.remove_smallest_triangle(nodes, triangles);
	        }
	    },
    
	    // 辅助函数
	    count_active: function(nodes) {
	        var count = 0;
	        for (var i = 0; i < array_length(nodes); i++) {
	            if (!nodes[i].removed) count++;
	        }
	        return count;
	    },
    
	    find_first_active: function(nodes) {
	        for (var i = 0; i < array_length(nodes); i++) {
	            if (!nodes[i].removed) return i;
	        }
	        return -1;
	    },
    
	    is_safe_diagonal: function(nodes, i, j) {
	        var a = nodes[i];
	        var b = nodes[j];
	        var ap = nodes[a.prev];
	        var an = nodes[a.next];
        
	        return (
	            self.cross(ap.x, ap.y, a.x, a.y, b.x, b.y) > self.EPSILON &&
	            self.cross(an.x, an.y, a.x, a.y, b.x, b.y) > self.EPSILON
	        );
	    },
    
	    split_polygon: function(nodes, i, j, triangles) {
	        var chain1 = self.extract_chain(nodes, i, j);
	        var chain2 = self.extract_chain(nodes, j, i);
        
	        if (array_length(chain1) >= 3) {
	            var sub_nodes = self.duplicate_chain(nodes, chain1);
	            self.earcut_linked(sub_nodes, triangles);
	        }
	        if (array_length(chain2) >= 3) {
	            sub_nodes = self.duplicate_chain(nodes, chain2);
	            self.earcut_linked(sub_nodes, triangles);
	        }
	    },
    
	    extract_chain: function(nodes, start, _end) {
	        var chain = [];
	        var cur = start;
	        var count = 0;
        
	        while (cur != _end && count < 1000) {
	            chain[array_length(chain)] = cur;
	            cur = nodes[cur].next;
	            count++;
	        }
	        chain[array_length(chain)] = end;
	        return chain;
	    },
    
	    duplicate_chain: function(nodes, chain) {
	        var n = array_length(chain);
	        var new_nodes = array_create(n);
        
	        for (var i = 0; i < n; i++) {
	            var idx = chain[i];
	            new_nodes[i] = {
	                id: nodes[idx].id,
	                x: nodes[idx].x,
	                y: nodes[idx].y,
	                prev: (i == 0) ? n - 1 : i - 1,
	                next: (i == n - 1) ? 0 : i + 1,
	                z: nodes[idx].z,
	                removed: false
	            };
	        }
	        return new_nodes;
	    },
    
	    remove_smallest_triangle: function(nodes, triangles) {
	        var min_area = self.INF;
	        var best_idx = -1;
        
	        var start = self.find_first_active(nodes);
	        if (start < 0) return;
        
	        var cur = start;
	        do {
	            var a = nodes[nodes[cur].prev];
	            var b = nodes[cur];
	            var c = nodes[nodes[cur].next];
            
	            if (!b.removed) {
	                var area = abs(self.cross(a.x, a.y, b.x, b.y, c.x, c.y));
	                if (area > self.EPSILON && area < min_area) {
	                    min_area = area;
	                    best_idx = cur;
	                }
	            }
	            cur = nodes[cur].next;
	        } until (cur == start);
        
	        if (best_idx >= 0) {
	            var a_id = nodes[best_idx].prev;
	            var c_id = nodes[best_idx].next;
            
	            nodes[a_id].next = c_id;
	            nodes[c_id].prev = a_id;
	            nodes[best_idx].removed = true;
            
	            self.earcut_linked(nodes, triangles);
	        }
	    }
	}
	
	// 主处理
	if (Handle.is_clockwise(outer)) outer = array_reverse(outer);
	var vertices = array_slice(outer, 0, array_length(outer));
    
    // 完整孔洞桥接
    var hole_queue = [];
    for (var hi = 0; hi < array_length(holes); hi++) {
        var hole = holes[hi];
        if (!Handle.is_clockwise(hole)) hole = array_reverse(hole);
        hole_queue[hi] = hole;
    }
    
    while (array_length(hole_queue) > 0) {
        var hole = hole_queue[0];
        var bridge = Handle.find_bridge(vertices, hole);
        
        if (bridge.outer_idx >= 0 && bridge.hole_idx >= 0) {
            // 执行桥接
            vertices = Handle.connect_hole(vertices, hole, bridge.outer_idx, bridge.hole_idx);
            hole_queue = array_delete(hole_queue, 0, 1);
        } else {
            // 无法桥接，尝试与其他孔洞合并
            var merged = false;
            for (var i = 1; i < array_length(hole_queue); i++) {
                var other_hole = hole_queue[i];
                bridge = Handle.find_bridge(hole, other_hole);
                
                if (bridge.outer_idx >= 0 && bridge.hole_idx >= 0) {
                    // 合并两个孔洞
                    var merged_hole = Handle.merge_holes(hole, other_hole, bridge.outer_idx, bridge.hole_idx);
                    hole_queue[0] = merged_hole;
                    hole_queue = array_delete(hole_queue, i, 1);
                    merged = true;
                    break;
                }
            }
            
            if (!merged) {
                show_debug_message("Warning: Failed to bridge hole, skipping");
                hole_queue = array_delete(hole_queue, 0, 1);
            }
        }
    }
    
    // 创建节点链表
    var n = array_length(vertices);
    var nodes = array_create(n);
    for (var i = 0; i < n; i++) {
        nodes[i] = {
            id: i,
            x: vertices[i][0],
            y: vertices[i][1],
            prev: (i == 0) ? n - 1 : i - 1,
            next: (i == n - 1) ? 0 : i + 1,
            z: 0,
            removed: false
        };
    }
    
    // 计算 Z-order
    var min_x = vertices[0][0], max_x = vertices[0][0];
    var min_y = vertices[0][1], max_y = vertices[0][1];
    for (i = 1; i < n; i++) {
        min_x = min(min_x, vertices[i][0]);
        max_x = max(max_x, vertices[i][0]);
        min_y = min(min_y, vertices[i][1]);
        max_y = max(max_y, vertices[i][1]);
    }
    var size = max(max_x - min_x, max_y - min_y);
    for (i = 0; i < n; i++) {
        var norm_x = (vertices[i][0] - min_x) / max(size, Handle.EPSILON);
        var norm_y = (vertices[i][1] - min_y) / max(size, Handle.EPSILON);
        nodes[i].z = Handle.z_order(norm_x, norm_y);
    }
    
    // 三角剖分
    var triangles = [];
    Handle.earcut_linked(nodes, triangles);
    return triangles;
}