/// @func Timer_Pause(Name, GroupName = -1)
/// @desc 暂停指定计时器
/// @arg {string} Name - 计时器名称
/// @arg {string} GroupName - 计时器组名称，如果提供则在指定组中查找计时器（默认 -1 表示全局查找）
/// @returns {bool} 操作成功返回 true，失败返回 false
function Timer_Pause(Name, GroupName = -1){
	var Timer = StorageData.Invoke("Timer");
	
	if (GroupName != -1) {
		if (!Timer_IsGroup(GroupName)) return false;
		
		var Group = Timer.TimerList[$ GroupName];
		var timer = Group.Timers[$ Name];
		
		timer.Pause = true;
	} else {
		if (Timer_IsGroup(Name)) return false; 
		
		var timer = Timer.TimerList[$ Name];
		
		timer.Pause = true;
	}
	
	return true;
}