function Battle_ReviseTurnNumber(Turn){
	if !(instance_exists(battle)) return false
	if (is_undefined(Turn)) return battle.Turn
	
	battle.Turn = Turn
	return false
}