/// @func array_replace(arr, old_value, new_value, all = true)
/// @desc 替换数组中的值
/// @param {array} arr
/// @param {any} old_value
/// @param {any} new_value
/// @param {bool} all - 是否替换所有匹配项（false 仅替换第一个）
/// @return {array}
function array_replace(arr, old_value, new_value, _all = true) {
    var _result = (arr);
    var _i = 0;
    while (_i < array_length(_result)) {
        if (_result[_i] == old_value) {
            _result[_i] = new_value;
            if (!_all) break;
        }
        _i++;
    }
    return _result;
}