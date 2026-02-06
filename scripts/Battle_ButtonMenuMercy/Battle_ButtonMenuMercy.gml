function Battle_ButtonMenuMercy(){
	var Button = battle.ButtonList[Battle_ReviseChoiceButton()]
	
	if Input_IsPressed(KEY.UP) {
		Button.Index --
		audio_play_sound(snd_menu_switch,0,false);
	} else if Input_IsPressed(KEY.DOWN) {
		Button.Index ++
		audio_play_sound(snd_menu_switch,0,false);
	} else if Input_IsPressed(KEY.CONFIRM) {
		Battle_EndMenu()
		audio_play_sound(snd_menu_confirm,0,false);
	} else if Input_IsPressed(KEY.CANCEL) {
		Battle_ReviseMenu(BATTLE.MENU.BUTTON)
		audio_play_sound(snd_menu_cancel,0,false);
	}
	
	Button.Index = clamp_wrap(Button.Index, 0, Battle_ReviseMenuFell() + 1)
	battle_soul.x = lerp(battle_soul.x, battle_board.x-battle_board.width-5+40, 0.5)
	battle_soul.y = lerp(battle_soul.y, battle_board.y-battle_board.height-5+36+34*Button.Index, 0.5)
	battle_soul.image_angle = lerp(battle_soul.image_angle, 90, 0.5)
}