/// @desc 生成正态分布随机数（均值=0，标准差=1）
/// @returns 标准正态分布的随机值
function random_normal() {
    var u1 = random(1);
    var u2 = random(1);
    while (u1 == 0) u1 = random(1); // 避免除零
    var mag = sqrt(-2 * ln(u1));
    var z0 = mag * dcos(2 * pi * u2);
    return z0;
}

/// @desc 生成指定均值和标准差的正态分布随机数
/// @param mean 均值
/// @param stddev 标准差（>0）
/// @returns 正态分布随机值
function random_normal_param(_mean, stddev) {
    return _mean + stddev * random_normal();
}