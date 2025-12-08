/// @func Timer_Update(Timer)
/// @desc 更新所有计时器，包括普通计时器和计时器组中的子计时器
/// @arg {struct} Timer - 包含 TimerList 的计时器结构体

function Timer_Update(Timer){
	var names = struct_get_names(Timer.TimerList);
	for (var i = 0; i < array_length(names); i++) {
		var name = names[i];
		var item = Timer.TimerList[$ name];
		
		if (Timer_IsGroup(name)) {
			if (!item.Pause) {
				var group_timer_names = struct_get_names(item.Timers);
				for (var j = 0; j < array_length(group_timer_names); j++) {
					var timer_name = group_timer_names[j];
					var group_timer = item.Timers[$ timer_name];
					Timer_Process(group_timer, item.Timers, timer_name);
				}
			}
		} else {
			Timer_Process(item, Timer.TimerList, name);
		}
	}
}