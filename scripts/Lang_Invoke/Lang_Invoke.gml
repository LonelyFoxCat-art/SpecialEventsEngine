/// @func Lang_Invoke(Name, Text = undefined)
/// @desc 获取或设置指定键名的语言文本
/// @arg {string} Name - 语言键名
/// @arg {string} Text - 可选，若提供则尝试添加该语言条目（仅在键不存在时生效）
/// @returns {string|bool} 若为获取模式，返回对应文本或 "Not Found"；若为设置模式，成功添加返回 true，已存在则返回 false

function Lang_Invoke(Name, Text = undefined){
	var Lang = global.structure.Invoke("Language");
    
    if (Text != undefined) {
		if (Lang_IsExist(Name)) return false
		Lang.Date[$ Name] = string(Text);
		return true;
	} else {
		return Lang.Date[$ Name] ?? "Not Found";
	}
}