function Camera_DrawPost(){
	var Camera = global.structure.Invoke("Camera");
	var Window = undefined;
	
	if(Camera.Border.Enabled){
		Window = window_get_multiple(960, 540, 160, 30);
		if (sprite_exists(Camera.Border.Sprite)) {
			draw_sprite(Camera.Border.Sprite, 0, 0, 0);
		} else {
			draw_sprite_ext(spr_pixel, 0, Window.offset_x - 1, Window.offset_y - 1, (640 * Window.multiple) + 2, (480 * Window.multiple) + 2, 0, c_white, 1);
		}
	} else {
		Window = window_get_multiple(640, 480, 0, 0);
	}

	display_set_gui_maximize(Window.multiple, Window.multiple, Window.offset_x, Window.offset_y);
}