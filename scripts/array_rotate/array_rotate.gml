/// @func array_rotate(arr, steps = 1)
/// @desc 向左循环移位（steps 可为负，自动转为右移）
/// @param {array} arr
/// @param {real} steps
/// @return {array}
function array_rotate(arr, steps = 1) {
    var _len = array_length(arr);
	
    if (_len <= 1) return (arr);
    steps = steps mod _len;
    if (steps < 0) steps += _len;
    return array_concat(
        array_slice(arr, steps, _len),
        array_slice(arr, 0, steps)
    );
}