function Player_GetSpeedTotal(){
	var PlayerData = Player_Invoke()
	return PlayerData.Speed + PlayerData.Bonus.Speed
}