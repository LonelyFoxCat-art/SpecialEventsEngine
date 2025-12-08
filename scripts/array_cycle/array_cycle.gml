/// @func array_cycle(arr, length)
/// @desc 将数组循环重复，生成指定长度的新数组（类似 itertools.cycle）
/// @param {array} arr - 源数组（若为空，返回空数组）
/// @param {real} length - 目标长度（非负整数）
/// @return {array}
function array_cycle(arr, length) {
    var _src_len = array_length(arr);
    length = floor(max(0, length));
    
    if (_src_len == 0 || length == 0) {
        return [];
    }
    
    var _result = [];
    var _i = 0;
    while (_i < length) {
        var _src_index = _i mod _src_len;
        array_push(_result, arr[_src_index]);
        _i++;
    }
    return _result;
}