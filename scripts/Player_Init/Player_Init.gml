function Player_Init(){
	globalvar PLAYERMODE;
	
	PLAYERMODE = {
		NONE: "None",
		KR: "Kr"
	}
	
	return {
		Name: "Player",
		Mode: PLAYERMODE.NONE,
		Lv: 1,
		MaxHp: 20,
		Hp: 20,
		Kr: 0,
		
		Speed: 2,
		Inv: 40,
		Atk: 10,
		Def: 10,
		
		Weapon: undefined,
		Armor: undefined,
		
		Bonus: {
			Speed: 0,
			Inv: 0,
			Atk: 0,
			Def: 0
		},
		
		Inventory: {
			Item: [],
			Phone: []
		}		
	}
}