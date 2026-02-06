function Battle_IsBoardEdge(deviation = 0){
    var boardcount = array_length(global.BoardList);
    if (boardcount <= 0) return [false, false, false, false];
	var hasNonCover = array_create(4, false);
    var hasCover    = array_create(4, false);

    // 解析 deviation：支持标量或 [right, left, top, bottom]
    var dev_r = is_array(deviation) ? deviation[0] : deviation;
    var dev_l = is_array(deviation) ? deviation[1] : deviation;
    var dev_t = is_array(deviation) ? deviation[2] : deviation;
    var dev_b = is_array(deviation) ? deviation[3] : deviation;

    var testPoints = [
        [x, y - sprite_height/2 - dev_t], // Top
        [x, y + sprite_height/2 + dev_b], // Bottom
        [x - sprite_width/2 - dev_l, y],  // Left
        [x + sprite_width/2 + dev_r, y]   // Right
    ];

    for (var i = 0; i < boardcount; i++) {
        var b = global.BoardList[i];
        for (var dir = 0; dir < 4; dir++) {
            var px = testPoints[dir][0];
            var py = testPoints[dir][1];
            if (b.Contains(px, py)) {
                if (b.cover) {
                    hasCover[dir] = true;
                } else {
                    hasNonCover[dir] = true;
                }
            }
        }
    }

    var valid = [];
    for (var dir = 0; dir < 4; dir++) {
        valid[dir] = hasNonCover[dir] && !hasCover[dir];
    }

    return valid;
}