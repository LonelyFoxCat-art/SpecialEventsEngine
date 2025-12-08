for (var i = 0; i < array_length(Vertex); i++) {
	Vertex_Online[i] = RotAndPixelScale(Vertex[i], image_angle, cover ? 5 : 0);
}