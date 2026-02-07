function MakeBoneLeft(y, length, speed, mode, cover, left, duration = -1, board = Battle_GetBoard()){
	var X = board.x - board.width + length / 2;
	var Bone = MakeBone(X, y, length, speed, 0, mode, cover, DIR.LEFT, left, duration);
	return Bone;
}