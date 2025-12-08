/// @func Shaker_Init()
/// @desc 初始化一个抖动（Shaker）控制器对象，用于管理抖动效果
/// @returns {struct} 包含空抖动列表和更新函数引用的结构体

function Shaker_Init(){
	return {
		ShakerList: [],
		UpdateStep: Shaker_Update
	}
}