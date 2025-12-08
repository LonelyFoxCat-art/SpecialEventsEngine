/// @func array_slice(arr, start, end = -1)
/// @desc 提取子数组（类似 Python 切片），end 为 -1 表示到末尾
/// @param {array} arr
/// @param {real} start - 起始索引（支持负数）
/// @param {real} end - 结束索引（不含），默认 -1 表示末尾
/// @return {array}
function array_slice(arr, start, finish = -1) {
    var _len = array_length(arr);
    // 处理负索引
    if (start < 0) start = _len + start;
    if (finish == -1) finish = _len;
    else if (finish < 0) finish = _len + finish;
    // 边界修正
    start = max(0, min(start, _len));
    finish = max(start, min(finish, _len));
    
    var _result = [];
    var _i = start;
    while (_i < finish) {
        array_push(_result, arr[_i]);
        _i++;
    }
    return _result;
}