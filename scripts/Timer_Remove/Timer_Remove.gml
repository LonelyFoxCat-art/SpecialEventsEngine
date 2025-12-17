/// @func Timer_Remove(Name, GroupName = -1)
/// @desc 从计时器列表中移除指定的计时器，支持从指定组中移除或从主列表中移除
/// @arg {string} Name - 要移除的计时器名称
/// @arg {string} GroupName - 可选，目标组的名称，若为 -1 则从主列表中移除
/// @returns {bool} 移除成功返回 true，未找到或组不存在返回 false
function Timer_Remove(Name, GroupName = -1) {
	var Timer = StorageData.Invoke("Timer");
	
	if (GroupName != -1) {
		if (!Timer_IsGroup(GroupName)) return false;
		var Group = Timer.TimerList[$ GroupName];
		
		if (Timer_IsExist(Name, GroupName)) {
			struct_remove(Group.Timers, Name);
			return true;
		}
	} else {
		if (Timer_IsExist(Name)) {
			var item = Timer.TimerList[$ Name];
			if (Timer_IsGroup(Name)) {
				var group_timer_names = struct_get_names(item.Timers);
				for (var i = 0; i < array_length(group_timer_names); i++) struct_remove(item.Timers, group_timer_names[i]);
			}

			struct_remove(Timer.TimerList, Name);
			return true;
		}
	}
	
	return false;
}