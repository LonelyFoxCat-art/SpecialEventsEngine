/// @func array_some(arr, func)
/// @desc 检查是否存在至少一个元素满足条件
/// @param {array} arr
/// @param {method} func - 接收 (value, index)
/// @return {bool}
function array_some(arr, func) {
    var _i = 0;
    while (_i < array_length(arr)) {
        if (func(arr[_i], _i)) {
            return true;
        }
        _i++;
    }
    return false;
}