/// @func Timer_CreateGroup(Name)
/// @desc 创建一个计时器组，用于管理多个相关计时器
/// @arg {string} Name - 计时器组的唯一名称
/// @returns {struct|bool} 创建成功返回计时器组结构体，已存在同名组返回 false
function Timer_CreateGroup(Name){
	var Timer = StorageData.Invoke("Timer");
	var TimerGroupStruct = {
		Type: "Group",
		Timers: {},
		Pause: false
	};
	
	if (Timer_IsGroup(Name)) return false;
	
	Timer.TimerList[$ Name] = TimerGroupStruct;
	return TimerGroupStruct;
}