function RelativeContains(x, y, Vertex){
	var size = array_length(Vertex);
    if (size < 3) return false;

    var rot = Matrix3x2.CreateRotation(-image_angle);
    var p = Vector2.Transform(new Vectors2(_x, _y), rot);

    var isAllHor = true, prevTrend, prevHasInter;
    var prev = new Vectors2(Vertex[size - 1].x, Vertex[size - 1].y);
    for (var i = size - 2; i >= 0; i--) {
        var cur = new Vectors2(Vertex[i].x, Vertex[i].y);
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
    prev = new Vectors2(Vertex[size - 1].x, Vertex[size - 1].y);
    for (var i = 0; i < size; i++) {
        var cur = new Vectors2(Vertex[i].x, Vertex[i].y);
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