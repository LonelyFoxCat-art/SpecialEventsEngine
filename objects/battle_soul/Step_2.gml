var List = InstanceGetList(battle_board);
var Length = array_length(List);
if (Length == 0) exit;

var edge_offsets = [
    [0,  sprite_height / 2,  0, -sprite_height / 2], // 下
    [0, -sprite_height / 2,  0,  sprite_height / 2], // 上
    [sprite_width / 2,  0, -sprite_width / 2,  0],   // 右
    [-sprite_width / 2, 0,  sprite_width / 2,  0]    // 左
];

var in_noncover = array_create(4, false);
var in_cover    = array_create(4, false);
var first_cover = array_create(4, 0);

for (var i = 0; i < Length; i++) {
    var BoardDate = List[i];
    for (var d = 0; d < 4; d++) {
        var tx = x + edge_offsets[d][0];
        var ty = y + edge_offsets[d][1];
        if (BoardDate.Contains(tx, ty)) {
            if (!BoardDate.cover) {
                in_noncover[d] = true;
            } else {
                if (!in_cover[d]) first_cover[d] = i;
                in_cover[d] = true;
            }
        }
    }
}

for (var pass = 0; pass < 2; pass++) {
    var is_cover_pass = (pass == 0);
    var best_dist = -1;

    for (var d = 0; d < 4; d++) {
        var need_process = is_cover_pass ? in_cover[d] : !in_noncover[d];
        if (!need_process) continue;

        var start_i = is_cover_pass ? first_cover[d] : 0;
        var nearest_x, nearest_y, nearest_dist = -1;

        for (var i = start_i; i < Length; i++) {
            var BoardDate = List[i];
            var include = is_cover_pass ? (BoardDate.cover && BoardDate.Contains(x + edge_offsets[d][0], y + edge_offsets[d][1])) : !BoardDate.cover;
            if (!include) continue;

            var tx = x + edge_offsets[d][0];
            var ty = y + edge_offsets[d][1];
            var lp = BoardDate.Limit(tx, ty);
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
