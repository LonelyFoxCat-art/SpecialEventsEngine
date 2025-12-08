/// @func random_shuffle(_array)
/// @desc 返回一个打乱顺序的新数组（原数组不变）
/// @param {array} _array - 输入数组
/// @returns {array} 打乱后的新数组
function random_shuffle(_array) {
    var _len = array_length(_array);
    if (_len <= 1) return _array;
    var _result = _array;
    for (var _i = _len - 1; _i > 0; _i--) {
        var _j = irandom(_i);
        var _temp = _result[_i];
        _result[_i] = _result[_j];
        _result[_j] = _temp;
    }
    return _result;
}