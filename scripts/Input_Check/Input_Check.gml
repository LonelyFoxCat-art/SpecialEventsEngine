/// @func Input_Check(keyInfo, checkFunc)
/// @desc 根据指定模式（任意键或全部键）检查一组按键是否满足条件
/// @arg {struct} keyInfo - 包含 keys（按键数组）和 mode（检查模式）的结构体
/// @arg {function} checkFunc - 用于检测单个按键是否满足条件的回调函数，应返回布尔值
/// @returns {bool} 满足条件时返回 true，否则返回 false

function Input_Check(keyInfo, checkFunc){
	var keys = keyInfo.keys;
    var mode = keyInfo.mode;
    var len = array_length(keys);
    
    if (mode == InputMode.ANY) {
        for (var i = 0; i < len; i++) {
            if (checkFunc(keys[i])) return true;
        }
        return false;
    } else if (mode == InputMode.ALL) {
        for (var i = 0; i < len; i++) {
            if (!checkFunc(keys[i])) return false;
        }
        return true;
    }
    
    return false;
}