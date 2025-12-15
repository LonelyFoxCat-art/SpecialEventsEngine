/// @description 菜单执行区域
if(menu_button_item > (0 - 1)){menu_button_item = 0 - 1}
//if(!instance_exists(ui_dialog)){
//	if(_menu = 0){
//		if(keyboard_check_pressed(vk_up)){if(menu_button > 0){menu_button --}audio_play_sound(snd_menu_switch,0,false);}
//		else if(keyboard_check_pressed(vk_down)){if(menu_button < (menu_num-1)){menu_button ++}audio_play_sound(snd_menu_switch,0,false);}
//		else if(keyboard_check_pressed(ord("C"))){instance_destroy()}
//		else if(keyboard_check_pressed(ord("Z")))
//		{
//			audio_play_sound(snd_menu_confirm,0,false);
//			switch(menu_button)
//			{
//				case 0:
//					if(Item_Number() > 0)
//					{
//						_menu = "ITEM"
//						menu_button_item = 0
//					}else{
//						_menu = 0
//					}
//				break;
//				case 1:
//					_menu = "STAT"
//				break;
//				case 2:
//					_menu = "CALL"
//				break;
//			}
//		}
//	}else if(_menu = "ITEM"){
//		if(keyboard_check_pressed(ord("X"))){_menu = 0}
//		if(keyboard_check_pressed(ord("Z"))){_menu = "ITEM_OPERATE";menu_button_operate=0;audio_play_sound(snd_menu_confirm,0,false);}
//		if(keyboard_check_pressed(vk_up)){if(menu_button_item > 0){menu_button_item --}audio_play_sound(snd_menu_switch,0,false);}
//		if(keyboard_check_pressed(vk_down)){if(menu_button_item < (0 - 1)){menu_button_item ++}audio_play_sound(snd_menu_switch,0,false);}
//	}else if(_menu = "ITEM_OPERATE"){
//		if(keyboard_check_pressed(ord("X"))){_menu = "ITEM"}
//		if(keyboard_check_pressed(ord("Z")))
//		{
//			audio_play_sound(snd_menu_confirm,0,false);
//			switch(menu_button_operate)
//			{
//				case 0: Item_CallEvent(Save_Get(GAME_TYPE.GAME,GAME.ITEM+menu_button_item),0,menu_button_item);break;
//				case 1: Item_CallEvent(Save_Get(GAME_TYPE.GAME,GAME.ITEM+menu_button_item),1,menu_button_item);break;
//				case 2: Item_CallEvent(Save_Get(GAME_TYPE.GAME,GAME.ITEM+menu_button_item),2,menu_button_item);break;
//			}
//			if(Item_Number() > 0)
//			{
//				_menu = "ITEM"
//			}else{
//				_menu = 0
//			}
//		}
//		if(keyboard_check_pressed(vk_left)){if(menu_button_operate > 0){menu_button_operate --}audio_play_sound(snd_menu_switch,0,false);}
//		if(keyboard_check_pressed(vk_right)){if(menu_button_operate < 2){menu_button_operate ++}audio_play_sound(snd_menu_switch,0,false);}
//	}else if(_menu = "STAT"){
//		if(keyboard_check_pressed(ord("X"))){_menu = 0;audio_play_sound(snd_menu_switch,0,false);}
//	}else if(_menu = "CALL"){
//		if(keyboard_check_pressed(ord("X"))){_menu = 0;audio_play_sound(snd_menu_switch,0,false);}
//	}
//}

