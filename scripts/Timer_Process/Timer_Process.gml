/// @func Timer_Process(timer, parent_struct = undefined, timer_name = undefined)
/// @desc 处理计时器的更新逻辑，增加时间并检查回调和循环模式
/// @arg {struct} timer - 计时器结构体
/// @arg {struct} parent_struct - 父级结构体，用于在计时器结束时移除（可选）
/// @arg {string} timer_name - 计时器在父结构体中的名称，用于移除操作（可选）
function Timer_Process(timer, parent_struct = undefined, timer_name = undefined) {
	if (timer.Pause) return;
	
	timer.Time += 1;
	
	if (timer.Time >= timer.MaxTime) {
		if (timer.Callback != undefined && is_method(timer.Callback)) timer.Callback();
		
		if (timer.LoopMode == TIMERMODE.LOOP) {
			timer.Time = 0;
		} else if (timer.LoopMode == TIMERMODE.FINITELOOP) {
			timer.Count++;
			if (timer.Count < timer.MaxCount) {
				timer.Time = 0;
			} else {
				if (parent_struct != undefined && timer_name != undefined) struct_remove(parent_struct, timer_name);
			}
		} else {
			if (parent_struct != undefined && timer_name != undefined) struct_remove(parent_struct, timer_name);
		}
	}
}