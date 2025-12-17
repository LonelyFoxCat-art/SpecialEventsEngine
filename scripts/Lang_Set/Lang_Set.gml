/// @func Lang_Set(Language)
/// @desc 设置当前语言：若指定语言不在已加载列表中，则尝试从语言文件加载对应数据
/// @arg {string} Language - 要设置的语言标识
/// @returns {bool} 若语言已存在返回 false；若成功加载或文件不存在则返回 true

function Lang_Set(Language){
	var Lang = StorageData.Invoke("Language");
	var Path = PATH_LANG + Lang.File + ".json";
	var content = "";
	
	for (var i = 0; i < array_length(Lang.List); i++) {
		if (Lang.List[i] == Language) return false;
	}
	
	if (file_exists(Path)) {
		var file = file_text_open_read(Path);
		
		while (!file_text_eof(file)) {
	        content += file_text_read_string(file);
			if (!file_text_eof(file)) {
				content += "\n";
				file_text_readln(file);
				if (file_text_eof(file)) break;
			}
		}
		file_text_close(file);
        
		var parsed_data = json_parse(content);
		if (parsed_data != undefined && is_struct(parsed_data)) {
			Lang.Date = parsed_data;
		}
	}
	
	return true;
}