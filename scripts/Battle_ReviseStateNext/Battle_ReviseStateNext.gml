function Battle_ReviseStateNext(State = undefined){
	if !(instance_exists(battle)) return false;
	if (is_undefined(State)) return battle.State_Next;
	
	battle.State_Next = State;
	return true
}