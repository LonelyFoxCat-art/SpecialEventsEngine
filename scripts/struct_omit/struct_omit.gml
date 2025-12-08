/// @func struct_omit(struct, keys)
/// @desc 从 struct 中排除指定键，生成新 struct
/// @param {struct} struct
/// @param {array<string>} keys
/// @returns {struct}
function struct_omit(_struct, _keys) {
    if (!is_struct(_struct)) return {};
    var _result = variable_clone(_struct);
    if (!is_array(_keys)) return _result;
    for (var _i = 0; _i < array_length(_keys); _i++) {
        struct_remove(_result, _keys[_i]);
    }
    return _result;
}