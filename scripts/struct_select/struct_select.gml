/// @func struct_select(_struct, _predicate)
/// @desc 返回所有满足 predicate(key, value) 的键名
/// @arg {struct} _struct
/// @arg {method} _predicate - (key, value) → bool
/// @returns {array<string>}
function struct_select(_struct, _predicate) {
    if (!is_struct(_struct) || !is_method(_predicate)) return [];
    var _keys = struct_get_names(_struct);
    var _selected = [];
    for (var _i = 0; _i < array_length(_keys); _i++) {
        var _k = _keys[_i];
        if (_predicate(_k, _struct[@ _k])) {
            _selected[| array_length(_selected)] = _k;
        }
    }
    return _selected;
}