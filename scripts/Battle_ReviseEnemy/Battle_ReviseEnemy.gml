function Battle_ReviseEnemy(Index, Enemy = undefined, X = 320, Y = 160){
	if !(instance_exists(battle)) return false;
	if (is_undefined(Enemy)) return battle.EnemyList[Index].Instance
	
	var EnemyStruct = {
		ActionIndex: 0,
		Instance: Enemy,
		Name: "ENEMY",
		Action: [],
		Spareable: 0
	}

	if !(instance_exists(Enemy)) EnemyStruct.Instance = instance_create(X, Y, Enemy)
	Enemy.enemy_id = Index
	
	array_push(battle.EnemyList, EnemyStruct)
	Battle_CallEnemyEvent(0, Index)
	return EnemyStruct;
}