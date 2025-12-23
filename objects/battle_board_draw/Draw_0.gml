for (var i = 0; i < array_length(global.BoardList); i++) {
	if !(instance_exists(global.BoardList[i])) array_delete(global.BoardList, i, 1);
	with(global.BoardList[i]) event_user(0);
}

draw_set_alpha(1);
surface_set_target(surface);
draw_surface(surface_cover, 0, 0);
surface_reset_target();
gpu_set_colorwriteenable(0, 0, 0, 1);
gpu_set_blendmode(bm_min);
surface_set_target(surface);
draw_surface(surface_mask, 0, 0);
surface_reset_target();
gpu_set_blendmode(bm_subtract);
surface_set_target(surface_extra);
draw_surface(surface_mask, 0, 0);
surface_reset_target();
gpu_set_blendmode(bm_normal);
gpu_set_colorwriteenable(1, 1, 1, 1);
draw_surface(surface, 0, 0);
draw_surface(surface_extra, 0, 0);