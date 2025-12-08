/// @func phi(n)
/// @desc 计算欧拉函数 φ(n)：小于等于 n 且与 n 互质的正整数个数
/// @param n 正整数（n >= 1）
/// @returns φ(n)
function phi(n) {
    if (n <= 0) return 0;
    var result = n;
    var p = 2;
    var temp = n;
    while (p * p <= temp) {
        if (temp % p == 0) {
            while (temp % p == 0) {
                temp /= p;
            }
            result -= result / p;
        }
        p += 1;
    }
    if (temp > 1) {
        result -= result / temp;
    }
    return floor(result);
}