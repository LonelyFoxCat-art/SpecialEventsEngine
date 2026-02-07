function MakeRedirectGBlaster(inst, x, y, angle, mode, pause, duration){
	if !(instance_exists(inst)) return false;
	
	inst.target_x = x;
	inst.target_y = y;
	inst.target_angle = angle;
	inst.type = mode;
	inst.time_release_delay = pause;
	inst.time_beam_end_delay = duration;
	
	inst.Mode_Next = "Move";
	inst.time = 10;
	
	return inst;
}