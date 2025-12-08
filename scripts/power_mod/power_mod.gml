/// @func power_mod(base, exponent, modulus)
/// @desc 快速模幂运算：计算 (base^exponent) % modulus
/// @param base 底数（整数）
/// @param exponent 指数（非负整数）
/// @param modulus 模数（正整数）
/// @returns (base^exponent) mod modulus
function power_mod(base, exponent, modulus) {
    if (modulus == 1) return 0;
    if (exponent < 0) {
        show_debug_message("power_mod: negative exponent not supported");
        return -1;
    }
    base = base % modulus;
    if (base < 0) base += modulus;
    var result = 1;
    while (exponent > 0) {
        if (exponent & 1) {
            result = (result * base) % modulus;
        }
        exponent = exponent >> 1;
        base = (base * base) % modulus;
    }
    return result;
}