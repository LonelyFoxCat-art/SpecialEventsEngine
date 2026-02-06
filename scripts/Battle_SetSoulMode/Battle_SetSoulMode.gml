function Battle_SetSoulMode(Method, x = 0, y = 0){
	if (instance_exists(battle_soul)) {
		battle_soul.OnSoul = Method;
		return battle_soul;
	}
	
	var Soul = instance_create(x, y, battle_soul)
	Soul.OnSoul = Method;
	return Soul
}