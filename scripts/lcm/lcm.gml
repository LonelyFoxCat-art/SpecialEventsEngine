/// @func lcm(a, b)
/// @desc 计算两个整数的最小公倍数（Least Common Multiple）
/// @param a 非零整数
/// @param b 非零整数
/// @returns lcm(a, b)
function lcm(a, b) {
    if (a == 0 || b == 0) return 0;
    return abs(a * b) / gcd(a, b);
}