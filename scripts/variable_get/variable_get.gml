/// @function                  variable_get(type, name)
/// @param      {any}          type        - 要访问的变量容器类型（结构体/数组/实例/全局域）
/// @param      {string}       name        - 要获取的变量名称
/// @returns    {any}                      - 返回获取到的变量值，未找到时返回0
/// @description               通用变量获取函数，自动识别容器类型并安全获取变量值
/// @warning                   对于不存在的变量会返回0而非undefined，需注意类型转换
function variable_get(type, name){
	var Value = 0
	if (is_struct(type)) {
		Value = struct_get(type, name)
	} else if (is_array(type)) {
		Value = array_get(type, name)
	} else if (instance_exists(type)) {
		Value = variable_instance_get(type, name)
	} else if (type == global) {
		Value = variable_global_get(name)
	}
	return Value
}