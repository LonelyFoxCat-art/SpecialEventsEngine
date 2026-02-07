function MakeBoneWallRight(pause, length, duration, mode, board = Battle_GetBoard()){
	var Bone = [];
	var ii = 0;
	for(var i = -3; i < board.height * 2 + 11; i += 11){
		ii += 1;
		var X = board.x + board.width + length / 2 + 5;
		var Y = board.y - board.height + i;
		Bone[ii] = MakeBone(X, Y, length, 0, 0, mode, true, DIR.RIGHT, 1, duration + pause * 2 + 8);
		with(Bone[ii]){
			Anim_Create(id, "x", AnimTween.Linear, x, - length - 5, 8, pause);
			Anim_Create(id, "x", AnimTween.Linear, x - length - 5, length + 5, 8, 16 + pause + duration);
		}
	}
	
	MakeStabAlert(board.x + board.width, board.y - board.height, board.x + board.width - length, board.y + board.height, pause, snd_exclamation)
	Timer_CreateTemp(pause + 4, function() { audio_play_sound(snd_stab, 0, false) })
	return Bone;
}	