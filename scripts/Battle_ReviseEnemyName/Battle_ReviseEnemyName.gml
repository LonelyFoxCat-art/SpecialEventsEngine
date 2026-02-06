function Battle_ReviseEnemyName(Index, Name = undefined){
	if !(instance_exists(battle)) return false

	if (Index >= 0 && Index < Battle_GetEnemyCount()) {
		if (is_undefined(Name)) return battle.EnemyList[Index][$ "Name"] ?? "ENEMY"
		battle.EnemyList[Index][$ "Name"] = Name
	}
	return false
}