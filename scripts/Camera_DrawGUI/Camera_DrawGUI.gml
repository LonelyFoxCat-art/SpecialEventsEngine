function Camera_DrawGUI(){
	var Camera = global.structure.Invoke("Camera");
	var Fader = Camera.Fader;
	
	draw_surface(application_surface, 0, 0);

	draw_set_alpha(Fader.Alpha);
	draw_rectangle_color(0, 0, room_width, room_height, Fader.Color, Fader.Color, Fader.Color, Fader.Color, false);
	draw_set_alpha(1);
}