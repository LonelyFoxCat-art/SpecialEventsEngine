function MakeGBlaster(x, y, angle, x_target, y_target, angle_target, scale_x, scale_y, mode, pause, duration, sprite = spr_gb, color_blend = -1){
	var GasterBlaster = instance_create(x, y, bullet_gb);
	GasterBlaster.target_x = x_target;
	GasterBlaster.target_y = y_target;
	GasterBlaster.image_angle = angle;
	GasterBlaster.target_angle = angle_target;
	GasterBlaster.image_xscale = scale_x;
	GasterBlaster.image_yscale = scale_y;
	GasterBlaster.type = mode;
	GasterBlaster.time_release_delay = pause;
	GasterBlaster.time_beam_end_delay = duration;
	GasterBlaster.sprite_index = sprite;
	GasterBlaster.color_blend = color_blend;
	return GasterBlaster;
}