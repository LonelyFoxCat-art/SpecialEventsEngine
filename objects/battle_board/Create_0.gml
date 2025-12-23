if !instance_exists(battle_board_draw) instance_create(0, 0, battle_board_draw, -500)

depth = -500

Index = 0

cover = false

Vertex = [];
Vertex_Outline = [];
DivideVertex = [];
isCollide = array_create(4, false)

width = 165
height = 165

color = c_white
alpha = 1

angle = 0

// 判断点是否在旋转后的多边形内
function Contains(_x, _y, _listVertex = cover ? Vertex_Outline : Vertex) {
    return RelativeContains(_x - x, _y - y, _listVertex);
}

// 判断点是否在旋转后的多边形内
function RelativeContains(_x, _y, _listVertex = cover ? Vertex_Outline : Vertex) {
    var size = array_length(_listVertex);
    if (size < 3) return false;

    var rot = Matrix3x2.CreateRotation(-image_angle);
    var p = Vector2.Transform(Vector2(_x, _y), rot);

    var isAllHor = true, prevTrend, prevHasInter;
    var prev = Vector2(_listVertex[size - 1].x, _listVertex[size - 1].y);
    for (var i = size - 2; i >= 0; i--) {
        var cur = Vector2(_listVertex[i].x, _listVertex[i].y);
        if (prev.y != cur.y) {
            isAllHor = false;
            prevTrend = cur.y < prev.y;
            prevHasInter = (p.y >= min(prev.y, cur.y) && p.y <= max(prev.y, cur.y));
            break;
        }
        prev = cur;
    }
    if (isAllHor) return false;

    var intersections = [], count = 0;
    prev = Vector2(_listVertex[size - 1].x, _listVertex[size - 1].y);
    for (var i = 0; i < size; i++) {
        var cur = Vector2(_listVertex[i].x, _listVertex[i].y);
        if (prev.y != cur.y) {
            var trend = cur.y > prev.y;
            var inYRange = (p.y >= min(prev.y, cur.y) && p.y <= max(prev.y, cur.y));
            var hasInter = (trend != prevTrend || !prevHasInter) && inYRange;
            if (hasInter) {
                var dx = cur.x - prev.x, dy = cur.y - prev.y;
                intersections[count++] = prev.x + dx * (p.y - prev.y) / dy;
            }
            if (trend != prevTrend) prevTrend = trend;
            prevHasInter = hasInter;
        }
        prev = cur;
    }
    if (count == 0) return false;

    array_sort(intersections, true);
    var inside = false;
    for (var i = 0; i < count; i++) {
        if (intersections[i] > p.x) return inside;
        inside = !inside;
    }
    return false;
}

// 返回离旋转多边形边框最近的点
function Limit(_x, _y, _listVertex = cover ? Vertex_Outline : Vertex) {
    var size = array_length(_listVertex);
    if (size == 0) return [_x, _y];
    if (size == 1) {
        var v = _listVertex[0];
        var r = Vector2.Transform(Vector2(v.x, v.y), Matrix3x2.CreateRotation(image_angle));
        return [r.x + x, r.y + y];
    }

    var local = Vector2(_x - x, _y - y);
    var p = Vector2.Transform(local, Matrix3x2.CreateRotation(-image_angle));

    var nearest, minDist = -1;
    var prev = Vector2(_listVertex[size - 1].x, _listVertex[size - 1].y);
    for (var i = 0; i < size; i++) {
        var cur = Vector2(_listVertex[i].x, _listVertex[i].y);
        var edge = Vector2.Subtract(cur, prev);
        var toPrev = Vector2.Subtract(p, prev);
        var dot = Vector2.Dot(toPrev, edge);
        var len2 = Vector2.LengthSquared(edge);

        var proj;
        if (len2 == 0) {
            proj = prev;
        } else {
            var t = clamp(dot / len2, 0, 1);
            proj = Vector2.Add(prev, Vector2.Multiply(edge, t));
        }

        var dist = Vector2.Distance(p, proj);
        if (dist < minDist || minDist == -1) {
            minDist = dist;
            nearest = proj;
        }
        prev = cur;
    }

    var r = Vector2.Transform(nearest, Matrix3x2.CreateRotation(image_angle));
    return [r.x + x, r.y + y];
}