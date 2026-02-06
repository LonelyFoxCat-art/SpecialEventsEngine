function Player_Create(Name, Config = {}){
	var PlayerData = StorageData.Invoke("Player");
	var PlayerList = PlayerData.PlayerList;
	var PlayerStruct = {
		
	};
	
	array_push(PlayerList, struct_merge(PlayerStruct, Config));
	
	return PlayerStruct;
}