/// @func struct_unflatten(_flat_obj)
/// @desc 从扁平对象还原为嵌套 struct
/// @param {struct} _flat_obj - 如 { "player.name": "Wharang", "player.stats.hp": 100 }
/// @returns {struct}
function struct_unflatten(_flat_obj) {
    var _result = {};
    if (!is_struct(_flat_obj)) return _result;
    
    var _keys = struct_get_names(_flat_obj);
    for (var _i = 0; _i < array_length(_keys); _i++) {
        var _key = _keys[_i];
        var _val = _flat_obj[@ _key];
        var _parts = string_split(_key, ".");
        var _current = _result;
        
        for (var _j = 0; _j < array_length(_parts) - 1; _j++) {
            var _part = _parts[_j];
            // 处理数组索引：如 "arr[0]"
            if (string_pos("[", _part) > 0) {
                var _idx_start = string_pos("[", _part);
                var _idx_end = string_pos("]", _part);
                var _base = string_copy(_part, 1, _idx_start - 1);
                var _index = real(string_copy(_part, _idx_start + 1, _idx_end - _idx_start - 1));
                
                if (!_current[@ _base]) _current[@ _base] = [];
                if (array_length(_current[@ _base]) <= _index) {
                    array_resize(_current[@ _base], _index + 1);
                }
                _current = _current[@ _base];
                continue;
            }
            
            if (!_current[@ _part]) _current[@ _part] = {};
            _current = _current[@ _part];
        }
        
        var _last_part = _parts[array_length(_parts) - 1];
        if (string_pos("[", _last_part) > 0) {
            var _idx_start = string_pos("[", _last_part);
            var _idx_end = string_pos("]", _last_part);
            var _base = string_copy(_last_part, 1, _idx_start - 1);
            var _index = real(string_copy(_last_part, _idx_start + 1, _idx_end - _idx_start - 1));
            
            if (!_current[@ _base]) _current[@ _base] = [];
            if (array_length(_current[@ _base]) <= _index) {
                array_resize(_current[@ _base], _index + 1);
            }
            _current[@ _base][_index] = _val;
        } else {
            _current[@ _last_part] = _val;
        }
    }
    return _result;
}