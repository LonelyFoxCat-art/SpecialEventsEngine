/// @func struct_from_ds(_map, _deep)
/// @desc 将 ds_map 转为 struct（可选深度还原）
/// @arg {ds_map} _map
/// @arg {bool} _deep - 是否递归还原嵌套 ds_map/ds_list
/// @returns {struct}
function struct_from_ds(_map, _deep = false) {
    if (!ds_exists(_map, ds_type_map)) return {};

    var _struct = {};
    var _keys = ds_map_keys_to_array(_map);
    for (var _i = 0; _i < array_length(_keys); _i++) {
        var _k = _keys[_i];
        var _v = ds_map_find_value(_map, _k);

        if (_deep) {
            if (ds_exists(_v, ds_type_map)) {
                _v = struct_from_ds(_v, true);
            } else if (ds_exists(_v, ds_type_list)) {
                var _arr = [];
                for (var _j = 0; _j < ds_list_size(_v); _j++) {
                    var _item = ds_list_find_value(_v, _j);
                    if (ds_exists(_item, ds_type_map)) {
                        _item = struct_from_ds(_item, true);
                    }
                    _arr[| _j] = _item;
                }
                _v = _arr;
            }
        }

        _struct[@ _k] = _v;
    }
    return _struct;
}