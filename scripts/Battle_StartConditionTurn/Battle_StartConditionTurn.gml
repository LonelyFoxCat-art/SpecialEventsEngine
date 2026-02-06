function Battle_StartConditionTurn(Condition, Start, Finish = Battle_GetTurnCount()){
	if (Condition) {
		return Battle_StartTurn(Start, Finish)
	}
	return false
}