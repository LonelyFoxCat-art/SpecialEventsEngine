/// @desc 弹性限制（超出时反弹）
/// @param value 值
/// @param min 最小值
/// @param max 最大值
/// @returns 弹性限制后的值
function clamp_bounce(value, _min, _max) {
    var range = _max - _min;
    if (range <= 0) return _min;
    value = (value - _min) mod (2 * range);
    if (value > range) value = 2 * range - value;
    return _min + value;
}