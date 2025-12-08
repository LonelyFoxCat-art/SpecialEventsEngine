/// @func is_prime_fast(n)
/// @desc 快速判断 n 是否为质数：小数用试除法，大数用确定性 Miller-Rabin
/// @param n 待检测的整数（建议 n >= 0）
/// @returns true 若 n 为质数，false 否则
function is_prime_fast(n) {
    // 处理小值和边界情况
    if (n < 2) return false;
    if (n == 2) return true;
    if (n % 2 == 0) return false;
    if (n < 9) return true; // 3,5,7
    if (n % 3 == 0) return false;

    // 小于 1e6：使用优化试除法（跳过 2 和 3 的倍数）
    if (n < 1000000) {
        var i = 5;
        var w = 2;
        while (i * i <= n) {
            if (n % i == 0) return false;
            i += w;
            w = 6 - w; // 轮换 2,4 → 检查 6k±1
        }
        return true;
    }

    // 大于等于 1e6：使用确定性 Miller-Rabin（适用于 n < 2^64）
    // GML 的 real 类型在 |n| <= 2^53 时为精确整数，安全上限设为 9e15
    if (n > 9007199254740991) { // 2^53
        show_debug_message("is_prime_fast: n exceeds GML integer precision (2^53)");
        return false;
    }

    return miller_rabin(n);
}