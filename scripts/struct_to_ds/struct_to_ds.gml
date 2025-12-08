/// @func struct_to_ds(_struct, _deep)
/// @desc 将 struct 转为 ds_map（可选深度转换）
/// @arg {struct} _struct
/// @arg {bool} _deep - 是否递归转换嵌套 struct/array
/// @returns {ds_map}
function struct_to_ds(_struct, _deep = false) {
    if (!is_struct(_struct)) return ds_map_create();

    var _map = ds_map_create();
    var _keys = struct_get_names(_struct);
    for (var _i = 0; _i < array_length(_keys); _i++) {
        var _k = _keys[_i];
        var _v = _struct[@ _k];

        if (_deep) {
            if (is_struct(_v)) {
                _v = struct_to_ds(_v, true);
            } else if (is_array(_v)) {
                // 转为 ds_list
                var _list = ds_list_create();
                for (var _j = 0; _j < array_length(_v); _j++) {
                    var _item = _v[_j];
                    if (is_struct(_item)) {
                        _item = struct_to_ds(_item, true);
                    }
                    ds_list_add(_list, _item);
                }
                _v = _list;
            }
        }

        ds_map_add(_map, _k, _v);
    }
    return _map;
}