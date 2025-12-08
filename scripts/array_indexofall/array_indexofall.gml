/// @func array_indexofall(arr, value)
/// @desc 返回所有等于 value 的索引组成的数组
/// @param {array} arr
/// @param {any} value
/// @return {array}
function array_indexofall(arr, value) {
    var _result = [];
    var _i = 0;
    while (_i < array_length(arr)) {
        if (arr[_i] == value) {
            array_push(_result, _i);
        }
        _i++;
    }
    return _result;
}