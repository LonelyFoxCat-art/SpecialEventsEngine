function Battle_ReviseChoiceMenu(Index = undefined){
	if !(instance_exists(battle)) return false;
	if (is_undefined(Index)) return battle.ButtonList[battle.Index].Index;
	
	battle.ButtonList[battle.Index].Index = Index
	return true
}