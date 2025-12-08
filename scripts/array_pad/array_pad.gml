/// @func array_pad(arr, length, fill_value = undefined, side = "end")
/// @desc 将数组填充或截断至指定长度
/// @param {array} arr - 原数组
/// @param {real} length - 目标长度（非负整数）
/// @param {any} fill_value - 用于填充的值，默认 undefined
/// @param {string} side - 填充方向："start"（开头）或 "end"（末尾），默认 "end"
/// @return {array} 新数组
function array_pad(arr, length, fill_value = undefined, side = "end") {
    var _current_len = array_length(arr);
    length = floor(max(0, length));
    
    // 若当前长度 ≥ 目标长度，直接截断
    if (_current_len >= length) {
        return array_slice(arr, 0, length);
    }
    
    var _pad_count = length - _current_len;
    var _padding = array_fill(fill_value, _pad_count);
    
    if (side == "start") {
        return array_concat(_padding, arr);
    } else { // 默认 "end"
        return array_concat(arr, _padding);
    }
}