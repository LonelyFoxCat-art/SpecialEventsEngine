/// @func Queue_Dequeue(Name)
/// @desc 从指定队列中移除并返回一个元素，行为取决于队列类型
/// @arg {string} Name - 队列名称
/// @returns {any} 出队的元素；若队列不存在或为空，返回 undefined

function Queue_Dequeue(Name) {
    if (!Queue_IsExist(Name)) return undefined;
    
    var Queue = global.structure.Invoke("Queue");
    var QueueDate = Queue.QueueList[$ Name];
    var Length = array_length(QueueDate.data);
    
    if (Length == 0) return undefined;
    
    var result;
    
    switch (QueueDate.type) {
        case QueueType.DEFAULT:
        case QueueType.CIRCULAR:
        case QueueType.UNIQUE:
            result = QueueDate.data[0];
            QueueDate.data = array_delete(QueueDate.data, 0, 1);
            break;
            
        case QueueType.LIFO:
            result = QueueDate.data[Length - 1];
            QueueDate.data = array_delete(QueueDate.data, Length - 1, 1);
            break;
            
        case QueueType.PRIORITY:
            result = QueueDate.data[0].value;
            QueueDate.data = array_delete(QueueDate.data, 0, 1);
            break;
            
        default:
            return undefined;
    }
    
    return result;
}