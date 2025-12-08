/// @desc 按权重随机选择一个索引
/// @param weights 数组，如 [10, 30, 60]
/// @returns 选中的索引（0-based）
function random_weighted(weights) {
    var total = 0;
    var len = array_length(weights);
    for (var i = 0; i < len; i++) {
        total += weights[i];
    }
    if (total <= 0) return 0;

    var r = random(total);
    var sum = 0;
    for (var i = 0; i < len; i++) {
        sum += weights[i];
        if (r < sum) return i;
    }
    return len - 1;
}