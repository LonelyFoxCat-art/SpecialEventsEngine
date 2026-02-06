function Battle_SetTurnResetLocation(Index, X = 320, Y = 320){
	if (instance_exists(battle)) {
		if (Index >= 0 && Index < Battle_GetTurnCount()) {
			battle.TurnList[Index].ResetX = X
			battle.TurnList[Index].ResetY = Y
		}
		return true
	}
	return false
}