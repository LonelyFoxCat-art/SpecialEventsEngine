/// @func struct_size(_struct)
/// @desc 返回 struct 的键数量
/// @param {struct} _struct
/// @returns {int}
function struct_size(_struct) {
    if (!is_struct(_struct)) return 0;
    return array_length(struct_get_names(_struct));
}