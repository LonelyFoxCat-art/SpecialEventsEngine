/// @func Queue_Peek(Name)
/// @desc 查看指定队列的下一个待处理任务（不移除）
/// @arg {string} Name - 队列名称
/// @returns {any} 返回队首（或队尾/优先级最高）的任务项；若队列不存在或为空，返回 undefined

function Queue_Peek(Name) {
    if (!Queue_IsExist(Name)) return undefined;
    var QueueDate = global.structure.Invoke("Queue").QueueList[$ Name];
    var Length = array_length(QueueDate.data);
    if (Length == 0) return undefined;
    
    switch (QueueDate.type) {
        case QueueType.LIFO:
            return QueueDate.data[Length - 1];
        case QueueType.PRIORITY:
            return QueueDate.data[0].value;
        default:
            return QueueDate.data[0];
    }
}