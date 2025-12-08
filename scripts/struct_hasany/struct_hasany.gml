/// @func struct_hasany(_struct, _keys)
/// @desc 检查 struct 是否包含 keys 中任意一个键
/// @arg {struct} _struct
/// @arg {array<string>} _keys
/// @returns {bool}
function struct_hasany(_struct, _keys) {
    if (!is_struct(_struct) || !is_array(_keys)) return false;
    for (var _i = 0; _i < array_length(_keys); _i++) {
        if (struct_exists(_struct, _keys[_i])) return true;
    }
    return false;
}