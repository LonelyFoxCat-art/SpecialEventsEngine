/// @func Timer_GetProgress(Name, GroupName = -1)
/// @desc 获取指定计时器的进度百分比
/// @arg {string} Name - 计时器名称
/// @arg {string} GroupName - 计时器组名称，如果提供则在指定组中查找（默认 -1 表示全局查找）
/// @returns {real} 计时器进度，范围 0.0 到 1.0，无效时返回 -1
function Timer_GetProgress(Name, GroupName = -1) {
	var Timer = global.structure.Invoke("Timer");
	var TimerDate = undefined;
	
	if (GroupName != -1) {
		if (!Timer_IsGroup(GroupName)) return -1;
		var Group = Timer.TimerList[$ GroupName];
		
		TimerDate = Group.Timers[$ Name];
	} else {
		if (Timer_IsGroup(Name)) return -1;
		TimerDate = Timer.TimerList[$ Name];
	}
	
	return clamp(TimerDate.Time / TimerDate.MaxTime, 0, 1);
}