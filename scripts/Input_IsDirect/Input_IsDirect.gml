/// @func Input_IsDirect(Name)
/// @desc 检查指定输入名称对应的按键是否处于直接按下状态（即当前帧按下，不响应重复）
/// @arg {string} Name - 输入配置的名称，需在 Input.KeyList 中存在
/// @returns {bool} 如果任一关联按键当前帧被直接按下则返回 true，否则返回 false

function Input_IsDirect(Name) {
    var Input = StorageData.Invoke("Input");
    if (!Input_IsExist(Name)) return false;
    
    var KeyInfo = Input.KeyList[$ Name];
    return Input_Check(KeyInfo, keyboard_check_direct);
}