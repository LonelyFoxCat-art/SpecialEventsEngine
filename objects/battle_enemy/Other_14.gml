///@desc 菜单选项选择
if(Battle_ReviseChoiceMenu() = enemy_id){
	if(Battle_ReviseMenu() = BATTLE.MENU.FIGHTANIM){
		Anim_Create(id, "x", AnimTween.QUAD.OUT, x, 100, 30);
		Anim_Create(id, "x", AnimTween.QUAD.IN, x + 100, -100, 25, 60);
	}
		
	if(Battle_ReviseMenu() = BATTLE.MENU.FIGHTDAMAGE){
		b = instance_create(320, y - 200, battle_damage);
		b.damage = -1;
	}
}