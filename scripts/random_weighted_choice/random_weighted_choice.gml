/// @func random_weighted_choice(_values, _weights)
/// @desc 根据权重从值数组中随机选择一个元素
/// @param {array} _values - 值列表
/// @param {array} _weights - 对应权重（非负数）
/// @returns {*} 选中的值
function random_weighted_choice(_values, _weights) {
    var _n = array_length(_values);
    if (_n == 0 || _n != array_length(_weights)) return undefined;
    
    var _total = 0;
    for (var _i = 0; _i < _n; _i++) {
        if (_weights[_i] < 0) return undefined;
        _total += _weights[_i];
    }
    if (_total <= 0) return undefined;
    
    var _r = random(_total);
    var _cum = 0;
    for (var _i = 0; _i < _n; _i++) {
        _cum += _weights[_i];
        if (_r < _cum) return _values[_i];
    }
    return _values[_n - 1]; // fallback
}