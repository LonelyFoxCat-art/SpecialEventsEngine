/// @func mod_inverse(a, m)
/// @desc 计算模逆元 x，使得 (a * x) % m == 1
/// @param a 整数，需满足 gcd(a, m) == 1
/// @param m 模数（正整数，m > 1）
/// @returns 模逆元 x ∈ [0, m-1]，若不存在则返回 -1
function mod_inverse(a, m) {
    a = a % m;
    if (a < 0) a += m;
    if (gcd(a, m) != 1) return -1; // 逆元不存在

    // 扩展欧几里得算法求解 ax + my = 1
    var m0 = m;
    var x0 = 0, x1 = 1;
    while (a > 1) {
        var q = a div m;
        var t = m;
        m = a % m;
        a = t;
        t = x0;
        x0 = x1 - q * x0;
        x1 = t;
    }
    if (x1 < 0) x1 += m0;
    return x1;
}