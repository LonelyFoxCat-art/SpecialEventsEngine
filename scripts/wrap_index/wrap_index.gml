/// @desc 安全循环索引（支持负数）
/// @param index 任意整数索引
/// @param length 数组长度（>0）
/// @returns [0, length-1] 的有效索引
function wrap_index(index, length) {
    if (length <= 0) return 0;
    index = index mod length;
    if (index < 0) index += length;
    return index;
}