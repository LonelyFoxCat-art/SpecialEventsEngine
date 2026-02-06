x = battle_board.x;
y = battle_board.y;
_dir = choose(1, 2);
_input_acceptable = true;
_aim_x = 0;
_aim_image = 0;

if (_dir == 1) {
    _aim_x = x + battle_board.width + (sprite_get_width(spr_battle_menu_fight_aim) / 2);
    Anim_Create(id, "_aim_x", AnimTween.Linear, _aim_x, (-battle_board.width * 2) - sprite_get_width(spr_battle_menu_fight_aim), 90);
} else {
    _aim_x = x - battle_board.width - (sprite_get_width(spr_battle_menu_fight_aim) / 2);
    Anim_Create(id, "_aim_x", AnimTween.Linear, _aim_x, (battle_board.width * 2) + sprite_get_width(spr_battle_menu_fight_aim), 90);
}