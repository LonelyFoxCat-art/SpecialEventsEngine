/// @func Queue_Create(Name, type, maxSize)
/// @desc 创建一个新队列并注册到队列管理系统中
/// @arg {string} Name - 队列的唯一名称
/// @arg {string} type - 队列类型，取值为 QUEUETYPE 中的常量（默认为 DEFAULT）
/// @arg {int} maxSize - 队列最大容量，仅对 CIRCULAR 类型有效；-1 表示无限制
/// @returns {bool} 创建成功返回 true，若名称已存在或 CIRCULAR 类型未指定有效 maxSize 则返回 false

function Queue_Create(Name, type = QUEUETYPE.DEFAULT, maxSize = -1) {
	if (type == QUEUETYPE.CIRCULAR && maxSize <= 0) return false;
    if (Queue_IsExist(Name)) return false;
    
    var Queue = StorageData.Invoke("Queue");
    
    Queue.QueueList[$ Name] = {
        type: type,
        maxSize: maxSize,
        data: []
    };
    
    return true;
}