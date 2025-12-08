/// @func struct_removepath(struct, path)
/// @desc 通过路径字符串删除嵌套键或数组元素
/// @arg {struct} struct - 根 struct
/// @arg {string} path - 如 "a.b[0].c"
/// @returns {bool} 成功返回 true
function struct_removepath(_struct, _path) {
    if (!is_struct(_struct)) return false;

    // 解析路径为 key 数组（支持 a.b[0].c → ["a", "b", 0, "c"]）
    var _parts = [];
    var _temp = "";
    var _i = 1;
    while (_i <= string_length(_path)) {
        var _ch = string_char_at(_path, _i);
        if (_ch == "." || _ch == "[" || _ch == "]") {
            if (_temp != "") _parts[| array_length(_parts)] = _temp;
            _temp = "";
            if (_ch == "[") {
                _i++;
                var _num_str = "";
                while (_i <= string_length(_path) && string_char_at(_path, _i) != "]") {
                    _num_str += string_char_at(_path, _i);
                    _i++;
                }
                if (string_digits(_num_str) == _num_str && _num_str != "") {
                    _parts[| array_length(_parts)] = real(_num_str);
                }
                _i++; // 跳过 ]
                continue;
            }
        } else {
            _temp += _ch;
        }
        _i++;
    }
    if (_temp != "") _parts[| array_length(_parts)] = _temp;

    if (array_length(_parts) == 0) return false;

    // 导航到倒数第二层
    var _current = _struct;
    for (var _j = 0; _j < array_length(_parts) - 1; _j++) {
        var _key = _parts[_j];
        if (is_struct(_current)) {
            if (!struct_exists(_current, _key)) return false;
            _current = _current[@ _key];
        } else if (is_array(_current)) {
            if (!is_real(_key) || _key < 0 || _key >= array_length(_current)) return false;
            _current = _current[_key];
        } else {
            return false;
        }
    }

    // 删除最后一级
    var _last = _parts[array_length(_parts) - 1];
    if (is_struct(_current)) {
        if (!struct_exists(_current, _last)) return false;
        struct_remove(_current, _last);
        return true;
    } else if (is_array(_current)) {
        if (!is_real(_last) || _last < 0 || _last >= array_length(_current)) return false;
        array_delete(_current, _last, 1);
        return true;
    }
    return false;
}