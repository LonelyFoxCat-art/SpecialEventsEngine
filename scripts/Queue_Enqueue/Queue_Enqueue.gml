/// @func Queue_Enqueue(Name, value, priority = 0)
/// @desc 向指定队列中添加元素，支持多种队列类型（普通、循环、唯一、后进先出、优先级）
/// @arg {string} Name - 队列名称，必须已存在
/// @arg {any} value - 要入队的值
/// @arg {number} priority - 优先级（仅在优先级队列中使用，默认为 0）
/// @returns {bool} 入队成功返回 true，队列不存在、重复值（唯一队列）或不支持的类型返回 false

function Queue_Enqueue(Name, value, priority = 0) {
    if (!Queue_IsExist(Name)) return false;
    
    var Queue = StorageData.Invoke("Queue");
    var QueueDate = Queue.QueueList[$ Name];
    
    if (QueueDate.type == QueueType.UNIQUE) {
        for (var i = 0; i < array_length(QueueDate.data); i++) {
            if (QueueDate.data[i] == value) return false;
        }
    }
    
    switch (QueueDate.type) {
        case QueueType.DEFAULT:
        case QueueType.CIRCULAR:
        case QueueType.UNIQUE:
        case QueueType.LIFO:
            QueueDate.data = array_push(QueueDate.data, value);
            break;
            
        case QueueType.PRIORITY:
            var item = { value: value, priority: priority };
            var inserted = false;
            for (var i = 0; i < array_length(QueueDate.data); i++) {
                if (item.priority < QueueDate.data[i].priority) {
                    QueueDate.data = array_insert(QueueDate.data, i, item);
                    inserted = true;
                    break;
                }
            }
            if (!inserted) {
                QueueDate.data = array_push(QueueDate.data, item);
            }
            break;
            
        default:
            return false;
    }
    
    if (QueueDate.type == QueueType.CIRCULAR && array_length(QueueDate.data) > QueueDate.maxSize) {
        var start = array_length(QueueDate.data) - QueueDate.maxSize;
        QueueDate.data = array_slice(QueueDate.data, start, QueueDate.maxSize);
    }
    
    return true;
}