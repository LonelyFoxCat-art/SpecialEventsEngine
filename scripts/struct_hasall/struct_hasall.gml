/// @func struct_hasall(_struct, _keys)
/// @desc 检查 struct 是否包含所有给定键
/// @arg {struct} _struct
/// @arg {array<string>} _keys
/// @returns {bool}
function struct_hasall(_struct, _keys) {
    if (!is_struct(_struct) || !is_array(_keys)) return false;
    for (var _i = 0; _i < array_length(_keys); _i++) {
        if (!struct_exists(_struct, _keys[_i])) return false;
    }
    return true;
}