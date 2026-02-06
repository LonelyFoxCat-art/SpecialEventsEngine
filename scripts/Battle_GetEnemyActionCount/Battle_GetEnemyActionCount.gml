function Battle_GetEnemyActionCount(Index){
	if !(instance_exists(battle)) return false
	
	if (Index >= 0 && Index < Battle_GetEnemyCount()) {
		return array_length(battle.EnemyList[Index].Action)
	}
	return false
}