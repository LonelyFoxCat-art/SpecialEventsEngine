function Battle_EndMenu(){
	if(Battle_ReviseState() == BATTLE.STATE.MENU){
		var Button = Battle_ReviseMenu();
		var Menu = Battle_ReviseChoiceMenu();
		
		Battle_ReviseMenu(-1);
		
		if(Button == BATTLE.MENU.ITEM) Item_InvokeEvent(Menu, "Use")

		if(instance_exists(battle_menu_fight)){
			with(battle_menu_fight) event_user(2);
		}
		
		if(Button == BATTLE.MENU.MERCY && Menu == 1){
			if(Battle_ReviseMenuFell() > 0){
				var value=irandom(100) + 10 * Battle_GetTurnCount();
				Battle_ReviseMenuFell(round(value / 100));
			}else{
				Battle_ReviseMenuFell(false);
			}
		}
		
		//调用事件
		Battle_CallEnemyEvent(5);
		
		if(Battle_GetEnemyCount() > 0){
			//逃跑
			if(Button == BATTLE.MENU.MERCY && Menu == 1){
				Battle_ReviseState(BATTLE.STATE.RESULT);
				Battle_ReviseStateNext(BATTLE.STATE.RESULT);
				instance_create_depth(0,0,0,battle_result_flee).image_blend = battle_soul.image_blend
			
				var EXP=battle.RewardExp;
				var GOLD=battle.RewardGold;
				var text="";
				if(GOLD==0&&EXP==0){
					text += "* 你逃跑了......"
				}else{
					text += "* 你赢了!&* 你获得了" + string(Exp) + "经验和" + string(Gold) + "金币.";
					Player_Invoke().Exp += Exp;
					Player_Invoke().Gold += Gold;
				}
				
				Battle_SetDialog(text, true);
			}else{
				Battle_GotoStateNext();	
			}
		}
		return true;
	}else{
		return false;
	}
}