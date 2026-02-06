function Battle_GetTurnInfo(Type, DefaultValue = 0){
	if (instance_exists(battle)) {
		if (array_length(battle.TurnList) > 0 && struct_exists(battle.TurnList[battle.Turn], Type)) return battle.TurnList[battle.Turn][$Type]
		return DefaultValue
	}
	return true
}