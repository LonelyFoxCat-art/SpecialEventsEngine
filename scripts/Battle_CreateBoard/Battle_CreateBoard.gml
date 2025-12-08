function Battle_CreateBoard(X, Y, Vertex){
	var Inst = instance_create(X, Y, battle_board);
	Inst.Vertex = Vertex;
	
	return Inst;
}