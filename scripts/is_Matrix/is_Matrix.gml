/// @func is_matrix3x2(matrix)
/// @desc 判断给定值是否为 Matrix3x2 类型的矩阵结构
/// @arg {any} matrix - 待检测的变量
/// @returns {bool} 是 Matrix3x2 矩阵返回 true，否则返回 false

function is_matrix3x2(matrix){
	if (matrix == undefined) return false;
    return (is_struct(matrix) && matrix.type == "Matrix3x2");
}

/// @func is_matrix4x4(matrix)
/// @desc 判断给定值是否为 Matrix4x4 类型的矩阵结构
/// @arg {any} matrix - 待检测的变量
/// @returns {bool} 是 Matrix4x4 矩阵返回 true，否则返回 false

function is_matrix4x4(matrix){
	if (matrix == undefined) return false;
    return (is_struct(matrix) && matrix.type == "Matrix4x4");
}

/// @func is_matrix(matrix)
/// @desc 判断给定值是否为任意支持的矩阵类型（Matrix3x2 或 Matrix4x4）
/// @arg {any} matrix - 待检测的变量
/// @returns {bool} 是有效矩阵类型返回 true，否则返回 false

function is_matrix(matrix){
	if (matrix == undefined) return false;
    return (is_matrix3x2(matrix) || is_matrix4x4(matrix));
}