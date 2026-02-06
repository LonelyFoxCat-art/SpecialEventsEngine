if (board_follow) {
	x += battle.board.x - battle.board.xprevious;
	y += battle.board.y - battle.board.yprevious;
}

if(inv > 0){
	inv -= 1;
	if(image_speed==0){
		image_speed=1/2;
		image_index=1;
	}
}else{
	if(image_speed!=0){
		image_speed=0;
		image_index=0;
	}
}

if (!is_undefined(OnSoul)) OnSoul(id);
