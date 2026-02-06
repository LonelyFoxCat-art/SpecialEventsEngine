function Battle_ReviseEnemyAction(Index, Name, Tp = 0){
	if !(instance_exists(battle)) return false
	
	if (Index >= 0 && Index < Battle_GetEnemyCount()) {
		var ActionStruct = {
			Name: Name,
			Tp: Tp,
		}
		array_push(battle.EnemyList[Index].Action, ActionStruct)
	}
	return false
}