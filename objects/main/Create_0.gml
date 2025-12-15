global.Path = {
	Lang: program_directory + "Language/",
	Config: program_directory + "Config/"
};

global.structure = new Structure();
global.structure.Register("Encounter", Encounter_Init);
global.structure.Register("Animation", Anim_Init);
global.structure.Register("Language", Lang_Init);
global.structure.Register("Camera", Camera_Init);
global.structure.Register("Shaker", Shaker_Init);
global.structure.Register("Player", Player_Init);
global.structure.Register("Queue", Queue_Init);
global.structure.Register("Timer", Timer_Init);
global.structure.Register("Input", Input_Init);
global.structure.Register("Buff", Buff_Init);

////时间
time = 0
mintime = 0
hortime = 0