function MakeBoneTwoV(x, y, speed, gap, mode, duration = -1, board = Battle_GetBoard()){
	var Bone = [];
	var y1 = y - board.y + board.height - gap;
	var y2 = board.y + board.height - gap - y;
	Bone[0] = MakeBoneTop(x, y1, speed, mode, true, false);
	Bone[1] = MakeBoneBottom(x, y2, speed, mode, true, false);
	return Bone;
}