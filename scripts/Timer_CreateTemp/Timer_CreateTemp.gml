function Timer_CreateTemp(Time, Func = undefined){
	var Timer = StorageData.Invoke("Timer");
	var TimerStruct = {
		Type: "Temp",
		Pause: false,
		LoopMode: TIMERMODE.NONE,
		Time: 0,
		Count: 0,
		Callback: Func,
		MaxTime: Time,
		MaxCount: 0,
	};
	
	array_push(Timer.TimerTempList, TimerStruct)
	
	return TimerStruct;
}