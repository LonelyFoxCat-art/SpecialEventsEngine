X = 32;
Y = 401;
Sprite = noone;

drawUI = function() {
    var Player = Player_Invoke();
    var Max   = Player.MaxHp;
    var Now   = Player.Hp;
    var Color = c_white;
    var MaxWidth = min(124, Max * 1.25);
    var HpWidth  = max(0, (MaxWidth / Max) * Now);
    var HpPos    = X + 245;
    
    draw_set_font(font_mars_needs_cunnilingus);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_text(X, Y, Player.Name + "   LV " + string(Player.Lv));
    draw_sprite(spr_battle_ui_hp, 0, X + 214, Y + 4);
    draw_sprite_ext(spr_pixel, 0, HpPos, Y - 1, MaxWidth, 20, 0, c_red, 1);

    var state_x = 0;
    if (sprite_exists(Sprite)) state_x = sprite_get_width(Sprite);

    if (Player.Mode == PLAYERMODE.KR) {
        var Kr = (MaxWidth / Max) * Player.Kr;
        Now += Player.Kr;
        Color = (Player.Kr <= 0) ? c_white : make_color_rgb(255, 0, 255); // fuchsia

        draw_sprite_ext(spr_pixel, 0, HpPos, Y - 1, HpWidth, 20, 0, c_yellow, 1);
        draw_sprite_ext(spr_pixel, 0, HpPos + HpWidth, Y - 1, Kr, 20, 0, c_fuchsia, 1);

        if (sprite_exists(Sprite)) draw_sprite_ext(Sprite, 0, HpPos + MaxWidth + 10, Y + 4, 1, 1, 0, c_white, 1);
    } else {
        draw_sprite_ext(spr_pixel, 0, HpPos, Y - 1, HpWidth, 20, 0, c_yellow, 1);
    }

    draw_text_color(HpPos + MaxWidth + (state_x * 1.8) + 10, Y, string(Now) + " / " + string(Max), Color, Color, Color, Color, 1);
};