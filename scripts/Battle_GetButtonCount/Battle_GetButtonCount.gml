function Battle_GetButtonCount(){
	if !(instance_exists(battle)) return false;
	return array_length(battle.ButtonList);
}