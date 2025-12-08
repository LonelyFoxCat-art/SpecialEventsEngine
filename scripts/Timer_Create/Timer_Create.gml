/// @func Timer_Create(Group, Name, Time, Func, Mode = TIMERMODE.NONE, LoopCount = 0)
/// @desc 创建一个计时器
/// @arg {struct} Group - 计时器组，如果为 undefined 则创建在全局计时器列表中
/// @arg {string} Name - 计时器的唯一名称
/// @arg {real} Time - 计时器的时间间隔或总时长
/// @arg {function} Func - 计时器触发时执行的回调函数
/// @arg {constant} Mode - 计时器模式（默认为 TIMERMODE.NONE）
/// @arg {int} LoopCount - 循环次数，0 表示无限循环
/// @returns {struct|bool} 创建成功返回计时器结构体，已存在同名计时器返回 false
function Timer_Create(Group, Name, Time, Func, Mode = TIMERMODE.NONE, LoopCount = 0){
	var Timer = global.structure.Invoke("Timer");
	var TimerStruct = {
		Type: "None",
		Pause: false,
		LoopMode: Mode,
		Time: 0,
		Count: 0,
		Callback: Func,
		MaxTime: Time,
		MaxCount: LoopCount,
	};
	
	if (Timer_IsExist(Name, Group)) return false;
	
	if (Group) {
		Group.Timers[$ Name] = TimerStruct;
	} else {
		Timer.TimerList[$ Name] = TimerStruct;
	}
	
	return TimerStruct;
}