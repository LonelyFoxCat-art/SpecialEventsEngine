/// @func struct_flatten(_struct, _prefix = "")
/// @desc 将 struct 展开为扁平对象：{ "key.subkey": value }
/// @param {struct} _struct
/// @param {string} _prefix - 可选前缀
/// @returns {struct} 扁平化后的键值对
function struct_flatten(_struct, _prefix = "") {
    var _result = {};
    if (!is_struct(_struct)) return _result;
    
    var _keys = struct_get_names(_struct);
    for (var _i = 0; _i < array_length(_keys); _i++) {
        var _key = _keys[_i];
        var _full_key = _prefix + _key;
        var _val = _struct[@ _key];
        
        if (is_struct(_val)) {
            var _nested = struct_flatten(_val, _full_key + ".");
            var _nested_keys = struct_get_names(_nested);
            for (var _j = 0; _j < array_length(_nested_keys); _j++) {
                var _nk = _nested_keys[_j];
                _result[@ _nk] = _nested[@ _nk];
            }
        } else if (is_array(_val)) {
            for (var _j = 0; _j < array_length(_val); _j++) {
                _result[@ _full_key + "[" + string(_j) + "]"] = _val[_j];
            }
        } else {
            _result[@ _full_key] = _val;
        }
    }
    return _result;
}