/// @func struct_find(struct, value, strict)
/// @desc 根据值查找第一个匹配的键名
/// @param {struct} struct
/// @param {*} value
/// @param {bool} strict - 是否使用 === 比较（默认 true）
/// @returns {string or undefined}
function struct_find(_struct, _value, _strict = true) {
    if (!is_struct(_struct)) return undefined;
    var _keys = struct_get_names(_struct);
    for (var _i = 0; _i < array_length(_keys); _i++) {
        var _k = _keys[_i];
        var _v = _struct[@ _k];
        if (_strict ? (_v == _value) : (string(_v) == string(_value))) {
            return _k;
        }
    }
    return undefined;
}