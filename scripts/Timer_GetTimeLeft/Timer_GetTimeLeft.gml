/// @func Timer_GetTimeLeft(Name, GroupName = -1)
/// @desc 获取指定计时器的剩余时间
/// @arg {string} Name - 计时器名称
/// @arg {string} GroupName - 计时器组名称，如果提供则在指定组中查找（默认 -1 表示全局查找）
/// @returns {real} 剩余时间（秒），无效时返回 -1
function Timer_GetTimeLeft(Name, GroupName = -1) {
	var Timer = StorageData.Invoke("Timer");
	var TimerDate = undefined;
	
	if (GroupName != -1) {
		if (!Timer_IsGroup(GroupName)) return -1;
		var Group = Timer.TimerList[$ GroupName];
		
		TimerDate = Group.Timers[$ Name];
	} else {
		if (Timer_IsGroup(Name)) return -1;
		TimerDate = Timer.TimerList[$ Name];
	}
	
	return max(0, TimerDate.MaxTime - TimerDate.Time);
}