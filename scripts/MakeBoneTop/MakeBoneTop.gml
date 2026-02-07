function MakeBoneTop(x, length, speed, mode, cover, top, duration = -1, board = Battle_GetBoard()){
	var Y = board.y - board.height + length / 2;
	var Bone = MakeBone(x, Y, length, 0, speed, mode, cover, DIR.UP, top, duration);
	return Bone;
}