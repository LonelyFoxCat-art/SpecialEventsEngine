function Battle_RedSoul(inst){
	image_blend = c_red
	
	if (Battle_ReviseState() != BATTLE.STATE.INTURN) return;

	var SPD = Player_GetSpeedTotal()
	SPD = (Input_IsDirect(KEY.CANCEL) ? SPD / 2 : SPD);

	if Input_IsPress(KEY.UP) y -= SPD
	if Input_IsPress(KEY.DOWN) y += SPD
	if Input_IsPress(KEY.LEFT) x -= SPD
	if Input_IsPress(KEY.RIGHT) x += SPD
}