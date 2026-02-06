function Battle_GetBoard(){
	return instance_exists(battle) ? battle.board : false;
}