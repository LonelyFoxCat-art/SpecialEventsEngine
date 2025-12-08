/// @func Lang_IsExist(Name)
/// @desc 检查指定名称的语言键是否存在
/// @arg {string} Name - 要检查的语言键名称
/// @returns {bool} 存在返回 true，否则返回 false

function Lang_IsExist(Name){
	var Lang = global.structure.Invoke("Language");
	var LangKey = struct_get_names(Lang.Date);
	var LangCount = array_length(LangKey);
	
	for(var i = 0; i < LangCount; i ++) {
		if (LangKey[i] == Name) return true;
	}
	
	return false;
}