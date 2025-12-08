function Battle_GetBoardSurface(){
	return instance_exists(battle_board_draw) ? battle_board_draw.surface : false;
}