/// @func struct_getpath(struct, path, default)
/// @desc 通过路径字符串安全读取嵌套 struct/array 值
/// @param {struct} struct
/// @param {string} path - 如 "a.b[0].c"
/// @param {*} default - 默认值
/// @returns {*}
function struct_getpath(_struct, _path, _default = undefined) {
    var _current = _struct;
    var _parts = [];

    // 解析路径：支持 a.b[0].c -> ["a", "b", 0, "c"]
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

    for (var _j = 0; _j < array_length(_parts); _j++) {
        var _key = _parts[_j];
        if (is_struct(_current)) {
            if (!struct_exists(_current, _key)) return _default;
            _current = _current[@ _key];
        } else if (is_array(_current)) {
            if (!is_real(_key) || _key < 0 || _key >= array_length(_current)) return _default;
            _current = _current[_key];
        } else {
            return _default;
        }
    }
    return _current;
}