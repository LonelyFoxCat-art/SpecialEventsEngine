/// @func array_sample(arr, count = 1, replace = false)
/// @desc 从数组中随机抽取 count 个元素
/// @param {array} arr - 源数组（不能为空）
/// @param {real} count - 采样数量（非负整数，默认 1）
/// @param {bool} replace - 是否放回抽样（默认 false，即不放回）
/// @return {array} 采样结果（长度 ≤ min(count, arr.length)）
function array_sample(arr, count = 1, replace = false) {
    var _len = array_length(arr);
    if (_len == 0) return [];
    
    count = floor(max(0, count));
    if (count == 0) return [];
    
    var _result = [];
    
    if (replace) {
        // 放回抽样：允许重复
        var _i = 0;
        while (_i < count) {
            var _idx = irandom(_len - 1);
            array_push(_result, arr[_idx]);
            _i++;
        }
    } else {
        // 不放回抽样：先打乱再取前 count
        var _shuffled = array_shuffle(arr);
        var _take = min(count, _len);
        var _i = 0;
        while (_i < _take) {
            array_push(_result, _shuffled[_i]);
            _i++;
        }
    }
    return _result;
}