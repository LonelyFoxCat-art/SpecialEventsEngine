function Battle_CreateBoardRect(X, Y, Width, Height){
	var Inst = instance_create(X, Y, battle_board_rectangle);
	Inst.width = Width;
	Inst.height = Height;
	
	return Inst;
}