if (Battle_ReviseChoiceButton() == 1) {
	switch (Battle_ReviseEnemyActionNumber(enemy_id)) {
		case 0: Battle_AddDialog("* Ink Sans - ATK ? DEF ?{sleep 20}&* 在你屠戮完所有多元宇宙之后的最后的敌人.{sleep 20}&* 他发誓定要清算你的罪恶.") break;
		case 1: Battle_AddDialog("* 你摆出了性感的姿势{sleep 30}.{sleep 30}.{sleep 30}.{sleep 60}&* Ink没有反应.{sleep 20}&* Ink都不想理你.") break;
		case 2: Battle_AddDialog("* 你笑起来像个杀人犯.{sleep 20}&* 你的攻击增加了!") break;
		case 3: Battle_AddDialog("* 你说Ink是个愚蠢的孤儿.{sleep 20}&* Ink的防御降低!") break;
	}
}