/// @func Anim_CreateBezier(Target, VarNames, BezierController, Duration, Delay = 0, LoopMode = AnimLoopMode.NONE)
/// @desc 创建一个基于贝塞尔曲线的多变量动画并加入全局动画列表
/// @desc 要求提供有效的贝塞尔控制器（需包含 getPointAt 方法）和至少一个变量名
/// @arg {any} Target - 动画目标对象（实例ID 或 global）
/// @arg {string[]} VarNames - 要同步动画的变量名数组（至少一个）
/// @arg {struct} BezierController - 贝塞尔控制器，必须包含 getPointAt(t) 方法
/// @arg {real} Duration - 动画持续时间（秒），必须 > 0
/// @arg {real} Delay - 动画延迟开始时间（秒，默认为 0）
/// @arg {int} LoopMode - 循环模式（如 AnimLoopMode.NONE、ONCE、RESTART 等，默认为 NONE）
/// @returns {string} 动画唯一标识名（格式：target_firstVar_Bezier_id），失败返回空字符串

function Anim_CreateBezier(Target, VarNames, BezierController, Duration, Delay = 0, LoopMode = AnimLoopMode.NONE) {
    if (!is_array(VarNames) || array_length(VarNames) == 0) return "";
    if (!is_struct(BezierController) || !variable_struct_exists(BezierController, "getPointAt")) return "";
    if (Duration <= 0) return "";
    
    var AnimSystem = global.structure.Invoke("Animation");
    var currentID = AnimSystem.Animation_id;
    var targetStr = (Target == global) ? "global" : string(Target);
    var baseName = targetStr + "_" + string(VarNames[0]) + "_Bezier";
    var AnimName = baseName + "_" + string(currentID);
    
    var AnimStruct = {
        Target: Target,
        VarNames: VarNames,
        Duration: Duration,
        Delay: Delay,
        Time: 0,
        Pause: false,
        LoopMode: LoopMode,
        MaxCount: 0,
        Count: 0,
        Speed: 1,
        IsBezier: true,
        BezierController: BezierController,
        AnimationID: currentID
    };
    
    array_push(AnimSystem.AnimationList, AnimStruct);
    AnimSystem.Animation_id += 1;
    
    return AnimName;
}