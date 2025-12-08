function Player_GetLvDef(Lv, BaseDef = 10, DefIncrement = 1, Interval = 4, StartLv = 4) {
	if (Lv < StartLv) return BaseDef;
	
    var Increments = ceil((Lv - StartLv) / Interval);
	
    return BaseDef + Increments * DefIncrement;
}