/// @func is_instance_valid(_id)
/// @desc 安全检查一个值是否为有效实例 ID
/// @param {_id} 任意值
/// @return {bool} 如果是有效实例返回 true，否则 false
function is_instance_valid(_id) {
    return (_id != noone) && instance_exists(_id);
}