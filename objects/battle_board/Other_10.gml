// 边框
var freamwidth = cover ? 0 : 5
surface_set_target(cover ? battle_board_draw.surface_cover : battle_board_draw.surface_extra)
	draw_set_alpha(alpha)
	draw_set_color(color);
	draw_primitive_begin(pr_trianglefan);
	var start = RotAndPixelScale(Vertex[0], image_angle, freamwidth);
	for (var i = 0; i < array_length(Vertex); i++) {
		var Vertexs = RotAndPixelScale(Vertex[i], image_angle, freamwidth);
	    draw_vertex(x + Vertexs.x, y + Vertexs.y);
	}

	draw_vertex(x + start.x, y + start.y);
	draw_primitive_end();
surface_reset_target()

gpu_set_colorwriteenable(false, false, false, true);
gpu_set_blendenable(false);
surface_set_target(!cover ? battle_board_draw.surface_cover : battle_board_draw.surface_extra);
	draw_set_alpha(0);
	draw_primitive_begin(pr_trianglefan);
	var start = RotAndPixelScale(Vertex[0], image_angle, freamwidth);
	for (var i = 0; i < array_length(Vertex); i++) {
		var Vertexs = RotAndPixelScale(Vertex[i], image_angle, freamwidth);
	    draw_vertex(x + Vertexs.x, y + Vertexs.y);
	}

	draw_vertex(x + start.x, y + start.y);
	draw_primitive_end();
surface_reset_target();
gpu_set_blendenable(true);
gpu_set_colorwriteenable(true, true, true, true);


// 内部填充
var fullwidth = cover ? -5 : 0
gpu_set_colorwriteenable(false, false, false, true);
gpu_set_blendenable(false);
surface_set_target(battle_board_draw.surface_mask);
	var start = RotAndPixelScale(Vertex[0], image_angle, fullwidth);
	draw_set_alpha(!cover);
	draw_primitive_begin(pr_trianglefan);
	for (var i = 0; i < array_length(Vertex); i++) {
		var Vertexs = RotAndPixelScale(Vertex[i], image_angle, fullwidth);
	    draw_vertex(x + Vertexs.x, y + Vertexs.y);
	}

	draw_vertex(x + start.x, y + start.y);
	draw_primitive_end();
surface_reset_target()

if (!cover) {
	surface_set_target(battle_board_draw.surface_extra)
		var start = RotAndPixelScale(Vertex[0], image_angle, fullwidth);
		draw_set_alpha(0);
		draw_primitive_begin(pr_trianglefan);
		for (var i = 0; i < array_length(Vertex); i++) {
			var Vertexs = RotAndPixelScale(Vertex[i], image_angle, fullwidth);
		    draw_vertex(x + Vertexs.x, y + Vertexs.y);
		}

		draw_vertex(x + start.x, y + start.y);
		draw_primitive_end();
	surface_reset_target()
}

gpu_set_blendenable(true);
gpu_set_colorwriteenable(true, true, true, true);

// 恢复默认
draw_set_alpha(1)
draw_set_color(c_white)