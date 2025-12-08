/// @func array_compact(arr)
/// @desc 移除所有“假值”（undefined, 0, "", false, NaN 等在 GML 中视为 false 的值）
/// @desc 注意：GML 中只有 0、""、undefined、false 被视为假，NaN 实际为 real 且不等于自身
/// @param {array} arr
/// @return {array}
function array_compact(arr) {
    var _result = [];
    var _i = 0;
    while (_i < array_length(arr)) {
        var _val = arr[_i];
        // 在 GML 中，以下条件可判断“假值”
        if (!(_val == 0 || _val == "" || is_undefined(_val) || _val == false)) {
            array_push(_result, _val);
        }
        _i++;
    }
    return _result;
}