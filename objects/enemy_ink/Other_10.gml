//audio_play_sound(snd_inksansbgm_1, 0, true)

Battle_ReviseMenuDialog("* 你迷失了...")

Battle_ReviseEnemyName(enemy_id, "Ink Sans")
Battle_ReviseEnemyAction(enemy_id, "查看")
Battle_ReviseEnemyAction(enemy_id, "调情")
Battle_ReviseEnemyAction(enemy_id, "微笑")
Battle_ReviseEnemyAction(enemy_id, "辱骂")

var PlayerData = Player_Invoke();
PlayerData.Name = "Chara";
PlayerData.Lv = 20;
PlayerData.MaxHp = 99
PlayerData.Hp = 99

Item_Add(ITEM.ButterscotchPie)