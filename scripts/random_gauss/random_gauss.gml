/// @func random_gauss(_mean = 0, _stddev = 1)
/// @desc 生成符合高斯（正态）分布的随机数
/// @param {real} _mean     - 期望值（默认 0）
/// @param {real} _stddev   - 标准差（默认 1，必须 > 0）
/// @returns {real} 高斯分布随机数
function random_gauss(_mean = 0, _stddev = 1) {
	var _random_gauss_cached = undefined;
	var _random_gauss_has_cache = false;
	
    if (_stddev <= 0) _stddev = 1;
    
    if (_random_gauss_has_cache) {
        _random_gauss_has_cache = false;
        return _mean + _stddev * _random_gauss_cached;
    }
    
    var _u1, _u2;
    do {
        _u1 = random(1);
        _u2 = random(1);
    } until (_u1 > 0);
    
    var _z0 = sqrt(-2 * ln(_u1)) * cos(2 * pi * _u2);
    var _z1 = sqrt(-2 * ln(_u1)) * sin(2 * pi * _u2);
    
    _random_gauss_cached = _z1;
    _random_gauss_has_cache = true;
    
    return _mean + _stddev * _z0;
}