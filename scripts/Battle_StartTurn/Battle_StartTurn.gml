function Battle_StartTurn(Start, Finish = Battle_GetTurnCount()){
	var TurnIndex = clamp(Battle_ReviseTurnNumber(), Start, Finish)
	var Turn = Battle_ReviseTurn(TurnIndex)
	
	if (!instance_exists(Turn)) {
		instance_create(0, 0, Turn)
		return true
	}
	return false
}