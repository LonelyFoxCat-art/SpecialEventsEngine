/// @func gcd(a, b)
/// @desc 计算两个整数的最大公约数（Greatest Common Divisor）
/// @param a 非负整数
/// @param b 非负整数
/// @returns gcd(a, b)
function gcd(a, b) {
    a = abs(a);
    b = abs(b);
    while (b != 0) {
        var temp = b;
        b = a % b;
        a = temp;
    }
    return a;
}