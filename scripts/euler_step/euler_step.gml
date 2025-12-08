/// @desc 欧拉积分一步（用于 dy/dt = f(t, y)）
/// @param y 当前值
/// @param dydt 导数（即 f(t, y)）
/// @param dt 时间步长
/// @returns 下一时刻的 y
function euler_step(_y, dydt, dt) {
    return _y + dydt * dt;
}