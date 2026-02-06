function Battle_GetEnemyCount(){
	if !(instance_exists(battle)) return 0;
	return array_length(battle.EnemyList);
}