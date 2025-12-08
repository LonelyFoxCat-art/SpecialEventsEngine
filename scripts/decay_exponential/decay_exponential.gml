/// @desc 指数衰减：从 start 衰减到 target，半衰期为 half_life
/// @param start 初始值
/// @param target 目标值
/// @param half_life 半衰期（时间单位）
/// @param elapsed 已过时间
/// @returns 当前值
function decay_exponential(start, target, half_life, elapsed) {
    if (half_life <= 0) return target;
    var decay_rate = ln(2) / half_life;
    return target + (start - target) * exp(-decay_rate * elapsed);
}