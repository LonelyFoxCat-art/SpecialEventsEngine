function Battle_ReviseMenuFightDamageTime(DamageTime = undefined){
	if !(instance_exists(battle)) return false;
	if (is_undefined(DamageTime)) return battle.DamageTime
	
	battle.DamageTime = DamageTime
	return true
}