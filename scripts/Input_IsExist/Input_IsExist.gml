/// @func Input_IsExist(Name)
/// @desc 检查指定名称的输入配置是否存在
/// @arg {string} Name - 要检查的输入配置名称
/// @returns {bool} 若名称存在于 Input.KeyList 中则返回 true，否则返回 false

function Input_IsExist(Name){
    var Input = global.structure.Invoke("Input");
    return struct_exists(Input.KeyList, Name);
}