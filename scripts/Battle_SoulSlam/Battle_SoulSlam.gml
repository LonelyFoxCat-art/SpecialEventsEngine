function Battle_SoulSlam(angle = DIR.DOWN){
	if !instance_exists(battle_soul) return false
	
	Battle_SetSoulMode(Battle_BlueSoul)
	
	battle_soul.impact = true
	battle_soul.move = 20
	battle_soul.image_angle = angle
}