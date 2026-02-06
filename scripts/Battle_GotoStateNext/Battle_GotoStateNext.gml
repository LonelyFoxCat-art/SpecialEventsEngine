function Battle_GotoStateNext(){
	if !(instance_exists(battle)) return false;
	Battle_ReviseState(Battle_ReviseStateNext())
	return true
}