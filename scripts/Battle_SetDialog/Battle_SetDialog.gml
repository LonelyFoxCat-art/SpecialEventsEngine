function Battle_SetDialog(TEXT = "", CHOICE = false, X = undefined, Y = undefined){
	if !(instance_exists(battle)) return false;
	if (is_undefined(X)) X = battle.board.x - battle.board.width - 5 + 28
	if (is_undefined(Y)) Y = battle.board.y - battle.board.height - 5 + 20
	
	//销毁原实例
	if (instance_exists(battle.Dialog)) {
		instance_destroy(battle.Dialog);
	}

	if (TEXT != "") {
		//创建实例
		if (CHOICE) {
			X += 40
		}
		battle.Dialog = instance_create(X, Y, text_typer);
	
		//更改文字
		var text_prefix="{sound 1}{scale 2}{speed 2}{gui false}{depth -1000}";
		if (CHOICE) {
			text_prefix+="{instant true}";
		}
		battle.Dialog.Auto = false
		battle.Dialog.text[0]=text_prefix+TEXT;
		return battle.Dialog;
	}else{
		return noone;
	}
}