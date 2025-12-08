/// @func Timer_Resume(Name, GroupName = -1)
/// @desc 恢复指定计时器的运行状态，将暂停标志设为 false
/// @arg {string} Name - 计时器名称，或组内计时器的名称
/// @arg {string} GroupName - 组名称，若为 -1 则在全局计时器列表中查找
/// @returns {bool} 操作成功返回 true，找不到计时器或参数错误返回 false
function Timer_Resume(Name, GroupName = -1) {
	var Timer = global.structure.Invoke("Timer");
	
	if (GroupName != -1) {
		if (!Timer_IsGroup(GroupName)) return false;
		
		var Group = Timer.TimerList[$ GroupName];
		var timer = Group.Timers[$ Name];
		
		timer.Pause = false;
	} else {
		if (Timer_IsGroup(Name)) return false; 
		
		var timer = Timer.TimerList[$ Name];
		
		timer.Pause = false;
	}
	
	return true;
}