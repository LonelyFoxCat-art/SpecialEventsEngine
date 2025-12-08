/// @func miller_rabin(n)
/// @desc 使用 Miller-Rabin 算法确定性检测 n 是否为质数（适用于 n < 2^64）
/// @param n 待检测的正整数（n >= 2）
/// @returns true 若 n 为质数，false 若为合数
function miller_rabin(n) {
    if (n < 2) return false;
    if (n == 2 || n == 3) return true;
    if (n % 2 == 0) return false;

    // 将 n-1 写成 d * 2^s 的形式
    var d = n - 1;
    var s = 0;
    while (d % 2 == 0) {
        d /= 2;
        s += 1;
    }

    // 根据 n 的大小选择确定性基底（适用于 n < 2^64）
    var bases;
    if (n < 2047) {
        bases = [2];
    } else if (n < 1373653) {
        bases = [2, 3];
    } else if (n < 9080191) {
        bases = [31, 73];
    } else if (n < 25326001) {
        bases = [2, 3, 5];
    } else if (n < 3215031751) {
        bases = [2, 3, 5, 7];
    } else if (n < 1122004669633) {
        bases = [2, 13, 23, 1662803];
    } else if (n < 2152302898747) {
        bases = [2, 3, 5, 7, 11];
    } else if (n < 3474749660383) {
        bases = [2, 3, 5, 7, 11, 13];
    } else if (n < 341550071728321) {
        bases = [2, 3, 5, 7, 11, 13, 17];
    } else if (n < 3825123056546413051) {
        bases = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37];
    } else {
        show_debug_message("miller_rabin: n too large for deterministic test in GML");
        return false;
    }
    for (var i = 0; i < array_length(bases); i++) {
        var a = bases[i];
        if (a >= n) continue;

        var _x = power_mod(a, d, n);
        if (_x == 1 || _x == n - 1) {
            continue;
        }

        var composite = true;
        for (var r = 1; r < s; r++) {
            _x = power_mod(_x, 2, n);
            if (_x == n - 1) {
                composite = false;
                break;
            }
        }

        if (composite) {
            return false;
        }
    }

    return true;
}