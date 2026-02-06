function Battle_ReviseEnemyHp(Index, Hp = 0){
	if !(instance_exists(battle)) return false

	if (Index >= 0 && Index < Battle_GetEnemyCount()) {
		if (is_undefined(Hp)) return battle.EnemyList[Index][$ "Hp"] ?? 0
		battle.EnemyList[Index][$ "Hp"] = Hp
	}
	return false
}