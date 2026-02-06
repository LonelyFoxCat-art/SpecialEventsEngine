function Battle_ReviseEnemyDef(Index, Def = 0){
	if !(instance_exists(battle)) return false

	if (Index >= 0 && Index < Battle_GetEnemyCount()) {
		if (is_undefined(Def)) return battle.EnemyList[Index][$ "Def"] ?? 0
		battle.EnemyList[Index][$ "Def"] = Def
	}
	return false
}