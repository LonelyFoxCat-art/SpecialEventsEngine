function Player_GetAtkTotal(Player = 0){
	var PlayerData = Player_Invoke(Player)
	return PlayerData.Atk + PlayerData.Bonus.Atk
}