function Battle_BlueSoul(inst){
	image_blend = c_blue
	
	if (Battle_ReviseState() != BATTLE.STATE.INTURN) return;
	
	var SPD = Player_GetSpeedTotal()
	var SPD = (Input_IsDirect(KEY.CANCEL) ? SPD/2 : SPD)
	var state, input_jump, xx = 0, yy = 0;
	var _gravity_jump = 0.1, _gravity_fall = 0.158, _gravity_fall_max = 10
	var _speed_jump = 4
	
	if image_angle == DIR.DOWN {
		input_jump = KEY.UP
		state = 1
		xx = 0
		yy = -0.01
	}else if image_angle == DIR.UP {
		input_jump = KEY.DOWN
		state = 0
		xx = 0
		yy = 0.01
	}else if image_angle == DIR.RIGHT {
		input_jump = KEY.LEFT
		state = 2
		xx = -0.01
		yy = 0
	}else if image_angle == DIR.LEFT {
		input_jump = KEY.RIGHT
		state = 3
		xx = 0.01
		yy = 0
	}
	
	var IsInsideBoard = Battle_IsBoardEdge(1);
	var IsInsidePlatformExtra = InstanceQuadrilateralPosition(bullet_platform, 1)
	var IsInsidePlatform = InstanceQuadrilateralPosition(bullet_platform)
		
	if (IsInsidePlatform[state]) {
		repeat 200 {
			x += xx
			y += yy
		}
	}
		
	// 重力处理
	if IsInsideBoard[state] {
		if (move < 0) {
			move += _gravity_jump;
			if (!Input_IsDirect(input_jump)) { move = lerp(move, 0, 0.5) }
			if (move > 0) { move = lerp(0, move, 0.5) }
		} else if (move < _gravity_fall_max) {
			var fallFactor = move / _gravity_fall_max;
			move += _gravity_fall * (0.5 + fallFactor * 0.5);
		}
		if (IsInsidePlatformExtra[state]) {
			if move >= 0 { move = 0 }
			if impact {
				audio_play_sound(snd_impact, false, false)
				impact = false
			}
		}
	}else{
		move = 0
		if impact {
			audio_play_sound(snd_impact, false, false)
			impact = false
		}
	}
		
	// 跳跃处理
	if (!IsInsideBoard[state] || (IsInsidePlatformExtra[state]) && move >= 0) && Input_IsPress(input_jump) move += -_speed_jump
	
	// 移动处理
	if state == 0 || state == 1 {
		if Input_IsPress(KEY.LEFT) x -= SPD
		if Input_IsPress(KEY.RIGHT) x += SPD
		y += (state == 1 ? move : -move)
	} else 	if state == 2 || state == 3 {
		if Input_IsPress(KEY.UP) y -= SPD
		if Input_IsPress(KEY.DOWN) y += SPD
		x += (state == 2 ? move : -move)
	}
		
	//随板子移动
	var PlatformList = InstanceGetList(bullet_platform)
	for(var i = 0; i < array_length(PlatformList); i ++){
		var PlatformInst = PlatformList[i]
		var IsInsidePlatformInst = InstancelPosition(PlatformInst, 1)
		with (PlatformInst) {
			if(IsInsidePlatformInst[state] && mode == 0){
				other.x += (x - xprevious);
				other.y += (y - yprevious);
			}
		}
	}
}