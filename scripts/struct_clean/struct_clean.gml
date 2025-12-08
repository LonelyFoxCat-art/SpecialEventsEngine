/// @func struct_clean(struct, skip_empty)
/// @desc 移除无效值：undefined, NaN；若 _skip_empty=true 也移除 "", 0, false, []
/// @arg {struct} struct
/// @arg {bool} skip_empty - 是否移除“空值”
/// @returns {struct} 新 struct
function struct_clean(_struct, _skip_empty = false) {
    if (!is_struct(_struct)) return {};
    var _result = {};
    var _keys = struct_get_names(_struct);
    for (var _i = 0; _i < array_length(_keys); _i++) {
        var _k = _keys[_i];
        var _v = _struct[@ _k];
        var _is_invalid = is_undefined(_v) || (is_real(_v) && !is_finite(_v));
        var _is_empty = _skip_empty && ((_v == "") || (_v == 0) || (_v == false) || (is_array(_v) && array_is_empty(_v)) || (is_struct(_v) && struct_is_empty(_v))
        );
        if (!_is_invalid && !_is_empty) {
            _result[@ _k] = _v;
        }
    }
    return _result;
}