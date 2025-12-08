/// @func Timer_PauseGroup(Name)
/// @desc 暂停指定计时器组
/// @arg {string} Name - 计时器组名称
/// @returns {bool} 操作成功返回 true，失败返回 false
function Timer_PauseGroup(Name) {
	var Timer = global.structure.Invoke("Timer");
	var Group = Timer.TimerList[$ Name];
	
	if (!Timer_IsGroup(Name)) return false;
	
	Group.Pause = true;
	
	return true;
}