/// @desc 分段线性插值：给定关键点 [(x0,y0), (x1,y1), ...]，插值任意 x
/// @param x 输入值
/// @param keys_x 升序 x 坐标数组，如 [0, 10, 20]
/// @param keys_y 对应 y 值数组，如 [0, 50, 200]
/// @returns 插值结果（超出范围时 clamp）
function lerp_piecewise(_x, keys_x, keys_y) {
    var n = array_length(keys_x);
    if (n == 0) return 0;
    if (n == 1) return keys_y[0];

    if (_x <= keys_x[0]) return keys_y[0];
    if (_x >= keys_x[n-1]) return keys_y[n-1];

    // 二分查找区间
    var lo = 0, hi = n - 1;
    while (lo < hi - 1) {
        var mid = (lo + hi) >> 1;
        if (keys_x[mid] <= x) lo = mid;
        else hi = mid;
    }

    // 在 [lo, hi] 区间线性插值
    var t = (_x - keys_x[lo]) / (keys_x[hi] - keys_x[lo]);
    return lerp(keys_y[lo], keys_y[hi], t);
}