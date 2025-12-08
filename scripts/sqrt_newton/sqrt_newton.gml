/// @desc 牛顿法求平方根
/// @param s 被开方数（>0）
/// @param [tolerance=1e-6] 精度
/// @returns √s 的近似值
function sqrt_newton(s, tolerance = 0.0000001) {
    if (s <= 0) return 0;
    var _x = s;
    while (true) {
        var x1 = 0.5 * (_x + s / _x);
        if (abs(x1 - _x) < tolerance) break;
        _x = x1;
    }
    return _x;
}