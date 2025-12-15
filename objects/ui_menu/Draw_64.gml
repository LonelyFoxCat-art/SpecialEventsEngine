/// @description 菜单绘制
menu_nowbutton += (menu_button-menu_nowbutton)*0.8
menu_button_nowitem += (menu_button_item-menu_button_nowitem)*0.8
menu_button_nowoperate += (menu_button_operate-menu_button_nowoperate)*0.8
menu_button_nowcall += (menu_button_call-menu_button_nowcall)*0.8
call_hight += (0-call_hight)*0.8
item_hight += (0-item_hight)*0.08
draw_set_halign(fa_left)
draw_set_color(c_white)
draw_rectangle(32,52,162,151,false)
draw_set_color(c_black)
draw_rectangle(37,57,157,146,false)

draw_set_color(c_white)
draw_rectangle(32,160,162,220+35*(menu_num-1),false)
draw_set_color(c_black)
draw_rectangle(37,165,157,215+35*(menu_num-1),false)

draw_set_color(c_white)
draw_rectangle(32,230+35*(menu_num-1),162,280+35*(menu_num-1),false)
draw_set_color(c_black)
draw_rectangle(37,235+35*(menu_num-1),157,275+35*(menu_num-1),false)
draw_set_color(c_white)

draw_text_transformed(42,240+35*(menu_num-1),string(main.hortime)+":"+string(main.mintime),2,2,0)
draw_set_color(c_white)

for(var i=0;i<menu_num;i++){
draw_text_transformed_color(75,175+35*i,_menu_name[i],2,2,0,color[i],color[i],color[i],color[i],1)
}
draw_set_font(font_add("Determination Mono.ttf", 10, false, false, 32, 128))
draw_text_transformed(42,62,"Player",2,2,0)
draw_text_transformed(42,92,"Lv "+string(1),1.5,1.5,0)
draw_text_transformed(42,110,"Hp "+string(20)+"/"+string(20),1.5,1.5,0)
draw_text_transformed(42,128,"G  "+string(0),1.5,1.5,0)

if(_menu = 0){
draw_sprite(spr_battle_soul,0,58,191+35*menu_nowbutton)
}
if(_menu = "ITEM" || _menu = "ITEM_OPERATE"){
draw_set_color(c_white)
draw_rectangle(182,52,539,105+35*(item_hight),false)
draw_set_color(c_black)
draw_rectangle(187,57,534,100+35*(item_hight),false)
draw_set_color(c_white)
}


if(_menu = "STAT"){
	draw_set_color(c_white)
	draw_rectangle(182,52,539,455,false)
	draw_set_color(c_black)
	draw_rectangle(187,57,534,450,false)
	
	draw_set_color(c_white)
	draw_text_transformed(210,70,"“"+Save_Get(GAME_TYPE.GAME,GAME.NAME)+"”",2,2,0)
	draw_text_transformed(210,120,"LV "+string(Save_Get(GAME_TYPE.GAME,GAME.LV)),2,2,0)
	draw_sprite_ext(spr_pixel,0,410,125,100,20,0,c_gray,1)
	draw_sprite_ext(spr_pixel,0,410,125,100/lv*Save_Get(GAME_TYPE.GAME,GAME.LV),20,0,c_aqua,1)
	draw_text_transformed(210,155,"HP "+string(Save_Get(GAME_TYPE.GAME,GAME.HP))+"/"+string(Save_Get(GAME_TYPE.GAME,GAME.HP_MAX)),2,2,0)
	draw_sprite_ext(spr_pixel,0,410,160,100,20,0,c_red,1)
	draw_sprite_ext(spr_pixel,0,410,160,100/Save_Get(GAME_TYPE.GAME,GAME.HP_MAX)*Save_Get(GAME_TYPE.GAME,GAME.HP),20,0,c_lime,1)
	draw_text_transformed(210,210,"AT "+string(Save_Get(GAME_TYPE.GAME,GAME.ATK))+"("+string(Save_Get(GAME_TYPE.GAME,GAME.ATK_ITEM))+")"+" DF "+string(Save_Get(GAME_TYPE.GAME,GAME.DEF))+"("+string(Save_Get(GAME_TYPE.GAME,GAME.DEF_ITEM))+")",2,2,0)
	draw_text_transformed(210,245,"EXP "+string(Save_Get(GAME_TYPE.GAME,GAME.EXP))+" / "+string(Save_Get(GAME_TYPE.GAME,GAME.EXP_MAX)),2,2,0)
	draw_sprite_ext(spr_pixel,0,210,280,300,20,0,c_gray,1)
	draw_sprite_ext(spr_pixel,0,210,280,300/Save_Get(GAME_TYPE.GAME,GAME.EXP_MAX)*Save_Get(GAME_TYPE.GAME,GAME.EXP),20,0,c_white,1)
	draw_text_transformed(210,320,"WEAPON:"+Item_GetName(Save_Get(GAME_TYPE.GAME,GAME.ITEM_WEAPON)),2,2,0)
	draw_text_transformed(210,355,"ARMOR:"+Item_GetName(Save_Get(GAME_TYPE.GAME,GAME.ITEM_ARMOR)),2,2,0)
	draw_text_transformed(210,400,"GOLD:"+string(Save_Get(GAME_TYPE.GAME,GAME.GOLD)),2,2,0)
}

if(_menu = "CALL"){
	draw_set_color(c_white)
	draw_rectangle(182,52,539,105+35*(call_hight),false)
	draw_set_color(c_black)
	draw_rectangle(187,57,534,100+35*(call_hight),false)
}

if(_menu = "ITEM"){
	draw_sprite(spr_soul_red,0,210,82+35*menu_button_nowitem)
}

if(_menu = "ITEM_OPERATE"){
	draw_sprite(spr_soul_red,0,210+115*menu_button_nowoperate,80+35*(Item_Number()))
}