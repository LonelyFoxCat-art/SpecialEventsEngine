function Camera_DrawPost(Camera){
	var Border = Camera.Border;
	var Window = window_get_multiple(Camera.Width, Camera.Height, 0, 0);
	
	if(Border.Enabled){
		Window = window_get_multiple(960, 540, 160, 30);
		if (sprite_exists(Border.Sprite)) {
			draw_sprite(Border.Sprite, 0, 0, 0);
		} else {
			draw_sprite_ext(spr_pixel, 0, Window.offset_x - 1, Window.offset_y - 1, (640 * Window.multiple) + 2, (480 * Window.multiple) + 2, 0, c_white, 1);
		}
	}

	display_set_gui_maximize(Window.multiple, Window.multiple, Window.offset_x, Window.offset_y);
}