var _text_ = "{cover true}{scale 2}{skippable true}{sound 0}{speed 2}{gui false}{instant true}";
var tx = (board.x - board.width - 5) + 28;
var ty = (board.y - board.height - 5) + 20;
var MenuIndex = ButtonList[Index].Index;
var text = "";

// === 敌人菜单 ===
if (Menu == BATTLE.MENU.ENEMY) {
    for (var i = 0; i < Battle_GetEnemyCount(); i++) {
        if (!instance_exists(array_index(TempText, i))) {
            TempText[i] = instance_create(tx + 40, ty + (34 * i), text_typer);
            
            if (Battle_HasEnemySpareable(MenuIndex)) text = "{color 255 0 255}";
            
            TempText[i].text[0] = _text_ + text + "* " + Battle_ReviseEnemyName(i);
        }
    }
}
// === 行动菜单（ACT） ===
else if (Menu == BATTLE.MENU.ACT) {
    var ActNumber = Battle_ReviseEnemyActionNumber(MenuIndex);
    TempButton[0] = lerp(TempButton[0], ActNumber, 0.15);
    
    for (var i = 0; i < Battle_GetEnemyActionCount(MenuIndex); i++) {
        if (!instance_exists(array_index(TempText, i))) {
            TempText[i] = instance_create(tx, board.y + (40 * i), text_typer);
            TempText[i].text[0] = _text_ + EnemyList[MenuIndex].Action[i].Name;
            TempText[i].x = tx + ((i == ActNumber) ? 40 : 0);
            TempText[i].image_alpha = (i == ActNumber) ? 1 : 0.2;
        } else {
            TempText[i].x = lerp(TempText[i].x, tx + ((i == ActNumber) ? 40 : 0), 0.15);
            TempText[i].y = ((board.y - 15) + (i * 40)) - (40 * TempButton[0]);
            TempText[i].image_alpha = lerp(TempText[i].image_alpha, (i == ActNumber) ? 1 : 0.2, 0.15);
        }
    }
}
// === 道具菜单 ===
else if (Menu == BATTLE.MENU.ITEM) {
    if (!instance_exists(DescribeInst)) {
        DescribeInst = instance_create(board.x, ty, text_typer);
        DescribeInst.text[0] = _text_ + Item_Revise(MenuIndex).Describe;
    } else {
        DescribeInst.text[0] = _text_ + Item_Revise(MenuIndex).Describe;
    }
    
    TempButton[1] = lerp(TempButton[1], MenuIndex, 0.15);
    
    for (var i = 0; i < Item_GetNumber(); i++) {
        var Item = Item_Revise(i);
        var Stackable = (Item.Count == 1) ? "" : (" x" + string_abbreviate(Item.Count));
        
        if (!instance_exists(array_index(TempText, i))) {
            TempText[i] = instance_create(tx, board.y + (40 * i), text_typer);
            TempText[i].text[0] = _text_ + Item.Name + Stackable;
            TempText[i].x = tx + ((i == MenuIndex) ? 40 : 0);
            TempText[i].image_alpha = (i == MenuIndex) ? 1 : 0.2;
        } else {
            TempText[i].text[0] = _text_ + Item.Name + Stackable;
            TempText[i].x = lerp(TempText[i].x, tx + ((i == MenuIndex) ? 40 : 0), 0.15);
            TempText[i].y = ((board.y - 15) + (i * 40)) - (40 * TempButton[1]);
            TempText[i].image_alpha = lerp(TempText[i].image_alpha, (i == MenuIndex) ? 1 : 0.2, 0.15);
        }
    }
}
// === 怜悯/逃跑菜单 ===
else if (Menu == BATTLE.MENU.MERCY) {
    if (!instance_exists(array_index(TempText, 0))) {
        TempText[0] = instance_create(tx + 40, ty, text_typer);
        
        for (var i = 0; i < Battle_GetEnemyCount(); i++) {
            if (Battle_HasEnemySpareable(i)) {
                text = "{color 255 0 255}";
            }
        }
        
        TempText[0].text[0] = _text_ + text + "* Mercy";
        
        if (!instance_exists(array_index(TempText, 1)) && Fell) {
            ty += 34;
            TempText[1] = instance_create(tx + 40, ty, text_typer);
            TempText[1].text[0] = _text_ + "* Flee";
        }
    }
}

// === 菜单切换清理 ===
if (Menu_Now != Menu) {
    for (var i = 0; i < array_length(TempText); i++) {
        if (instance_exists(array_index(TempText, i))) {
            instance_destroy(array_index(TempText, i));
        }
    }
    
    if (instance_exists(DescribeInst)) {
        instance_destroy(DescribeInst);
    }
    
    Menu_Now = Menu;
}