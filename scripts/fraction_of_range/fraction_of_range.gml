/// @desc 计算 value 在 [min_val, max_val] 中的比例（0~1）
/// @param value 当前值
/// @param min_val 最小值
/// @param max_val 最大值
/// @returns 比例 [0,1]（若 min==max，返回 0）
function fraction_of_range(value, min_val, max_val) {
    if (max_val <= min_val) return 0;
    return clamp((value - min_val) / (max_val - min_val), 0, 1);
}