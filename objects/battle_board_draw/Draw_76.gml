if (!surface_exists(surface_extra)) surface_extra = surface_create(640, 480);
if (!surface_exists(surface_cover)) surface_cover = surface_create(640, 480);
if (!surface_exists(surface_mask)) surface_mask = surface_create(640, 480);
if (!surface_exists(surface)) surface = surface_create(640, 480);

surface_set_target(surface);
	draw_clear_alpha(color_bg, alpha_bg);
surface_reset_target();
surface_set_target(surface_mask);
	draw_clear_alpha(color_bg, 0);
surface_reset_target();
surface_set_target(surface_cover);
	draw_clear_alpha(color_frame, 0);
surface_reset_target();
surface_set_target(surface_extra);
	draw_clear_alpha(color_frame, 0);
surface_reset_target();
