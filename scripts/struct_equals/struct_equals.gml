/// @func struct_equals(_a, _b)
/// @desc 比较两个 struct 是否深度相等（支持嵌套）
/// @param {struct} _a
/// @param {struct} _b
/// @returns {bool}
function struct_equals(_a, _b) {
    if (_a == _b) return true;
    if (!is_struct(_a) || !is_struct(_b)) return false;
    
    var _keys_a = struct_get_names(_a);
    var _keys_b = struct_get_names(_b);
    if (array_length(_keys_a) != array_length(_keys_b)) return false;

    for (var _i = 0; _i < array_length(_keys_a); _i++) {
        var _key = _keys_a[_i];
        if (!struct_equals(_b, _key)) return false;
        
        var _val_a = _a[$ _key];
        var _val_b = _b[$ _key];
        
        if (is_struct(_val_a) && is_struct(_val_b)) {
            if (!struct_equals(_val_a, _val_b)) return false;
        } else if (is_array(_val_a) && is_array(_val_b)) {
            if (array_length(_val_a) != array_length(_val_b)) return false;
            for (var _j = 0; _j < array_length(_val_a); _j++) {
                if (!struct_equals(_val_a[_j], _val_b[_j])) return false;
            }
        } else if (_val_a != _val_b) {
            return false;
        }
    }
    return true;
}