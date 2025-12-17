/// @func Queue_IsExist(Name)
/// @desc 检查指定名称的任务队列是否存在
/// @arg {string} Name - 队列名称
/// @returns {bool} 存在返回 true，否则返回 false

function Queue_IsExist(Name){
	var QueueList = StorageData.Invoke("Queue").QueueList;
	return struct_exists(QueueList, Name);
}