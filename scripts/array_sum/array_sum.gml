/// @func array_sum(arr)
/// @desc 求和（仅数值）
/// @param {array} arr
/// @return {real}
function array_sum(arr) {
    var _total = 0;
    var _i = 0;
    while (_i < array_length(arr)) {
        _total += arr[_i];
        _i++;
    }
    return _total;
}