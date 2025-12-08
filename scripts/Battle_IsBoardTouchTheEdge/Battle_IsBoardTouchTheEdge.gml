function Battle_IsBoardTouchTheEdge(deviation = 0){
	var List = InstanceGetList(battle_board);
	var Number = array_length(List);
	var Top = false, Button = false, Left = false, Right = false;
	
	if Number <= 0 return false;
	
	for (var i = 0; i < Number; i++) {
		if (!Right && List[i].Contains(x - sprite_width/2 - (is_array(deviation) ? deviation[0] : deviation), y)) Right = true;
		if (!Left && List[i].Contains(x + sprite_width/2 + (is_array(deviation) ? deviation[1] : deviation), y)) Left = true;
		if (!Top && List[i].Contains(x, y - sprite_height/2 - (is_array(deviation) ? deviation[2] : deviation))) Top = true;
		if (!Button && List[i].Contains(x, y + sprite_height/2 + (is_array(deviation) ? deviation[3] : deviation))) Button = true;
	}
	
	return [Top, Button, Left, Right];
}