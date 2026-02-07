var distance = point_distance(x, y, room_width / 2, room_height / 2)

if (auto_destroy && _beam_alpha <= 0 && distance >= 640) instance_destroy()

if (instance_exists(_inst)) {
	var deviate = RotAndPixelScale(18, 0, -image_angle)
	_inst.x = x + deviate.x;
	_inst.y = y + deviate.y;
	_inst.sprite_index = sprite_beam
	_inst.image_alpha = _beam_alpha
	_inst.image_angle = image_angle;
	_inst.image_xscale = 1000;
	_inst.image_yscale = _beam_scale + 0.75;
	
	if (_inst.image_alpha <= 0) instance_destroy(_inst)
}

if (Mode == "Ing") {
	if (sprite % 2 - 1 == 0) image_index=(image_index==2 ? 3 : 2);
	_beam_scale = image_yscale + sin(_beam_sin) / pi;
	_beam_sin += 0.35;
	sprite += 0.5
}

if (Mode == "Ing" || Mode == "Finish") {
	if (recoil && distance <= 640 + sprite_width) {
		_exit_speed += 2
		x -= lengthdir_x(_exit_speed, image_angle);
		y -= lengthdir_y(_exit_speed, image_angle);
	}
}