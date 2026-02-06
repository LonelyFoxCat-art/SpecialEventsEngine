function Battle_EndTurn(){
	if(Battle_ReviseState() == BATTLE.STATE.INTURN){
		Battle_ReviseTurnNumber(Battle_ReviseTurnNumber() + 1);
		Battle_CallEnemyEvent(11)
		
		if(instance_exists(battle_turn)){
			with(battle_turn) event_user(3);
		}
	
		if(instance_exists(battle_bullet)){
			with(battle_bullet) event_user(1);
		}
		
		Battle_GotoStateNext();
		return true;
	}else{
		return false;
	}
}