if !(instance_exists(battle_board_draw)) instance_create(0, 0, battle_board_draw)
depth = -500
surface = -1
cover = false
Vertex = [ ]
Vertex_Online = [ ]
color = c_white
alpha = 1

// 判断点是否在旋转后的多边形内
// 传入参数:
//     _x: 点的横坐标
//     _y: 点的纵坐标
//     _listVertex: 别管这个
// [返回点是否在多边形内]
function Contains(_x, _y, _listVertex = cover ? Vertex_Online : Vertex) {
    return RelativeContains(_x - x, _y - y, _listVertex);
}

// 判断点是否在旋转后的多边形内(使用vector2优化)
// 传入参数:
//     _x: 点的横坐标
//     _y: 点的纵坐标
//     _listVertex: 顶点数组
//     _angle: 旋转角度(可选)
// [返回点是否在多边形内]
function RelativeContains(_x, _y, _listVertex = cover ? Vertex_Online : Vertex, _angle = image_angle) {
    var count = array_length(_listVertex);
    if (count < 3) return false;
    
    var inside = false;
    var j = count - 1;
    
    for (var i = 0; i < count; i++) {
        var vi = RotCoordinate(_listVertex[i], _angle);
        var vj = RotCoordinate(_listVertex[j], _angle);
        
        if (abs(_x - vi.x) < 0.001 && abs(_y - vi.y) < 0.001) return true;

        var cross = (_x - vi.x) * (vj.y - vi.y) - (_y - vi.y) * (vj.x - vi.x);
        if (abs(cross) < 0.001) {
            var dot = (_x - vi.x) * (vj.x - vi.x) + (_y - vi.y) * (vj.y - vi.y);
            if (dot >= 0) {
                var squaredLength = (vj.x - vi.x) * (vj.x - vi.x) + (vj.y - vi.y) * (vj.y - vi.y);
                if (dot <= squaredLength) {
                    return true;
                }
            }
        }
        
        if (((vi.y > _y) != (vj.y > _y)) && 
            (_x < (vj.x - vi.x) * (_y - vi.y) / (vj.y - vi.y) + vi.x)) {
            inside = !inside;
        }
        j = i;
    }
    
    return inside;
}

// 返回离旋转多边形边框最近的点(使用vector2优化)
// 传入参数:
//     _x: 全局x坐标
//     _y: 全局y坐标
//     _listVertex: 顶点数组
//     _angle: 旋转角度(可选)
// [最近点的x, y坐标]
function Limit(_x, _y, _listVertex = !cover ? Vertex_Online : Vertex, _angle = image_angle) {
    var count = array_length(_listVertex);
    if (count == 0) return [_x, _y];

    var localX = _x - x;
    var localY = _y - y;
    
	if (RelativeContains(localX, localY, _listVertex, _angle)) {
        return [_x, _y];
    }
    
    var closestX = 0;
    var closestY = 0;
    var minDist = 1000000;
    
    var j = count - 1;
    for (var i = 0; i < count; i++) {
        var vi = RotCoordinate(_listVertex[i], _angle);
        var vj = RotCoordinate(_listVertex[j], _angle);
        
        var x1 = vi.x, y1 = vi.y;
        var x2 = vj.x, y2 = vj.y;
        
        var l2 = (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1);
        if (l2 == 0) {
            var dist = point_distance(localX, localY, x1, y1);
            if (dist < minDist) {
                minDist = dist;
                closestX = x1;
                closestY = y1;
            }
        } else {
            var t = ((localX - x1) * (x2 - x1) + (localY - y1) * (y2 - y1)) / l2;
            t = max(0, min(1, t));
            
            var projX = x1 + t * (x2 - x1);
            var projY = y1 + t * (y2 - y1);
            
            var dist = point_distance(localX, localY, projX, projY);
            if (dist < minDist) {
                minDist = dist;
                closestX = projX;
                closestY = projY;
            }
        }
        j = i;
    }
    
    return [x + closestX, y + closestY];
}