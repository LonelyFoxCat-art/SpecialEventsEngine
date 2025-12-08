function Player_GetInvTotal(Player = 0){
	var PlayerData = Player_Invoke(Player)
	return PlayerData.Inv + PlayerData.Bonus.Inv
}