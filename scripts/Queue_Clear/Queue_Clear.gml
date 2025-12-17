/// @func Queue_Clear(Name)
/// @desc 清空指定名称的队列中的所有数据
/// @arg {string} Name - 要清空的队列名称
/// @returns {bool} 清空成功返回 true，队列不存在则返回 false

function Queue_Clear(Name) {
    if (!Queue_IsExist(Name)) return false;
    var Queue = StorageData.Invoke("Queue");
    Queue.QueueList[$ Name].data = [];
    return true;
}