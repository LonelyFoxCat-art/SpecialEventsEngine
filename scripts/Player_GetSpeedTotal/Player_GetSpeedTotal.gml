function Player_GetSpeedTotal(Player = 0){
	var PlayerData = Player_Invoke(Player)
	return PlayerData.Speed + PlayerData.Bonus.Speed
}