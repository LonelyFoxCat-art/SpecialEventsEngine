/// @func struct_patch(_target, _patch)
/// @desc 仅更新 target 中已存在的键（不新增键）
/// @arg {struct} _target
/// @arg {struct} _patch
/// @returns {struct} 返回 _target
function struct_patch(_target, _patch) {
    if (!is_struct(_target) || !is_struct(_patch)) return _target;
    var _keys = struct_get_names(_patch);
    for (var _i = 0; _i < array_length(_keys); _i++) {
        var _k = _keys[_i];
        if (struct_exists(_target, _k)) {
            _target[@ _k] = _patch[@ _k];
        }
    }
    return _target;
}