/// @func Lang_Update(Lang)
/// @desc 将语言数据写入对应 JSON 文件（若文件不存在时）
/// @arg {struct} Lang - 语言配置结构体，需包含 File（文件名，不含扩展名）和 Date（要保存的语言数据）

function Lang_Update(Lang){
	var Path = global.Path.Lang + Lang.File + ".json";
	
	if (!file_exists(Path)) {
		var json_str = json_stringify(Lang.Date, true);
		var file = file_text_open_write(Path);
		file_text_write_string(file, json_str);
		file_text_close(file);
	}
}