/// @func struct_setpath(struct, path, value)
/// @desc 通过路径字符串设置嵌套值，自动创建中间 struct/array
/// @param {struct} struct - 必须是 struct
/// @param {string} path - 如 "a.b[0].c"
/// @param {*} value
/// @returns {bool} 成功返回 true
function struct_setpath(_struct, _path, _value) {
    if (!is_struct(_struct)) return false;

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
                _i++;
                continue;
            }
        } else {
            _temp += _ch;
        }
        _i++;
    }
    if (_temp != "") _parts[| array_length(_parts)] = _temp;

    if (array_length(_parts) == 0) return false;

    var _current = _struct;
    for (var _j = 0; _j < array_length(_parts) - 1; _j++) {
        var _key = _parts[_j];
        var _next_key = _parts[_j + 1];

        if (is_struct(_current)) {
            if (!struct_exists(_current, _key)) {
                // 下一个若是数字 → 创建数组；否则创建 struct
                if (is_real(_next_key) && _next_key >= 0) {
                    _current[@ _key] = [];
                } else {
                    _current[@ _key] = {};
                }
            }
            _current = _current[@ _key];
        } else if (is_array(_current)) {
            if (!is_real(_key) || _key < 0) return false;
            if (_key >= array_length(_current)) {
                if (is_real(_next_key) && _next_key >= 0) {
                    array_resize(_current, _key + 1);
                    _current[_key] = [];
                } else {
                    array_resize(_current, _key + 1);
                    _current[_key] = {};
                }
            }
            _current = _current[_key];
        } else {
            return false;
        }
    }

    var _last_key = _parts[array_length(_parts) - 1];
    if (is_struct(_current)) {
        _current[@ _last_key] = _value;
        return true;
    } else if (is_array(_current)) {
        if (is_real(_last_key) && _last_key >= 0) {
            if (_last_key >= array_length(_current)) array_resize(_current, _last_key + 1);
            _current[_last_key] = _value;
            return true;
        }
    }
    return false;
}