function MakeStabAlert(x1, y1, x2, y2, time, sound = noone){
	var stab = instance_create_depth(0,0,0,bullet_stab_alert);
	stab.duration = time;
	stab.x1 = x1;
	stab.y1 = y1;
	stab.x2 = x2;
	stab.y2 = y2;
	
	audio_play_sound(sound, 0, false);
	return stab;
}