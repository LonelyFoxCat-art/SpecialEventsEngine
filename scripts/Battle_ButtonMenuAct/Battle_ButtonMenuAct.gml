function Battle_ButtonMenuAct(){
	var Button = battle.ButtonList[Battle_ReviseChoiceMenu()]
	
	if Battle_ReviseMenu() == BATTLE.MENU.ENEMY {
		if Input_IsPressed(KEY.UP) {
			Button.Index --
			if (Button.Index < 0){
				Button.Index = Battle_GetEnemyCount() - 1
			}
			audio_play_sound(snd_menu_switch,0,false);
		}else if Input_IsPressed(KEY.DOWN) {
			Button.Index ++
			if (Button.Index > Battle_GetEnemyCount() - 1){
				Button.Index = 0
			}
			audio_play_sound(snd_menu_switch,0,false);
		}else if Input_IsPressed(KEY.CONFIRM) {
			Battle_ReviseMenu(BATTLE.MENU.ACT)
			audio_play_sound(snd_menu_confirm,0,false);
		}else if Input_IsPressed(KEY.CANCEL) {
			Battle_ReviseMenu(BATTLE.MENU.BUTTON)
			audio_play_sound(snd_menu_cancel,0,false);
		}
	
		battle_soul.x = lerp(battle_soul.x, battle_board.x-battle_board.width-5+40, 0.5)
		battle_soul.y = lerp(battle_soul.y, battle_board.y-battle_board.height-5+36+34*Button.Index, 0.5)
		battle_soul.image_angle = lerp(battle_soul.image_angle, 90, 0.5)
	}else if Battle_ReviseMenu() == BATTLE.MENU.ACT {
		var Number = Battle_ReviseEnemyActionNumber(Button.Index)
		if Input_IsPressed(KEY.UP) {
			Battle_ReviseEnemyActionNumber(Button.Index, Battle_ReviseEnemyActionNumber(Button.Index) - 1)
			audio_play_sound(snd_menu_switch,0,false);
		}else if  Input_IsPressed(KEY.DOWN) {
			Battle_ReviseEnemyActionNumber(Button.Index, Battle_ReviseEnemyActionNumber(Button.Index) + 1)
			audio_play_sound(snd_menu_switch,0,false);
		}else if Input_IsPressed(KEY.CONFIRM) {
			Battle_EndMenu()
			audio_play_sound(snd_menu_confirm,0,false);
		}else if Input_IsPressed(KEY.CANCEL) {
			Battle_ReviseMenu(BATTLE.MENU.ENEMY)
			audio_play_sound(snd_menu_cancel,0,false);
		}
		
		battle_soul.x = lerp(battle_soul.x, battle_board.x-battle_board.width-5+40, 0.5)
		battle_soul.y = lerp(battle_soul.y, battle_board.y, 0.5)
		battle_soul.image_angle = lerp(battle_soul.image_angle, 90, 0.5)
		Battle_ReviseEnemyActionNumber(Button.Index, clamp_wrap(Battle_ReviseEnemyActionNumber(Button.Index), 0, Battle_GetEnemyActionCount(Button.Index)))
	}
}