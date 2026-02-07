function MakeBoneWallBottom(pause, length, duration, mode, board = Battle_GetBoard()){
	var Bone = [];
	var ii = 0;
	for(var i = -3; i < board.width * 2 + 11; i += 11){
		ii += 1;
		var X = board.x - board.width + i;
		var Y = board.y + board.height + length / 2 + 5;
		Bone[ii] = MakeBone(X, Y, length, 0, 0, mode, true, DIR.DOWN, 1, duration + pause * 2 + 8);
		with(Bone[ii]){
			Anim_Create(id, "y", AnimTween.Linear, y, - length - 5, 8, pause);
			Anim_Create(id, "y", AnimTween.Linear, y - length - 5, length + 5, 8, 16 + pause + duration);
		}
	}
	
	MakeStabAlert(board.x - board.width, board.y + board.height - length, board.x + board.width, board.y + board.height, pause, snd_exclamation)
	Timer_CreateTemp(pause + 4, function() { audio_play_sound(snd_stab, 0, false) })
	return Bone;
}