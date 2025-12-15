var size = array_length(DivideVertex);

// 边框
surface_set_target(cover ? battle_board_draw.surface_cover : battle_board_draw.surface_extra)
    for (var i = 0; i < size; i++) {
		draw_primitive_begin(pr_trianglestrip);
		
		var DVertex = DivideVertex[i];
		for (var j = 0; j < 3; j++) {
			var pos = Vertex_Outline[DVertex[j]];
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
			var pos = Vertex[DVertex[j]];
			draw_vertex(x + pos.x, y + pos.y);
		}
		
		draw_primitive_end()
	}
surface_reset_target();

gpu_set_blendenable(true);
gpu_set_colorwriteenable(true, true, true, true);


//// 内部填充
gpu_set_colorwriteenable(false, false, false, true);
gpu_set_blendenable(false);

surface_set_target(battle_board_draw.surface_mask);
	draw_set_alpha(!cover);
	for (var i = 0; i < size; i++) {
		draw_primitive_begin(pr_trianglestrip);
		
		var DVertex = DivideVertex[i];
		for (var j = 0; j < 3; j++) {
			var pos = Vertex[DVertex[j]];
			draw_vertex(x + pos.x, y + pos.y);
		}
		
		draw_primitive_end()
	}
surface_reset_target()

//if (!cover) {
//	surface_set_target(battle_board_draw.surface_extra)
//		draw_set_alpha(0);
//		draw_primitive_begin(pr_trianglestrip);
		
//		var start = RotAndPixelScale(Vertex[0], image_angle, fullwidth);
//		for (var i = 0; i < array_length(Vertex); i++) {
//			var Vertexs = RotAndPixelScale(Vertex[i], image_angle, fullwidth);
//		    draw_vertex(x + Vertexs.x, y + Vertexs.y);
//		}

//		draw_vertex(x + start.x, y + start.y);
//		draw_primitive_end();
//	surface_reset_target()
//}

gpu_set_blendenable(true);
gpu_set_colorwriteenable(true, true, true, true);

//// 恢复默认
//draw_set_alpha(1)
//draw_set_color(c_white)