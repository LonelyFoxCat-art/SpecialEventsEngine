function Battle_ReviseMenuDialog(text = 1){
	if !(instance_exists(battle)) return false;
	if !(is_string(text)) return battle.MenuDiglog;
	
	battle.MenuDiglog = text;
	return true
}