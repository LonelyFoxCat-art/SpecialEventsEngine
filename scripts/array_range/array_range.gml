/// @func array_range(start, end, step = 1)
/// @desc 生成数字范围数组（类似 Python range）
/// @param {real} start
/// @param {real} end（不含）
/// @param {real} step（默认 1）
/// @return {array}
function array_range(_start, _end, step = 1) {
    if (step == 0) {
        show_debug_message("array_range: step cannot be zero");
        return [];
    }
    var _result = [];
    var _current = _start;
    if (step > 0) {
        while (_current < _end) {
            array_push(_result, _current);
            _current += step;
        }
    } else {
        while (_current > _end) {
            array_push(_result, _current);
            _current += step;
        }
    }
    return _result;
}