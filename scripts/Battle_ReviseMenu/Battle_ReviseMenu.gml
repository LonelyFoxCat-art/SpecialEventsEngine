function Battle_ReviseMenu(Menu = undefined, CALL = true){
	if !(instance_exists(battle)) return false;
	if (is_undefined(Menu)) return battle.Menu;
	
	battle.Menu = Menu;
	
	Battle_SetDialog();
		
	if(Menu == BATTLE.MENU.BUTTON){
		Battle_SetDialog(Battle_ReviseMenuDialog());
	}
	
	if (Menu == BATTLE.MENU.FIGHTAIM) {
		Battle_ReviseMenuFightAnimTime(0);
		Battle_ReviseMenuFightDamageTime(0);
		
		var obj	= battle_menu_fight;
		var defaultObj = battle_menu_fight;
		if(!object_exists(obj)) obj = defaultObj;
		if (!instance_exists(obj)) instance_create(0, 0, obj);
	}
	
	if(CALL){
		Battle_CallEnemyEvent(4);
	}
	
	if (Menu == BATTLE.MENU.FIGHTANIM) {
		if(instance_exists(battle_menu_fight)){
			with(battle_menu_fight) event_user(0);
		}
	}
		
	if (Menu == BATTLE.MENU.FIGHTDAMAGE) {
		if(instance_exists(battle_menu_fight)){
			with(battle_menu_fight) event_user(1);	
		}
	}
		
	return true
}