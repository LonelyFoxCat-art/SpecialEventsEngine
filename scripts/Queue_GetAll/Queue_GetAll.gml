/// @func Queue_GetAll(Name)
/// @desc 获取指定队列中所有当前存储的数据（返回副本）
/// @arg {string} Name - 队列名称
/// @returns {array} 队列数据的副本；若队列不存在，返回空数组

function Queue_GetAll(Name) {
    if (!Queue_IsExist(Name)) return [];
    var Queue = global.structure.Invoke("Queue");
    return array_slice(Queue.QueueList[$ Name].data, 0, array_length(Queue.QueueList[$ Name].data));
}