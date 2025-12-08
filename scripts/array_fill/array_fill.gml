/// @func array_fill(value, count)
/// @desc 创建一个长度为 count、所有元素为 value 的数组
/// @param {any} value
/// @param {real} count - 必须为非负整数
/// @return {array}
function array_fill(value, count) {
    count = floor(max(0, count));
    var _result = [];
    var _i = 0;
    while (_i < count) {
        array_push(_result, value);
        _i++;
    }
    return _result;
}