function Battle_GetTurnCount(){
	if !(instance_exists(battle)) return false
	return array_length(battle.TurnList)
}