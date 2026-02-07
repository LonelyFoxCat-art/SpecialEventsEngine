if (time > 0) {
	time --
} else if (time == 0) {
	Mode = Mode_Next
	if (Mode == "Move") {
		Anim_Create(id,"image_angle",AnimTween.SINE.OUT,image_angle,target_angle-image_angle,30);
		Anim_Create(id,"x",AnimTween.SINE.OUT,x,target_x-x,30);
		Anim_Create(id,"y",AnimTween.SINE.OUT,y,target_y-y,30);
		audio_stop_sound(sound_charge);
		audio_play_sound(sound_charge,0,0);
		Mode_Next = "Ready"
		time = 30 + time_release_delay + 1;
	} else if (Mode == "Ready") {
		Anim_Create(id,"image_yscale",AnimTween.Linear,image_yscale,-0.2,6);
		Anim_Create(id,"image_yscale",AnimTween.Linear,image_yscale-0.2,0.2,6,6);
		Mode_Next = "Start"
		time = 7
	} else if (Mode == "Start") {
		Anim_Create(id,"image_index",AnimTween.Linear,0,3,6);
		Anim_Create(id,"_beam_scale",AnimTween.Linear,0,image_yscale,8);

		audio_stop_sound(sound_release);
		audio_play_sound(sound_release,0,0);

		if !(instance_exists(_inst)) _inst = instance_create(0, 0, bullet_gb_beam)
		_beam_alpha = 1
		_exit_speed = 0
		
		if(image_yscale >= 2){
			Camera_Shaker(2, 1, 1)
			Camera_Shaker(2, 1, 1)
		}
		
		Mode_Next = "Ing"
		time = 6
	} else if (Mode == "Ing") {
		Mode_Next = "Finish"
		time = time_beam_end_delay + 1
	} else if (Mode == "Finish") {
		Anim_Create(id, "_beam_scale", AnimTween.Linear, _beam_scale, -_beam_scale, 10);
		Anim_Create(id, "_beam_alpha", AnimTween.Linear, 1, -1, 10);
		Mode_Next = "Retrieve"
		time = 10
	} else if (Mode == "Retrieve") {
		if !(recoil) Anim_Create(id,"image_index",AnimTween.Linear,image_index,-image_index,6);
		time = -1
	}
}