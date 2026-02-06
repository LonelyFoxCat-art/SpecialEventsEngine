function Battle_StartRandomTurn(Start, Finish = Battle_GetTurnCount()){
	var TurnIndex = irandom_range(Start, Finish)
	var Turn = Battle_ReviseTurn(TurnIndex)
	
	if (!instance_exists(Turn)) {
		instance_create_depth(0,0,0,Turn)
		return true
	}
	return false
}