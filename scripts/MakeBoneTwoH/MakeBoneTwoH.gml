function MakeBoneTwoH(x, y, speed, gap, mode, duration = -1, board = Battle_GetBoard()){
	var Bone = [];
	var x1 = x - board.x + board.width - gap;
	var x2 = board.x + board.width - gap - x;
	Bone[0] = MakeBoneLeft(y, x1, speed, mode, true, false);
	Bone[1] = MakeBoneRight(y, x2, speed, mode, true, false);
	return Bone;
}