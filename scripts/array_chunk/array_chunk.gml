/// @func array_chunk(arr, size)
/// @desc 将数组按固定大小分块
/// @param {array} arr
/// @param {real} size - 每块大小（必须 > 0）
/// @return {array} 二维数组
function array_chunk(arr, size) {
    size = floor(max(1, size));
    var _result = [];
    var _i = 0;
    var _len = array_length(arr);
    while (_i < _len) {
        var _chunk = [];
        var _j = 0;
        while (_j < size && (_i + _j) < _len) {
            array_push(_chunk, arr[_i + _j]);
            _j++;
        }
        array_push(_result, _chunk);
        _i += size;
    }
    return _result;
}