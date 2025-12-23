var isInside = [array_create(4, false), array_create(4, false)];
var limit_index = array_create(4, 0);
var boardcount = array_length(global.BoardList);

for (var i = 0; i < boardcount; i++) {
    var b = global.BoardList[i];
    b.isCollide[0] = b.Contains(x - sprite_width / 2, y);
    b.isCollide[1] = b.Contains(x + sprite_width / 2, y);
    b.isCollide[2] = b.Contains(x, y - sprite_height / 2);
    b.isCollide[3] = b.Contains(x, y + sprite_height / 2);
    
    for (var dir = 0; dir < 4; dir++) {
        if (b.isCollide[dir]) {
            if (!b.cover) {
                isInside[1][dir] = false;
            } else if (!isInside[1][dir]) {
                limit_index[dir] = i;
            }
            isInside[b.cover][dir] = true;
        }
    }
}

var distance = -1;
for (var dir = 0; dir < 4; dir++) {
    if (!isInside[1][dir]) continue;
    
    var nearestPos = -1;
    var nearestDis = -1;
    
    for (var i = limit_index[dir]; i < boardcount; i++) {
        var b = global.BoardList[i];
        if (b.cover && !b.isCollide[dir]) continue;
        
        var px, py;
        switch (dir) {
            case 0: px = x - sprite_width / 2; py = y; break;
            case 1: px = x + sprite_width / 2; py = y; break;
            case 2: px = x; py = y - sprite_height / 2; break;
            case 3: px = x; py = y + sprite_height / 2; break;
        }
        var pos = b.Limit(px, py);
        var dis = point_distance(px, py, pos[0], pos[1]);
        if (nearestDis == -1 || dis < nearestDis) {
            nearestDis = dis;
            nearestPos = pos;
        }
    }
    
    if (nearestPos != -1 && (distance == -1 || distance <= nearestDis)) {
        switch (dir) {
            case 0: x = nearestPos[0] + sprite_width / 2; y = nearestPos[1]; break;
            case 1: x = nearestPos[0] - sprite_width / 2; y = nearestPos[1]; break;
            case 2: x = nearestPos[0]; y = nearestPos[1] + sprite_height / 2; break;
            case 3: x = nearestPos[0]; y = nearestPos[1] - sprite_height / 2; break;
        }
        distance = nearestDis;
    }
}

distance = -1;
for (var dir = 0; dir < 4; dir++) {
    if (isInside[0][dir]) continue;
    
    var nearestPos = -1;
    var nearestDis = -1;
    
    for (var i = 0; i < boardcount; i++) {
        var b = global.BoardList[i];
        if (!b.cover) {
            var px, py;
            switch (dir) {
                case 0: px = x - sprite_width / 2; py = y; break;
                case 1: px = x + sprite_width / 2; py = y; break;
                case 2: px = x; py = y - sprite_height / 2; break;
                case 3: px = x; py = y + sprite_height / 2; break;
            }
            var pos = b.Limit(px, py);
            var dis = point_distance(px, py, pos[0], pos[1]);
            if (nearestDis == -1 || dis < nearestDis) {
                nearestDis = dis;
                nearestPos = pos;
            }
        }
    }
    
    if (nearestPos != -1 && (distance == -1 || distance <= nearestDis)) {
        switch (dir) {
            case 0: x = nearestPos[0] + sprite_width / 2; y = nearestPos[1]; break;
            case 1: x = nearestPos[0] - sprite_width / 2; y = nearestPos[1]; break;
            case 2: x = nearestPos[0]; y = nearestPos[1] + sprite_height / 2; break;
            case 3: x = nearestPos[0]; y = nearestPos[1] - sprite_height / 2; break;
        }
        distance = nearestDis;
    }
}