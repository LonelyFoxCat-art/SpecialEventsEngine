function Battle_SetTurnResetScale(Index, Width = 283, Height = 65){
	if (instance_exists(battle)) {
		if (Index >= 0 && Index < Battle_GetTurnCount()) {
			battle.TurnList[Index].ResetWidth = Width
			battle.TurnList[Index].ResetHeight = Height
		}
		return true
	}
	return false
}