/// @func Timer_IsGroup(Name)
/// @desc 检查指定名称是否为计时器组
/// @arg {string} Name - 计时器或计时器组的名称
/// @returns {bool} 是计时器组返回 true，否则返回 false
function Timer_IsGroup(Name) {
	var Timer = StorageData.Invoke("Timer");
	var item = Timer.TimerList[$ Name];
	
	if (item == undefined) return false;
	
	return item.Type == "Group";
}