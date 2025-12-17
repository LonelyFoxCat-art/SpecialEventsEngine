/// @func Buff_IsExist(Name)
/// @desc 检查指定名称的 Buff 是否存在于 Buff 列表中
/// @arg {string} Name - Buff 的名称
/// @returns {bool} 若存在返回 true，否则返回 false

function Buff_IsExist(Name){
	var Buff = StorageData.Invoke("Buff");
	return struct_exists(Buff.BuffList, Name);
}