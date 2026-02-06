var STATUS = Battle_ReviseState();
var MENU = Battle_ReviseMenu();

if (STATUS == BATTLE.STATE.MENU && (MENU != BATTLE.MENU.FIGHTAIM && MENU != BATTLE.MENU.FIGHTANIM && MENU != BATTLE.MENU.FIGHTDAMAGE)){
    if (Battle_ReviseChoiceButton() == ButtonId){
        image_index = 1;
        if (MENU == BATTLE.MENU.BUTTON){
            battle_soul.x = lerp(battle_soul.x, x - 39, 0.5);
            battle_soul.y = lerp(battle_soul.y, y + 1, 0.5);
            battle_soul.image_angle = lerp(battle_soul.image_angle, 0, 0.5);
        }
    }else{
        image_index = 0;
    }
}else{
    image_index = 0;
}
