/// @func Timer_RemoveGroup(Name)
/// @desc 移除指定的计时器组及其所有内部计时器
/// @arg {string} Name - 要移除的计时器组名称
/// @returns {bool} 成功移除返回 true，组不存在返回 false
function Timer_RemoveGroup(Name){
	var Timer = StorageData.Invoke("Timer");
	
	if (!Timer_IsGroup(Name)) return false;
	
	var Group = Timer.TimerList[$ Name];
	var group_timer_names = struct_get_names(Group.Timers);
	for (var i = 0; i < array_length(group_timer_names); i++) struct_remove(Group.Timers, group_timer_names[i]);
	
	struct_remove(Timer.TimerList, Name);
	return true;
}