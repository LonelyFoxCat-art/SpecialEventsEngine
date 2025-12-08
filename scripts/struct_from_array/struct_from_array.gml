/// @func struct_from_array(_array, _key_field, _val_field)
/// @desc 从 [{key:k, value:v}, ...] 数组重建 struct
/// @arg {array} _array
/// @arg {string} _key_field
/// @arg {string} _val_field
/// @returns {struct}
function struct_from_array(_array, _key_field = "key", _val_field = "value") {
    if (!is_array(_array)) return {};
    var _result = {};
    for (var _i = 0; _i < array_length(_array); _i++) {
        var _item = _array[_i];
        if (is_struct(_item) && struct_exists(_item, _key_field) && struct_exists(_item, _val_field)) {
            _result[@ _item[@ _key_field]] = _item[@ _val_field];
        }
    }
    return _result;
}