/// @func Lang_Init()
/// @desc 初始化语言系统结构，包括语言文件列表、默认语言、自定义语言处理函数和更新步骤
/// @returns {struct} 包含语言系统所需字段的结构体

function Lang_Init(){
	return { 
		List: filefind(PATH_LANG, "*.json"),
		File: "chinese", 
		Date: { }, 
		Custom: Lang_Custom,
		UpdateStep: Lang_Update
	}
}