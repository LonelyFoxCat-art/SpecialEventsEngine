function MakeBoneRight(y, length, speed, mode, cover, right, duration = -1, board = Battle_GetBoard()){
	var X = board.x + board.width - length / 2;
	var Bone = MakeBone(X, y, length, speed, 0, mode, cover, DIR.RIGHT, right, duration);
	return Bone;
}