function Battle_SetTurnTime(Index, Time){
	if (instance_exists(battle)) {
		if (Index >= 0 && Index < Battle_GetTurnCount()) {
			battle.TurnList[Index].Time = Time
		}
		return true
	}
	return false
}