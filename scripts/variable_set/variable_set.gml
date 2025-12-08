/// @function                  variable_set(type, name, value)
/// @param      {any}          type        - 要设置的变量容器类型（结构体/数组/实例/全局域）
/// @param      {string}       name        - 要设置的变量名称
/// @param      {any}          value       - 要设置的值
/// @description               通用变量设置函数，自动识别容器类型并安全设置变量值
/// @warning                   当传入无效类型时会输出调试信息，但不会中断程序执行
function variable_set(type, name, value) {
    if (is_struct(type)) {
        struct_set(type, name, value);
    } else if (is_array(type)) {
        array_set(type, name, value);
    } else if (instance_exists(type)) {
        variable_instance_set(type, name, value);
    } if (type == global) {
        variable_global_set(name, value);
    }
}