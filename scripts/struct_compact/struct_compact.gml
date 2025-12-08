/// @func struct_compact(_struct)
/// @desc 移除 undefined / NaN / inf（保留 0, false, ""）
/// @arg {struct} _struct
/// @returns {struct}
function struct_compact(_struct) {
    if (!is_struct(_struct)) return {};
    var _result = {};
    var _keys = struct_get_names(_struct);
    for (var _i = 0; _i < array_length(_keys); _i++) {
        var _k = _keys[_i];
        var _v = _struct[@ _k];
        if (is_undefined(_v) && (is_string(_v) || is_bool(_v) || (is_real(_v) && is_finite(_v)))) {
            _result[@ _k] = _v;
        }
    }
    return _result;
}