function MakeBoneWallLeft(pause, length, duration, mode, board = Battle_GetBoard()){
	var Bone = [];
	var ii = 0;
	for(var i = -3; i < board.height * 2 + 11; i += 11){
		ii += 1;
		Bone[ii] = MakeBone(board.x - board.width - 13, board.y - board.height + i, 0, 0, 0, mode, true, DIR.LEFT, 0, duration + pause * 2 + 8);
		with(Bone[ii]){
			Anim_Create(id, "length", AnimTween.Linear, 0, length, 8, pause);
			Anim_Create(id, "length", AnimTween.Linear, length, - length, 8, 16 + pause + duration);
		}
	}
	
	MakeStabAlert(board.x - board.width, board.y - board.height, board.x - board.width + length, board.y + board.height, pause, snd_exclamation)
	Timer_Create(-1, "stabendsound", pause + 4, function() { audio_play_sound(snd_stab, 0, false) })
	return Bone;
}