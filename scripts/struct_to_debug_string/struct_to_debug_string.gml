/// @func struct_to_debug_string(_struct, _max_depth)
/// @desc 安全生成调试字符串（限制嵌套深度）
/// @arg {struct} _struct
/// @arg {int} _max_depth
/// @returns {string}
function struct_to_debug_string(_struct, _max_depth = 3) {
    function _repr(_val, _depth) {
        if (_depth <= 0) return "<...>";
        if (is_undefined(_val)) return "undefined";
        if (is_struct(_val)) {
            var _keys = struct_get_names(_val);
            if (array_length(_keys) == 0) return "{}";
            var _parts = [];
            for (var _i = 0; _i < min(5, array_length(_keys)); _i++) { // 最多显示5个键
                var _k = _keys[_i];
                _parts[| array_length(_parts)] = _k + ":" + _repr(_val[@ _k], _depth - 1);
            }
            if (array_length(_keys) > 5) _parts[| array_length(_parts)] = "...";
            return "{" + string_join(_parts, ", ") + "}";
        }
        if (is_array(_val)) {
            if (array_length(_val) == 0) return "[]";
            var _parts = [];
            for (var _i = 0; _i < min(5, array_length(_val)); _i++) {
                _parts[| array_length(_parts)] = _repr(_val[_i], _depth - 1);
            }
            if (array_length(_val) > 5) _parts[| array_length(_parts)] = "...";
            return "[" + string_join(_parts, ", ") + "]";
        }
        if (is_string(_val)) return "\"" + _val + "\"";
        return string(_val);
    }
    return _repr(_struct, _max_depth);
}