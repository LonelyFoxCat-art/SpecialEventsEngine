/// @func random_choice(_array)
/// @desc 从数组中随机选择一个元素（非空数组）
/// @param {array} _array - 输入数组
/// @returns {*} 随机选中的元素
function random_choice(_array) {
    if (array_length(_array) == 0) return undefined;
    var _i = irandom(array_length(_array) - 1);
    return _array[_i];
}