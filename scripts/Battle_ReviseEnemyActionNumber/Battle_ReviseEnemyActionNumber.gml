function Battle_ReviseEnemyActionNumber(Index, Number = undefined){
	if !(instance_exists(battle)) return false
	
	if (Index >= 0 && Index < Battle_GetEnemyCount()) {
		if (is_undefined(Number)) return battle.EnemyList[Index].ActionIndex
		battle.EnemyList[Index].ActionIndex = Number
	}
	return false
}