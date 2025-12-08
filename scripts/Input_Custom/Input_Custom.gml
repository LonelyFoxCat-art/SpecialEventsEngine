/// @func Input_Custom()
/// @desc 自定义输入键位绑定，将游戏内逻辑按键映射到实际键盘按键

function Input_Custom(){
	Input_Register(KEY.FULLSCREEN, vk_f4)
	Input_Register(KEY.RESTART, vk_f2)
	Input_Register(KEY.CONFIRM, "Z")
	Input_Register(KEY.CANCEL, "X")
	Input_Register(KEY.UP, vk_up)
	Input_Register(KEY.DOWN, vk_down)
	Input_Register(KEY.LEFT, vk_left)
	Input_Register(KEY.RIGHT, vk_right)
}