//if Player_IsBattle() {
//	var STATE=Battle_AlterState();
//	var MENU=Battle_AlterMenu();
//	if(STATE == BATTLE_STATE.INTURN || STATE == BATTLE_STATE.TURNPREPARATION || (STATE == BATTLE_STATE.MENU && MENU != BATTLE_MENU.FIGHTAIM && MENU != BATTLE_MENU.FIGHTANIM && MENU != BATTLE_MENU.FIGHTDAMAGE)){
//		draw_self();
//	}
//}else{
//	draw_self();
//}

draw_self()

draw_set_font(font_mono)
draw_text(0,0,"Move:"+string(move))

var s = false
for(var i = 0; i < array_length(global.BoardList); i ++) {
	if !global.BoardList[i].cover continue;
	if global.BoardList[i].Contains(x, y + sprite_height/2) s = true
}

if (s) draw_text(0, 20, "Board True");