/// @func Anim_SetPauseState(AnimName, state)
/// @desc 设置指定动画的暂停状态
/// @arg {string} AnimName - 动画的唯一标识名（由 Anim_Create 等函数返回）
/// @arg {bool} state - 暂停状态（true 为暂停，false 为恢复）
/// @returns {bool} 若找到并成功设置返回 true，否则返回 false

function Anim_SetPauseState(AnimName, state) {
	var AnimSystem = global.structure.Invoke("Animation");
    var list = AnimSystem.AnimationList;
    for (var i = 0; i < array_length(list); i++) {
        var entry = list[i];
        var targetStr = (entry.Target == global) ? "global" : string(entry.Target);
        var entryName = targetStr + "_" + entry.VarName + "_" + string(entry.AnimationID);
        
        if (entryName == AnimName) {
            entry.Pause = state;
            return true;
        }
    }
    return false;
}