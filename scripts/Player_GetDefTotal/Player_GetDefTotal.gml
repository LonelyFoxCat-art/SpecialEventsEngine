function Player_GetDefTotal(){
	var PlayerData = Player_Invoke()
	return PlayerData.Def + PlayerData.Bonus.Def
}