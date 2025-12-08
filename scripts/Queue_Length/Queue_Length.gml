/// @func Queue_Length(Name)
/// @desc 获取指定队列中任务项的数量
/// @arg {string} Name - 队列名称
/// @returns {int} 队列中任务数组的长度；若队列不存在则返回 0

function Queue_Length(Name){
	var Queue = global.structure.Invoke("Queue");
	if !Queue_IsExist(Name) return 0;
	return array_length(Queue.QueueList[$ Name].Date);
}