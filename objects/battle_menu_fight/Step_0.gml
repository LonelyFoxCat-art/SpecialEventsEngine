if (_input_acceptable) {
    if ((_dir == 1 && _aim_x <= (battle_board.x - battle_board.width - (sprite_get_width(spr_battle_menu_fight_aim) / 2))) ||
        (_dir == 2 && _aim_x >= (battle_board.x + battle_board.width + (sprite_get_width(spr_battle_menu_fight_aim) / 2)))) {
        Battle_ReviseMenuFightDamageTime(-1);
        Battle_ReviseMenu(BATTLE.MENU.FIGHTANIM);
        _input_acceptable = false;
    }

    if (Input_IsPressed(KEY.CONFIRM) && _input_acceptable) {
        Anim_Remove(id, "_aim_x");
        var ATK = Player_GetAtkTotal();
        var DEF = Battle_ReviseEnemyDef(Battle_ReviseChoiceMenu());
        var DISTANCE = point_distance(x, y, _aim_x, y);
        var WIDTH = sprite_get_width(spr_battle_menu_fight_bg) / 2;
        var damage = (ATK - DEF) + random(2);

        if (DISTANCE <= 12) {
            damage *= 2.2;
        } else {
            damage *= ((1 - (DISTANCE / WIDTH)) * 2);
        }

        damage = round(damage);
        if (damage <= 0) damage = 1;

        Battle_ReviseMenuFightDamage(damage);
        Battle_ReviseMenuFightAnimTime(50);
        Battle_ReviseMenuFightDamageTime(45);
        alarm[0] = 5;
        Battle_ReviseMenu(BATTLE.MENU.FIGHTANIM);
        _input_acceptable = false;
    }
}