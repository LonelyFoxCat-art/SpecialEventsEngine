/// @func array_flatten(arr)
/// @desc 深度扁平化数组（递归展开所有嵌套数组）
/// @param {array} arr - 输入数组
/// @return {array} 扁平化后的新数组
function array_flatten(arr) {
    var _result = [];
    var _i = 0;
    while (_i < array_length(arr)) {
        var _item = arr[_i];
        if (is_array(_item)) {
            var _flattened = array_flatten(_item);
            var _j = 0;
            while (_j < array_length(_flattened)) {
                array_push(_result, _flattened[_j]);
                _j++;
            }
        } else {
            array_push(_result, _item);
        }
        _i++;
    }
    return _result;
}