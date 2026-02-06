/// @function                  array_index(array, index, [default])
/// @param      {array}        array       - 要访问的数组
/// @param      {int}          index       - 索引位置（支持负数逆向索引）
/// @param      {any}          [default]   - 索引越界时的默认值（默认undefined）
/// @returns    {any}                      - 数组元素或默认值
/// @description               安全访问数组元素，支持多维数组和逆向索引
function array_index(array, index){
	if (index < array_length(array)) return array[index]
	return noone
}