/// @desc 平滑阻尼插值（类似 Unity Mathf.SmoothDamp）
/// @param current 当前值
/// @param target 目标值
/// @param current_velocity 当前速度（传引用数组 [@v]）
/// @param smooth_time 平滑时间（秒）
/// @param max_speed 最大速度（可选，-1 表示无限制）
/// @param delta_time 时间步长（通常为 delta_time）
/// @returns 新值
function smooth_damp(_current, _target, _current_velocity, _smooth_time, _max_speed = -1, _delta_time = delta_time) {
    var omega = 2 / _smooth_time;
    var _x = omega * _delta_time;
    var _exp = 1 / (1 + _x + 0.48 * _x * _x + 0.235 * _x * _x * _x);
    var change = _current - _target;
    var original_to = _target;

    // 限制最大速度
    var max_change = _max_speed * _smooth_time;
    if (_max_speed >= 0) {
        change = clamp(change, -max_change, max_change);
    }
    _target = _current - change;

    var temp = (_current_velocity[0] + omega * change) * _delta_time;
    _current_velocity[0] = (_current_velocity[0] - omega * temp) * _exp;
    var output = _target + (change + temp) * _exp;

    // 防止 overshoot
    if (original_to - _current > 0 == output > original_to) {
        output = original_to;
        _current_velocity[0] = (output - original_to) / _delta_time;
    }

    return output;
}