/// @func array_every(arr, func)
/// @desc 检查是否所有元素都满足条件（func 返回 true）
/// @param {array} arr
/// @param {method} func - 接收 (value, index)
/// @return {bool}
function array_every(arr, func) {
    var _i = 0;
    while (_i < array_length(arr)) {
        if (!func(arr[_i], _i)) {
            return false;
        }
        _i++;
    }
    return true;
}