function Player_GetDefTotal(Player = 0){
	var PlayerData = Player_Invoke(Player)
	return PlayerData.Def + PlayerData.Bonus.Def
}