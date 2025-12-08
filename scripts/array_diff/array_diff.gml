/// @func array_diff(a, b)
/// @desc 返回在 a 中但不在 b 中的元素（差集）
/// @param {array} a
/// @param {array} b
/// @return {array} 差集数组
function array_diff(a, b) {
    var _result = [];
    var _i = 0;
    while (_i < array_length(a)) {
        var _found = false;
        var _j = 0;
        while (_j < array_length(b)) {
            if (a[_i] == b[_j]) {
                _found = true;
                break;
            }
            _j++;
        }
        if (!_found) {
            array_push(_result, a[_i]);
        }
        _i++;
    }
    return _result;
}