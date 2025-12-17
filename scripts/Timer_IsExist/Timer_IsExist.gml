/// @func Timer_IsExist(Name, GroupName = -1)
/// @desc 检查指定计时器是否存在
/// @arg {string} Name - 计时器名称
/// @arg {string} GroupName - 计时器组名称，如果提供则只在指定组中查找（默认 -1 表示全局查找）
/// @returns {bool} 计时器存在返回 true，不存在返回 false
function Timer_IsExist(Name, GroupName = -1) {
	var Timer = StorageData.Invoke("Timer");
	
	if (GroupName != -1) {
		var Group = Timer.TimerList[$ GroupName];
		if (Group == undefined || !Timer_IsGroup(GroupName)) return false;
		
		return struct_exists(Group.Timers, Name);
	} else {
		if (struct_exists(Timer.TimerList, Name)) return !Timer_IsGroup(Name)
		
		var names = struct_get_names(Timer.TimerList);
		for (var i = 0; i < array_length(names); i++) {
			var item = Timer.TimerList[$ names[i]];
			if (Timer_IsGroup(names[i])) if (struct_exists(item.Timers, Name)) return true;
		}
	}
	
	return false;
}