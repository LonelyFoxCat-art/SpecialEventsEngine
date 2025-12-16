DivideVertex = [];

var size = array_length(Vertex);
if (size < 3) exit;

for (var i = 0; i < size; i++) {
    Vertex_Outline[i] = RotAndPixelScale(Vertex[i], 0, 5);
}

var tri_indices = Delaunay_EarClipping(Vertex_Outline);
DivideVertex = tri_indices;