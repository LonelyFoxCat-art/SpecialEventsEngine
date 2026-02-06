var location = GetCoordinates(87, 555, 4);
board = Battle_CreateBoardRect(320, 320, 283, 65);

// 设置战斗菜单按钮
Battle_SetButton(BATTLE.MENU.ENEMY, spr_button_fight,  Battle_ButtonMenuFight,  location[0], 453);
Battle_SetButton(BATTLE.MENU.ENEMY, spr_button_act,    Battle_ButtonMenuAct,    location[1], 453);
Battle_SetButton(BATTLE.MENU.ITEM,  spr_button_item,   Battle_ButtonMenuItem,   location[2], 453, function() { return Item_GetNumber() > 0; });
Battle_SetButton(BATTLE.MENU.MERCY, spr_button_mercy, Battle_ButtonMenuMercy, location[3], 453);

// 初始化战斗实体
instance_create(0, 0, battle_soul);
Battle_ReviseEnemy(0, enemy_ink);

// 进入下一状态
Battle_GotoStateNext();