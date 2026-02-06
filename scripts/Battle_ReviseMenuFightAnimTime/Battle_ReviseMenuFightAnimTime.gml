function Battle_ReviseMenuFightAnimTime(AnimTime = undefined){
	if !(instance_exists(battle)) return false;
	if (is_undefined(AnimTime)) return battle.AnimTime
	
	battle.AnimTime = AnimTime
	return true
}