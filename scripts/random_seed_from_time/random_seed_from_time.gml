/// @func random_seed_from_time()
/// @desc 使用当前时间作为种子（常用于初始化）
function random_seed_from_time() {
    random_set_seed(ceil(current_time * 1000) mod 999999999);
}