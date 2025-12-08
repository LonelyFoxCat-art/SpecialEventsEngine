/// @func struct_merge(target, source)
/// @desc 深度合并 source 到 target（递归处理 struct）
/// @arg {struct} target
/// @arg {struct} source
/// @returns {struct} 新 struct
function struct_merge(_target, _source) {
    if (!is_struct(_target)) _target = {};
    if (!is_struct(_source)) return variable_clone(_target);
    
    var _result = variable_clone(_target);
    var _keys = struct_get_names(_source);
    for (var _i = 0; _i < array_length(_keys); _i++) {
        var _k = _keys[_i];
        var _src_val = _source[$ _k];
        if (is_struct(_src_val) && struct_exists(_result, _k) && is_struct(_result[$ _k])) {
            _result[$ _k] = struct_merge(_result[$ _k], _src_val);
        } else {
            _result[$ _k] = _src_val;
        }
    }
    return _result;
}