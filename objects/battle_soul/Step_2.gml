var boards = InstanceGetList(battle_board);
var board_count = array_length(boards);
if (board_count == 0) exit;

// 边界偏移：[检测x, 检测y, 修正x, 修正y]
var edge_offsets = [
    [0,  sprite_height / 2,  0, -sprite_height / 2], // 下
    [0, -sprite_height / 2,  0,  sprite_height / 2], // 上
    [sprite_width / 2,  0, -sprite_width / 2,  0],   // 右
    [-sprite_width / 2, 0,  sprite_width / 2,  0]    // 左
];

var in_noncover = array_create(4, false); // 是否在任意 non-cover 框内
var in_cover    = array_create(4, false); // 是否在任意 cover 框内
var first_cover = array_create(4, 0);     // 首个碰到的 cover 框索引（用于优化搜索）

// 阶段1：检测所有框的碰撞状态 —— 关键修复点在此！
for (var i = 0; i < board_count; i++) {
    var board = boards[i];
    for (var d = 0; d < 4; d++) {
        var tx = x + edge_offsets[d][0];
        var ty = y + edge_offsets[d][1];
        if (board.Contains(tx, ty)) {
            if (!board.cover) {
                in_noncover[d] = true; // 仅标记在 non-cover 内，不干扰 cover 状态
            } else {
                if (!in_cover[d]) first_cover[d] = i;
                in_cover[d] = true;
            }
        }
    }
}

// 阶段2 & 3：统一处理 cover 和 non-cover 修正
for (var pass = 0; pass < 2; pass++) {
    var is_cover_pass = (pass == 0);
    var best_dist = -1;
    
    for (var d = 0; d < 4; d++) {
        var need_process = is_cover_pass ? in_cover[d] : !in_noncover[d];
        if (!need_process) continue;
        
        var start_i = is_cover_pass ? first_cover[d] : 0;
        var nearest_x, nearest_y, nearest_dist = -1;
        
        for (var i = start_i; i < board_count; i++) {
            var board = boards[i];
            var include = is_cover_pass 
                ? (board.cover && board.Contains(x + edge_offsets[d][0], y + edge_offsets[d][1]))
                : !board.cover;
            if (!include) continue;
            
            var tx = x + edge_offsets[d][0];
            var ty = y + edge_offsets[d][1];
            var lp = board.Limit(tx, ty);
            var dist = point_distance(tx, ty, lp[0], lp[1]);
            if (nearest_dist == -1 || dist < nearest_dist) {
                nearest_dist = dist;
                nearest_x = lp[0];
                nearest_y = lp[1];
            }
        }
        
        if (nearest_dist != -1 && (best_dist == -1 || nearest_dist <= best_dist)) {
            x = nearest_x + edge_offsets[d][2];
            y = nearest_y + edge_offsets[d][3];
            best_dist = nearest_dist;
        }
    }
}