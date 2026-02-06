function Player_Hurt(Damage){
	var Player = Player_Invoke();
	
	if(Damage < 0){
		Player_Heal(-Damage)
	}else{
		if (Player.Mode == PLAYERMODE.KR){
			if (Player.Hp > 1){
			    Player.Hp -= Damage
				Player.Kr += Damage
			} else if (Player.Hp == 1 && Player.Kr <= 0){
			    Player.Hp = 0
				Player.Kr = 0
			} else if (Player.Hp <= 0 && Player.Kr <= 0) {
				Player.Hp = max(Player.Hp - Damage, -999)
			} else {
				Player.Kr = max(Player.Kr - Damage, 0)
			}
		} else {
			Player.Hp = Player.Hp - Damage
		}
	}
	return true;
}