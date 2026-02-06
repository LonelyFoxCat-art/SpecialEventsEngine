function Item_Custom(){
	ITEM = {
		LonelyFoxCat: {
			Id: "LonelyFoxCat",
			Name: "LFC",
			Describe: "是该引擎的作者",
			MaxStack: 1,
			Count: 1,
			Fn: {
				Use: function() {  },
				Check: function() { },
				Drop: function() { },
			}
		},
		ButterscotchPie: {
			Id: "Butterscotch Pie",
			Name: "Pie",
			Describe: "让你想起曾经的味道",
			MaxStack: 1,
			Count: 1,
			Fn: {
				Use: function() {
					var PlayerData = Player_Invoke();
					PlayerData.Hp = PlayerData.MaxHp;
					Battle_AddDialog("* 你吃了奶油糖果馅饼.{sleep 20}&* 您的HP回满了!");
					audio_play_sound(snd_item_heal, 0, false);
				},
				Check: function() { },
				Drop: function() { },
			}
		}
	}
}