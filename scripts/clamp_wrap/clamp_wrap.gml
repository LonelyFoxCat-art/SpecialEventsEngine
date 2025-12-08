/// @desc 循环限制（超出范围则回绕）
/// @param value 值
/// @param min 最小值
/// @param max 最大值
/// @returns 回绕后的值
function clamp_wrap(value, _min, _max) {
    var range = _max - _min;
    if (range <= 0) return _min;
    value = (value - _min) mod range;
    if (value < 0) value += range;
    return _min + value;
}