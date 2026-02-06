function Battle_ReviseMenuFell(Fell = undefined){
	if !(instance_exists(battle)) return false;
	if (is_undefined(Fell)) return battle.Fell
		
	battle.Fell = Fell
	return true
}