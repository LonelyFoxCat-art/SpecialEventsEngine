/// @func Anim_SetSpeed(Type, Speed = 1, AnimName = "")
/// @desc 设置动画播放速度：可设置全局速度或指定单个动画的速度
/// @arg {int} Type - 速度类型（AnimType.GLOBAL：全局；AnimType.INDIVIDUAL：单个动画）
/// @arg {real} Speed - 播放速度（范围被限制在 [-10, 10]，默认为 1）
/// @arg {string} AnimName - 当 Type 为 INDIVIDUAL 时，指定动画的唯一名称
/// @returns {bool} 设置成功返回 true，失败（如无效 AnimName 或类型）返回 false

function Anim_SetSpeed(Type, Speed = 1, AnimName = "") {
    var AnimSystem = global.structure.Invoke("Animation");
    
    if (Type == AnimType.GLOBAL) {
        AnimSystem.AnimSpeed = clamp(Speed, -10, 10);
        return true;
        
    } else if (Type == AnimType.INDIVIDUAL) {
        if (!is_string(AnimName) || AnimName == "") return false;
        
        var list = AnimSystem.AnimationList;
        for (var i = 0; i < array_length(list); i++) {
            var entry = list[i];
            var targetStr = (entry.Target == global) ? "global" : string(entry.Target);
            var entryName = targetStr + "_" + entry.VarName + "_" + string(entry.AnimationID);
            
            if (entryName == AnimName) {
                entry.Speed = clamp(Speed, -10, 10);
                return true;
            }
        }
        return false;
    }
    
    return false;
}