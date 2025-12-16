/// @func is_vec2(vec)
/// @desc 判断给定值是否为 Vector2 类型的向量结构
/// @arg {any} vec - 待检测的变量
/// @returns {bool} 是 Vector2 向量返回 true，否则返回 false

function is_vec2(vec) {
    if (vec == undefined) return false;
    return (is_struct(vec) && vec.type == "Vector2");
}

/// @func is_vec3(vec)
/// @desc 判断给定值是否为 Vector3 类型的向量结构
/// @arg {any} vec - 待检测的变量
/// @returns {bool} 是 Vector3 向量返回 true，否则返回 false

function is_vec3(vec) {
    if (vec == undefined) return false;
    return (is_struct(vec) && vec.type == "Vector3");
}

/// @func is_vec4(vec)
/// @desc 判断给定值是否为 Vector4 类型的向量结构
/// @arg {any} vec - 待检测的变量
/// @returns {bool} 是 Vector4 向量返回 true，否则返回 false

function is_vec4(vec) {
    if (vec == undefined) return false;
    return (is_struct(vec) && vec.type == "Vector4");
}

/// @func is_vec(vec)
/// @desc 判断给定值是否为任意支持的向量类型（Vector2 / Vector3 / Vector4）
/// @arg {any} vec - 待检测的变量
/// @returns {bool} 是有效向量类型返回 true，否则返回 false

function is_vec(vec) {
    if (vec == undefined) return false;
    return (is_vec2(vec) || is_vec3(vec) || is_vec4(vec));
}