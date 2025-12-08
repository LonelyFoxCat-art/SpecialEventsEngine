/// @func random_sample(_array, _k)
/// @desc 从数组中无放回地随机抽取 k 个元素（k <= length）
/// @param {array} _array
/// @param {int} _k
/// @returns {array} 抽样结果
function random_sample(_array, _k) {
    var _n = array_length(_array);
    if (_k <= 0) return [];
    if (_k >= _n) return random_shuffle(_array);
    
    // 使用蓄水池抽样简化版（因 GML 无引用，直接复制）
    var _pool = _array;
    var _result = [];
    for (var _i = 0; _i < _k; _i++) {
        var _j = irandom(_n - _i - 1);
        _result[_i] = _pool[_j];
        _pool[_j] = _pool[_n - _i - 1]; // 覆盖已选元素
    }
    return _result;
}