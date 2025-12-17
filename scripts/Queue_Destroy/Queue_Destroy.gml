/// @func Queue_Destroy(Name)
/// @desc 销毁指定名称的队列，从队列管理系统中移除
/// @arg {string} Name - 要销毁的队列名称
/// @returns {bool} 销毁成功返回 true，队列不存在则返回 false

function Queue_Destroy(Name) {
    if (!Queue_IsExist(Name)) return false;
    var Queue = StorageData.Invoke("Queue");
    struct_remove(Queue.QueueList, Name);
    return true;
}