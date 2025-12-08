/// @func Timer_ResumeGroup(Name)
/// @desc 恢复指定计时器组的运行状态，将组的暂停标志设为 false
/// @arg {string} Name - 计时器组的名称
/// @returns {bool} 操作成功返回 true，找不到组或参数错误返回 false
function Timer_ResumeGroup(Name) {
	var Timer = global.structure.Invoke("Timer");

	if (!Timer_IsGroup(Name)) return false;
	
	var Group = Timer.TimerList[$ Name];
	
	Group.Pause = false;
	
	return true;
}