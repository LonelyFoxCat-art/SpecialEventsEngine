function Battle_ReviseEnemySpareable(Index, Spare = undefined){
	if !(instance_exists(battle)) return false

	if (Index >= 0 && Index < Battle_GetEnemyCount()) {
		if (is_undefined(Spare)) return battle.EnemyList[Index][$ "Spareable"] ?? 0
		battle.EnemyList[Index][$ "Spareable"] = clamp(Spare, 0, 100)
	}
	return true
}