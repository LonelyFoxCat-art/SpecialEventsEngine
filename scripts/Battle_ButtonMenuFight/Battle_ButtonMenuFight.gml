function Battle_ButtonMenuFight(){
	var Button = battle.ButtonList[Battle_ReviseChoiceButton()]

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
			Battle_ReviseMenu(BATTLE.MENU.FIGHTAIM)
			audio_play_sound(snd_menu_confirm,0,false);
		}else if Input_IsPressed(KEY.CANCEL) {
			Battle_ReviseMenu(BATTLE.MENU.BUTTON)
			audio_play_sound(snd_menu_cancel,0,false);
		}
	
		battle_soul.x = lerp(battle_soul.x, battle_board.x-battle_board.width-5+40, 0.5)
		battle_soul.y = lerp(battle_soul.y, battle_board.y-battle_board.height-5+36+34*Button.Index, 0.5)
		battle_soul.image_angle = lerp(battle_soul.image_angle, 90, 0.5)
	} else if Battle_ReviseMenu() == BATTLE.MENU.FIGHTANIM {
		battle.AnimTime -= 1
		if (battle.AnimTime < 0) Battle_ReviseMenu(BATTLE.MENU.FIGHTDAMAGE)
	} else if Battle_ReviseMenu() == BATTLE.MENU.FIGHTDAMAGE {
		battle.DamageTime -= 1
		if (battle.DamageTime < 0) Battle_EndMenu()
	}
}