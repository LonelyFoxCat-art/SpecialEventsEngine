function Battle_SetButton(Menu, Sprite, CallBack, X, Y, Condition = undefined){
	var ButtonLength = array_length(battle.ButtonList)
	var ButtonStruct = {
		Index: 0,
		Menu: Menu,
		CallBack: CallBack,
		Condition: Condition
	}
	var Instance = instance_create(X, Y, battle_button)
	Instance.sprite_index = Sprite
	Instance.ButtonId = ButtonLength
	
	array_push(battle.ButtonList, ButtonStruct)
	return true;
}