// === 菜单状态 ===
if (State == BATTLE.STATE.MENU) {
    if (Menu == BATTLE.MENU.BUTTON) {
        if (Input_IsPressed(KEY.LEFT)) {
            Battle_ReviseChoiceButton(-1);
            audio_play_sound(snd_menu_switch, false, false);
        } else if (Input_IsPressed(KEY.RIGHT)) {
            Battle_ReviseChoiceButton(1);
            audio_play_sound(snd_menu_switch, false, false);
        } else if (Input_IsPressed(KEY.CONFIRM)) {
            var Condition = ButtonList[Index].Condition;
            if (is_method(Condition) ? Condition() : true) {
                Battle_ReviseMenu(ButtonList[Index].Menu);
            }
            audio_play_sound(snd_menu_confirm, false, false);
        }
    } else {
        ButtonList[Index].CallBack(Index);
    }
}

// === 对话状态 ===
if (State == BATTLE.STATE.DIALOG) {
    if (!instance_exists(Dialog)) {
        if (Queue_Length("Dialog") > 0) {
            Battle_SetDialog(Queue_Dequeue("Dialog") + "{paused}{end}");
        } else {
            Battle_CallEnemyEvent(7);
            if (!instance_exists(battle_menu_fight)) {
				Battle_GotoStateNext();
            }
        }
    }
}

// === 回合准备状态 ===
if (State == BATTLE.STATE.TURNPREPARATION) {
    if (!Battle_IsBoardTransforming()) {
        Battle_CallEnemyEvent(9);
        if (instance_exists(battle_turn)) {
            with (battle_turn) event_user(1);
        }
        Battle_GotoStateNext();
    }
}

// === 战场重置状态 ===
if (State == BATTLE.STATE.BOARDRESETTING) {
    if (!Battle_IsBoardTransforming()) {
        Battle_CallEnemyEvent(13);
        if (instance_exists(battle_turn)) {
            with (battle_turn) event_user(3);
        }
        Battle_GotoStateNext();
    }
}

// === 结果状态 ===
if (State == BATTLE.STATE.RESULT) {
    if (!instance_exists(Dialog)) {

    }
}