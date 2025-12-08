/// @func Anim_Remove(Target, VarName = "")
/// @desc 从动画列表中移除指定目标和变量名的动画
/// @desc 若 VarName 为空字符串，则移除该目标的所有动画
/// @arg {any} Target - 动画目标（global、实例ID 等）
/// @arg {string} VarName - 要移除的变量名（可选，为空则移除目标全部动画）
/// @returns {bool} 若成功移除至少一个动画返回 true，否则返回 false

function Anim_Remove(Target, VarName = "") {
    var Anim = global.structure.Invoke("Animation");
    var deleted = false;
    var list = Anim.AnimationList;
    var len = array_length(list);
    
    for (var i = len - 1; i >= 0; i--) {
        var entry = list[i];
        var targetMatches = (entry.Target == Target);
        var varMatches = (VarName == "" || entry.VarName == VarName);
        
        if (targetMatches && varMatches) {
            array_delete(list, i, 1);
            deleted = true;
        }
    }
    
    return deleted;
}