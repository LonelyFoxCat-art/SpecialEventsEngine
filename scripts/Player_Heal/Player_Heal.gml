function Player_Heal(Heal){
	var Player = Player_Invoke()
	
	if(Heal < 0){
		Player_Hurt(-Heal)
	}else{
		var HP = Player.Hp;
		var HP_MAX = Player.MaxHp;
		var KR = Player.Kr;
		if (Player.Mode == PLAYERMODE.KR){
			Player.Hp = ((HP + Heal) + KR <= HP_MAX ? (HP + Heal) : (HP_MAX - KR))
		} else {
			Player.Hp = min(Player.Hp + Heal, Player.MaxHp)
		}
	}
	return true;
}