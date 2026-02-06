function Player_GetInvTotal(){
	var PlayerData = Player_Invoke()
	return PlayerData.Inv + PlayerData.Bonus.Inv
}