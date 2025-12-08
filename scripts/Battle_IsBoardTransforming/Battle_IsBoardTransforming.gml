function Battle_IsBoardTransforming(){
	if !(instance_exists(battle)) return false;
	var Board = Battle_GetBoard();
	return (Anim_IsExist(Board, "width") || Anim_IsExist(Board, "height") || Anim_IsExist(Board, "x") || Anim_IsExist(Board, "y"));
}