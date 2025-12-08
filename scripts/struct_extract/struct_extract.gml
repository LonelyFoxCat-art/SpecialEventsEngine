/// @func struct_extract(_struct, _key, _default)
/// @desc 获取并移除 struct 中的键（类似 pop）
/// @arg {struct} _struct
/// @arg {string} _key
/// @arg {*} _default
/// @returns {*}
function struct_extract(_struct, _key, _default = undefined) {
    if (!is_struct(_struct)) return _default;
    if (!struct_exists(_struct, _key)) return _default;
    var _val = _struct[@ _key];
    struct_remove(_struct, _key);
    return _val;
}