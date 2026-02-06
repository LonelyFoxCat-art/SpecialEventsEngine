function Battle_SetTurnScale(Index, Width = 70, Height = 65){
	if (instance_exists(battle)) {
		if (Index >= 0 && Index < Battle_GetTurnCount()) {
			battle.TurnList[Index].Width = Width
			battle.TurnList[Index].Height = Height
		}
		return true
	}
	return false
}