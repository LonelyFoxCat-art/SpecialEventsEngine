function Battle_ReviseMenuFightDamage(Damage = undefined){
	if !(instance_exists(battle)) return false;
	if (is_undefined(Damage)) return battle.Damage
	
	battle.Damage = Damage
	return true
}