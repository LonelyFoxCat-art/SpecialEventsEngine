/// @func Timer_GetDate(Name, GroupName = -1)
/// @desc 获取指定计时器的数据
/// @arg {string} Name - 要查找的计时器名称
/// @arg {string} GroupName - 计时器组名称，如果提供则在指定组中查找（默认 -1 表示全局查找）
/// @returns {struct|undefined} 找到返回计时器结构体，未找到返回 undefined
function Timer_GetDate(Name, GroupName = -1) {
	var Timer = StorageData.Invoke("Timer");
	
	if (GroupName != -1) {
		if (!Timer_IsGroup(GroupName)) return undefined;
		var GroupData = Timer.TimerList[$ GroupName];
		if (Timer_IsExist(Name, GroupName)) return GroupData.Timers[$ Name];
	} else {
		if (Timer_IsExist(Name)) return Timer.TimerList[$ Name];
	}
	
	return undefined;
}