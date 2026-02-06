function Battle_ReviseChoiceButton(Index = false){
	if !(instance_exists(battle)) return false;
	if !(is_real(Index)) return battle.Index;
	
	battle.Index = wrap_index(battle.Index + Index, Battle_GetButtonCount())
	return true
}