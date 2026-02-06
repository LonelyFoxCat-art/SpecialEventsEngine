function Battle_ReviseState(State = undefined){
	if !(instance_exists(battle)) return false;
	if (is_undefined(State)) return battle.State;
	
	battle.State = State;
	
	if(State == BATTLE.STATE.MENU){
		Battle_ReviseStateNext(BATTLE.STATE.DIALOG);
		Battle_ReviseMenu(BATTLE.MENU.BUTTON);
		
		Battle_CallEnemyEvent(2);
	}

	if(State == BATTLE.STATE.DIALOG){
		Battle_ReviseStateNext(BATTLE.STATE.TURNPREPARATION);
		Battle_CallEnemyEvent(6);
	}
	
	if(State == BATTLE.STATE.TURNPREPARATION){
		Battle_ReviseStateNext(BATTLE.STATE.INTURN);
		Battle_CallEnemyEvent(8);
	
		if(instance_exists(battle_turn)){
			with(battle_turn) event_user(0);
		}
		
		var Board = Battle_GetBoard(),
		X_Old = Board.x, Y_Old = Board.y,
		Wight_OLD = Board.width, Height_OLD = Board.height,
		NowX = Battle_GetTurnInfo("X", 320) - X_Old, NowY = Battle_GetTurnInfo("Y", 320) - Y_Old,
		NowWight = Battle_GetTurnInfo("Width", 70) - Wight_OLD, NowHeight = Battle_GetTurnInfo("Width", 65) - Height_OLD
			
		battle_soul.image_angle = 0
		battle_soul.x = Battle_GetTurnInfo("SoulX", 320)
		battle_soul.y = Battle_GetTurnInfo("SoulY", 320)
	
		Anim_Create(Board, "x", AnimTween.QUINT.OUT, X_Old, NowX, 30);
		Anim_Create(Board, "y", AnimTween.QUINT.OUT, Y_Old, NowY, 30);
		Anim_Create(Board, "width", AnimTween.QUINT.OUT, Wight_OLD, NowWight, 30);
		Anim_Create(Board, "height", AnimTween.QUINT.OUT, Height_OLD, NowHeight, 30);
	}
	
	if(State == BATTLE.STATE.INTURN){
		Battle_ReviseStateNext(BATTLE.STATE.BOARDRESETTING);
		Battle_CallEnemyEvent(10);
	
		if(instance_exists(battle_turn)){
			with(battle_turn) event_user(2);
		}
	}
	
	if(State == BATTLE.STATE.BOARDRESETTING){
		Battle_ReviseStateNext(BATTLE.STATE.MENU);
		
		var Board = Battle_GetBoard(),
		X_Old = Board.x, Y_Old = Board.y,
		Wight_OLD = Board.width, Height_OLD = Board.height,
		NowX = Battle_GetTurnInfo("ResetX", 320) - X_Old, NowY = Battle_GetTurnInfo("ResetY", 320) - Y_Old,
		NowWight = Battle_GetTurnInfo("ResetWidth", 283) - Wight_OLD, NowHeight = Battle_GetTurnInfo("ResetWidth", 65) - Height_OLD
	
		Anim_Create(Board, "x", AnimTween.QUINT.OUT, X_Old, NowX, 30);
		Anim_Create(Board, "y", AnimTween.QUINT.OUT, Y_Old, NowY, 30);
		Anim_Create(Board, "width", AnimTween.QUINT.OUT, Wight_OLD, NowWight, 30);
		Anim_Create(Board, "height", AnimTween.QUINT.OUT, Height_OLD, NowHeight, 30);
	
		Battle_CallEnemyEvent(12);
	}
	
	return true
}