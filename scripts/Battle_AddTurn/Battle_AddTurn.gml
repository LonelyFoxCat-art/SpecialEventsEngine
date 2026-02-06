function Battle_AddTurn(Turn, Time, Width, Height, X = 320, Y = 320){
	var TurnCount = Battle_GetTurnCount()
	Battle_ReviseTurn(TurnCount, Turn)
	Battle_SetTurnTime(TurnCount, Time)
	Battle_SetTurnSoulLocation(TurnCount, X, Y)
	Battle_SetTurnScale(TurnCount, Width, Height)
	return true
}