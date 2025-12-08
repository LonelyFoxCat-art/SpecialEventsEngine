/// @func Encounter_Init()
/// @desc 初始化遭遇系统，定义遭遇类型并返回初始遭遇列表结构

function Encounter_Init(){
	globalvar ENCOUNTER, ENCOUNTERTYPE;
	
	ENCOUNTER = {
		MENUDIGLOG: "MenuDiglog",
		QUICK: "Quick",
		FELL: "Fell",
		SOUL: "Soul"
	}
	ENCOUNTERTYPE = {
		UNDERTALE: "Undertale",
		DELTARUNE: "Deltarune"
	}
	
	return {
		Encounter: 0,
		EncounterList: [ ],
		Custom: Encounter_Custom
	}
}