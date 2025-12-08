/// @func struct_create(_template)
/// @desc 从模板创建一个新的 struct（深拷贝基础值，浅拷贝嵌套 struct）
/// @param {struct} _template - 模板 struct
/// @returns {struct}
function struct_create(_template) {
    var _result = {};
    if (!is_struct(_template)) return _result;

    var _keys = struct_get_names(_template);
    for (var _i = 0; _i < array_length(_keys); _i++) {
        var _key = _keys[_i];
        var _val = _template[$ _key];
        if (is_struct(_val)) {
            // 可选：是否递归深拷贝？这里采用浅拷贝以保持性能
            _result[$ _key] = _val;
        } else if (is_array(_val)) {
            // 使用 array_slice 实现浅拷贝（符合你的偏好）
            _result[$ _key] = array_slice(_val, 0, array_length(_val));
        } else {
            _result[$ _key] = _val;
        }
    }
    return _result;
}