/// @func struct_invert(struct)
/// @desc 将 struct 的键和值互换（值必须可作为键）
/// @param {struct} struct
/// @returns {struct}
function struct_invert(_struct) {
    if (!is_struct(_struct)) return {};
    var _result = {};
    var _keys = struct_get_names(_struct);
    for (var _i = 0; _i < array_length(_keys); _i++) {
        var _k = _keys[_i];
        var _v = _struct[@ _k];
        if (is_string(_v) || is_real(_v) || is_int64(_v)) {
            _result[@ string(_v)] = _k;
        }
    }
    return _result;
}