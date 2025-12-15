Vertex[0] = new Vector2(-width, -height) 
Vertex[1] = new Vector2(width, -height) 
Vertex[2] = new Vector2(width, height) 
Vertex[3] = new Vector2(-width, height) 


DivideVertex = [];

var size = array_length(Vertex);
if (size < 3) exit;

for (var i = 0; i < size; i++) {
    var a = Vertex[i];
    var b = Vertex[wrap_index(i + 1, size)];
    var c = Vertex[wrap_index(i - 1, size)];

    var ax = a.x, ay = a.y;
    var bx = b.x, by = b.y;
    var cx = c.x, cy = c.y;

    var mx = (ax + bx) / 2;
    var my = (ay + by) / 2;

    var dir_ab = point_direction(ax, ay, bx, by);
    var normal_dir = dir_ab + 90;

    var angle1 = point_direction(ax, ay, bx, by);
    var angle2 = point_direction(ax, ay, cx, cy);
    var dangle = (angle1 - angle2) / 2;

    var offset_len = 0;
    if (abs(dangle) > 0.000001) {
        offset_len = 5 / dtan(dangle);
    }

    var edge_vec = new Vector2(bx - ax, by - ay);
    var mid_point = new Vector2(mx, my);
    var normal_offset = RotAndPixelScale(edge_vec, normal_dir, 0, 5);
    var v1 = new Vector2(lengthdir_x(5, normal_dir), lengthdir_y(5, normal_dir));
    var v2 = new Vector2(lengthdir_x(point_distance(ax, ay, bx, by) / 2 + offset_len, point_direction(bx, by, ax, ay)),
                         lengthdir_y(point_distance(ax, ay, bx, by) / 2 + offset_len, point_direction(bx, by, ax, ay)));

    var outline_pt = new Vector2(mx, my);
    outline_pt.x += v1.x + v2.x;
    outline_pt.y += v1.y + v2.y;

    Vertex_Outline[i] = new Vector2(outline_pt.x, outline_pt.y);
}

var outline_vectors = [];
for (var i = 0; i < array_length(Vertex_Outline); i++) {
    outline_vectors[i] = new Vector2(Vertex_Outline[i].x, Vertex_Outline[i].y);
}

var tri_indices = Delaunay_EarClipping(outline_vectors);

DivideVertex = tri_indices;