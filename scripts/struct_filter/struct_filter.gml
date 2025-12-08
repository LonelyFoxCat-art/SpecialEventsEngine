/// @func struct_filter(struct, func)
/// @desc 过滤 struct，保留满足条件的键值对
/// @param {struct} struct
/// @param {method} func - (key, value) → bool
/// @returns {struct}
function struct_filter(_struct, _func) {
    if (!is_struct(_struct) || !is_method(_func)) return {};
    var _result = {};
    var _keys = struct_get_names(_struct);
    for (var _i = 0; _i < array_length(_keys); _i++) {
        var _k = _keys[_i];
        var _v = _struct[@ _k];
        if (_func(_k, _v)) {
            _result[@ _k] = _v;
        }
    }
    return _result;
}