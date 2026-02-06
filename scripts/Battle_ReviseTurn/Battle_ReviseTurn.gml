function Battle_ReviseTurn(Index, Turn = undefined){
	if !(instance_exists(battle)) return false;
	if (is_undefined(Turn)) {
		if (array_length(battle.TurnList) <= 0) return battle_turn;
		return battle.TurnList[Index].Instance;
	}
		
	var Inst = instance_create(0, 0, Turn);
	var NewStruct = {
		Time: 0,
		SoulX: 320,
		SoulY: 320,
		X: 320,
		Y: 320,
		Width: 70,
		Height: 65,
		ResetX: 320,
		ResetY: 320,
		ResetWidth: 283,
		ResetHeight: 65
	}
	NewStruct.Instance = Inst;
	battle.TurnList[Index] = NewStruct;
	return true;
}