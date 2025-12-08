/// @func Input_Init()
/// @desc 初始化输入系统，定义输入模式并返回初始输入状态结构
/// @returns {struct} 包含 KeyList（按键列表）和 Custom（自定义输入绑定）的初始输入状态

function Input_Init(){
	globalvar InputMode, KEY;

	InputMode = {
		ANY: "Any",
		ALL: "All"
	}
	KEY = {
		FULLSCREEN: "FullScreen",
		RESTART: "Restart",
		CONFIRM: "Confirm",
		CANCEL: "Cancel",
		UP: "Up",
		DOWN: "Down",
		LEFT: "Left",
		RIGHT: "Right"
	}
	
	return {
		KeyList: {},
		Custom: Input_Custom
	}
}