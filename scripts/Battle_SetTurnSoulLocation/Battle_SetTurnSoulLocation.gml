function Battle_SetTurnSoulLocation(Index, X = 320, Y = 320){
	if (instance_exists(battle)) {
		if (Index >= 0 && Index < Battle_GetTurnCount()) {
			battle.TurnList[Index].SOULX = X
			battle.TurnList[Index].SOULY = Y
		}
		return true
	}
	return false
}