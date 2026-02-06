function Player_GetAtkTotal(){
	var PlayerData = Player_Invoke()
	return PlayerData.Atk + PlayerData.Bonus.Atk
}