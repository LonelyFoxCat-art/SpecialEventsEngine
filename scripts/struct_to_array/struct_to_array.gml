/// @func struct_to_array(_struct, _key_field, _val_field)
/// @desc 转为 [{key: k, value: v}, ...] 格式（字段名可自定义）
/// @arg {struct} _struct
/// @arg {string} _key_field
/// @arg {string} _val_field
/// @returns {array}
function struct_to_array(_struct, _key_field = "key", _val_field = "value") {
    if (!is_struct(_struct)) return [];
    var _keys = struct_get_names(_struct);
    var _arr = [];
    for (var _i = 0; _i < array_length(_keys); _i++) {
        var _item = {};
        _item[@ _key_field] = _keys[_i];
        _item[@ _val_field] = _struct[@ _keys[_i]];
        _arr[| _i] = _item;
    }
    return _arr;
}