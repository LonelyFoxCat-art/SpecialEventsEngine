/// @func array_includes(arr, value)
/// @desc 判断数组是否包含某值
/// @param {array} arr
/// @param {any} value
/// @return {bool}
function array_includes(arr, value) {
    return array_find_index(arr, value) != -1;
}