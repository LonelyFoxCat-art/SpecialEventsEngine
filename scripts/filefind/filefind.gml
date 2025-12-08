/// @func filefind(dir, mask)
/// @desc 查找指定目录下符合掩码的文件
/// @arg {string} dir - 要搜索的目录路径
/// @arg {string} mask - 文件名掩码（如 "*.txt"）
/// @returns {array} 找到的文件路径数组
function filefind(dir, mask){
	var file_handle = file_find_first(dir + mask, 0);
	var file = [];
	
	if (file_handle != "") {
		array_push(file, filename_change_ext(file_handle, ""));
	    var filename = file_find_next()
	    while (filename != "") {
			filename = file_find_next()
			array_push(file, filename_change_ext(filename, ""));
	    }
	    file_find_close();
	}
		
	return file;
}