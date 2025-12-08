/// @func array_intersect(a, b)
/// @desc 返回 a 和 b 的交集（共有元素）
/// @param {array} a
/// @param {array} b
/// @return {array} 交集数组（保留 a 中顺序，去重）
function array_intersect(a, b) {
    var _result = [];
    var _seen = ds_map_create();
    var _i = 0;
    while (_i < array_length(a)) {
        var _val = a[_i];
        if (!_seen[? string(_val)]) {
            var _j = 0;
            var _in_b = false;
            while (_j < array_length(b)) {
                if (_val == b[_j]) {
                    _in_b = true;
                    break;
                }
                _j++;
            }
            if (_in_b) {
                array_push(_result, _val);
                _seen[? string(_val)] = true;
            }
        }
        _i++;
    }
    ds_map_destroy(_seen);
    return _result;
}