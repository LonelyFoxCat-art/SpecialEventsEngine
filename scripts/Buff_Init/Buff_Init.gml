/// @func Buff_Init()
/// @desc 初始化 Buff 系统结构，包含空的 Buff 列表、自定义初始化回调和步进逻辑占位
/// @returns {struct} 包含 BuffList、Custom 和 Update 字段的初始结构

function Buff_Init(){
	return {
		BuffList: { },
		Custom: Buff_Custom,
		UpdateStep: undefined
	}
}