if (instance_exists(battle)) {
    var STATE = Battle_ReviseState();
    var MENU = Battle_ReviseMenu();
    
    if (STATE == BATTLE.STATE.INTURN || STATE == BATTLE.STATE.TURNPREPARATION || (STATE == BATTLE.STATE.MENU && MENU != BATTLE.MENU.FIGHTAIM && MENU != BATTLE.MENU.FIGHTANIM && MENU != BATTLE.MENU.FIGHTDAMAGE)) draw_self();
} else {
    draw_self();
}
