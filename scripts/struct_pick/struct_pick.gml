/// @func struct_pick(struct, keys)
/// @desc 从 struct 中提取指定键，生成新 struct
/// @param {struct} struct
/// @param {array<string>} keys
/// @returns {struct}
function struct_pick(_struct, _keys) {
    if (!is_struct(_struct) || !is_array(_keys)) return {};
    var _result = {};
    for (var _i = 0; _i < array_length(_keys); _i++) {
        var _k = _keys[_i];
        if (struct_exists(_struct, _k)) {
            _result[@ _k] = _struct[@ _k];
        }
    }
    return _result;
}