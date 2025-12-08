/// @func array_repeat(arr, times)
/// @desc 重复整个数组 times 次（如 [1,2] * 3 → [1,2,1,2,1,2]）
/// @param {array} arr
/// @param {real} times - 非负整数
/// @return {array}
function array_repeat(arr, times) {
    times = floor(max(0, times));
    var _result = [];
    var _t = 0;
    while (_t < times) {
        var _i = 0;
        while (_i < array_length(arr)) {
            array_push(_result, arr[_i]);
            _i++;
        }
        _t++;
    }
    return _result;
}