/// @function                  variable_exists(type, name)
/// @param      {any}          type        - 要检查的变量容器类型（结构体/数组/实例/全局域）
/// @param      {string}       name        - 要检查的变量名称
/// @returns    {bool}                     - 返回变量是否存在
/// @description               通用变量存在检查函数，自动识别容器类型进行检查
/// @warning                   对于数组只检查长度是否>0，不检查特定索引是否存在
function variable_exists(type, name){
	var Bool = false
	if (is_struct(type)) {
		Bool = struct_exists(type, name)
	} else if (is_array(type)) {
		Bool = array_length(type) > 0
	} else if (instance_exists(type)) {
		Bool = variable_instance_exists(type, name)
	} else if (type == global) {
		Bool = variable_global_exists(name)
	}
	return Bool
}