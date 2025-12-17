#macro PATH_LANG program_directory + "Language/"
#macro PATH_CONFIG program_directory + "Config/"

Store = Storage();
Store.Register("Encounter", Encounter_Init);
Store.Register("Animation", Anim_Init);
Store.Register("Language", Lang_Init);
Store.Register("Camera", Camera_Init);
Store.Register("Shaker", Shaker_Init);
Store.Register("Player", Player_Init);
Store.Register("Queue", Queue_Init);
Store.Register("Timer", Timer_Init);
Store.Register("Input", Input_Init);
Store.Register("Buff", Buff_Init);

////时间
time = 0
mintime = 0
hortime = 0