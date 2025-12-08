/// @func Input_Register(Name, Keys, Mode = InputMode.ALL)
/// @desc 注册一个新的输入绑定，将指定键（或键列表）与名称关联
/// @arg {string} Name - 输入绑定的唯一标识名称
/// @arg {any} Keys - 单个键码、字符或键码/字符组成的数组
/// @arg {enum} Mode - 输入检测模式，默认为 InputMode.ALL
/// @returns {bool} 注册成功返回 true，若名称已存在返回 false

function Input_Register(Name, Keys, Mode = InputMode.ALL){
	var Input = global.structure.Invoke("Input");
	if (Input_IsExist(Name)) return false;
	
	var keyArray = [];
    if (is_array(Keys)) {
        for (var i = 0; i < array_length(Keys); i++) {
            var k = Keys[i];
            keyArray[i] = is_string(k) ? ord(k) : k;
        }
    } else {
        keyArray[0] = is_string(Keys) ? ord(Keys) : Keys;
    }
	
	Input.KeyList[$ Name] = {
        keys: keyArray,
        mode: Mode
    };
	return true
}