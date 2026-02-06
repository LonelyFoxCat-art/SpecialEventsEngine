function Battle_StartRandomConditionTurn(Condition, Start, Finish = Battle_GetEnemyCount()){
	if (Condition) {
		return Battle_StartRandomTurn(Start, Finish)
	}
	return false
}