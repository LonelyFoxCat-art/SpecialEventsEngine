/// @func Anim_SetLoop(AnimName, Mode, Count = 0)
/// @desc 为指定名称的动画设置循环模式和最大循环次数
/// @arg {string} AnimName - 动画的唯一标识名（由 Anim_Create 等函数返回）
/// @arg {int} Mode - 循环模式（如 AnimLoopMode.NONE、RESTART、PINGPONG 等）
/// @arg {int} Count - 最大循环次数（仅在循环模式非 NONE 时有效，默认为 0 表示无限循环）
/// @returns {bool} 若找到并成功设置返回 true，否则返回 false

function Anim_SetLoop(AnimName, Mode, Count = 0) {
    if (!is_string(AnimName) || AnimName == "") return false;
    
    var AnimSystem = StorageData.Invoke("Animation");
    var list = AnimSystem.AnimationList;
    for (var i = 0; i < array_length(list); i++) {
        var entry = list[i];
        var targetStr = (entry.Target == global) ? "global" : string(entry.Target);
        var entryName = targetStr + "_" + entry.VarName + "_" + string(entry.AnimationID);
        
        if (entryName == AnimName) {
            entry.LoopMode = Mode;
            entry.MaxCount = Count;
            return true;
        }
    }
    
    return false;
}