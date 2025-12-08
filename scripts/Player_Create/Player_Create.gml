function Player_Create(Name, Config = {}){
	var PlayerData = global.structure.Invoke("Player");
	var PlayerList = PlayerData.PlayerList;
	var PlayerStruct = {
		Name: Name,
		Mode: PLAYERMODE.NONE,
		Lv: 1,
		MaxHp: 20,
		Hp: 20,
		
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
	};
	
	array_push(PlayerList, struct_merge(PlayerStruct, Config));
	
	return PlayerStruct;
}