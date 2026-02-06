function Battle_ReviseEnemyMaxHp(Index, MaxHp = 0){
	if !(instance_exists(battle)) return false

	if (Index >= 0 && Index < Battle_GetEnemyCount()) {
		if (is_undefined(MaxHp)) return battle.EnemyList[Index][$ "MaxHp"] ?? 0
		battle.EnemyList[Index][$ "MaxHp"] = MaxHp
	}
	return false
}