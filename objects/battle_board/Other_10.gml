var size = array_length(DivideVertex);
if (array_length(Vertex) < 3) exit;

// 边框
surface_set_target(cover ? battle_board_draw.surface_cover : battle_board_draw.surface_extra)
    for (var i = 0; i < size; i++) {
		draw_primitive_begin(pr_trianglestrip);
		
		var DVertex = DivideVertex[i];
		for (var j = 0; j < 3; j++) {
			var pos = RotAndPixelScale(Vertex_Outline[DVertex[j]], image_angle);
			draw_vertex_color(x + pos.x, y + pos.y, color, alpha);
		}
		
		draw_primitive_end()
	}
surface_reset_target()

gpu_set_colorwriteenable(false, false, false, true);
gpu_set_blendenable(false);

surface_set_target(!cover ? battle_board_draw.surface_cover : battle_board_draw.surface_extra);
	draw_set_alpha(0);
	for (var i = 0; i < size; i++) {
		draw_primitive_begin(pr_trianglestrip);
		
		var DVertex = DivideVertex[i];
		for (var j = 0; j < 3; j++) {
			var pos = RotAndPixelScale(Vertex[DVertex[j]], image_angle);
			draw_vertex(x + pos.x, y + pos.y);
		}
		
		draw_primitive_end()
	}
surface_reset_target();

// 内部填充
surface_set_target(battle_board_draw.surface_mask);
	draw_set_alpha(!cover);
	for (var i = 0; i < size; i++) {
		draw_primitive_begin(pr_trianglestrip);
		
		var DVertex = DivideVertex[i];
		for (var j = 0; j < 3; j++) {
			var pos = RotAndPixelScale(Vertex[DVertex[j]], image_angle);
			draw_vertex(x + pos.x, y + pos.y);
		}
		
		draw_primitive_end()
	}
surface_reset_target()

gpu_set_blendenable(true);
gpu_set_colorwriteenable(true, true, true, true);