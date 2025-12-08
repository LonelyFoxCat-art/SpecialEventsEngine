/// @func struct_map(struct, func)
/// @desc 对 struct 的每个值调用 _func(key, value)，返回新 struct
/// @param {struct} struct
/// @param {method} func - 接收 (key, value) 返回 newValue
/// @returns {struct}
function struct_map(_struct, _func) {
    if (!is_struct(_struct) || !is_method(_func)) return {};
    var _result = {};
    var _keys = struct_get_names(_struct);
    for (var _i = 0; _i < array_length(_keys); _i++) {
        var _k = _keys[_i];
        var _v = _struct[@ _k];
        _result[@ _k] = _func(_k, _v);
    }
    return _result;
}