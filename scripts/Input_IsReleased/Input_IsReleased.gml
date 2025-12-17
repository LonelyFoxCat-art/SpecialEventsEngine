/// @func Input_IsReleased(Name)
/// @desc 检查指定输入名称对应的按键是否在当前帧被释放（即从按下变为松开）
/// @arg {string} Name - 输入配置的名称，需在 Input.KeyList 中存在
/// @returns {bool} 如果任一关联按键在当前帧被释放则返回 true，否则返回 false

function Input_IsReleased(Name) {
	var Input = StorageData.Invoke("Input");
    if (!Input_IsExist(Name)) return false;

	var KeyInfo = Input.KeyList[$ Name];
    return Input_Check(KeyInfo, keyboard_check_released);
}