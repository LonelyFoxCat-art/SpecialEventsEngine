/// @func Queue_Init()
/// @desc 初始化队列系统，定义队列类型常量并返回初始队列管理结构
/// @returns {struct} 包含空队列表（QueueList）的结构体

function Queue_Init(){
	globalvar QueueType;
	
	QueueType = {
		DEFAULT:   "Default",     // FIFO，无限制
        CIRCULAR:  "Circular",    // FIFO，固定容量，自动覆盖最旧
        PRIORITY:  "Priority",    // 按优先级出队（数值越小优先级越高）
        LIFO:      "LIFO",        // 栈（后进先出）
        UNIQUE:    "Unique"       // 不允许重复元素（基于 == 比较）
	}
	
	return {
		QueueList: {}
	}
}