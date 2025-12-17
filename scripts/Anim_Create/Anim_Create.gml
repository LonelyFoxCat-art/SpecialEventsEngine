/// @func Anim_Create(Target, VarName, Tween, Start, Finish, Duration, Delay = 0)
/// @desc 创建一个动画并添加到全局动画列表中
/// @desc 自动获取起始值（若未提供），支持全局变量或实例变量
/// @arg {any} Target - 动画目标对象（实例ID 或 global）
/// @arg {string} VarName - 要动画化的变量名
/// @arg {int} Tween - 插值类型（如 Tween.LINEAR 等）
/// @arg {any} Start - 起始值（可选，若未提供则自动读取当前值）
/// @arg {any} Finish - 结束值（必需）
/// @arg {real} Duration - 动画持续时间（秒），必须 ≥ 0
/// @arg {real} Delay - 动画延迟开始时间（秒，默认为 0）
/// @returns {string} 动画唯一标识名（格式：target_VarName_id），失败返回空字符串

function Anim_Create(Target, VarName, Tween, Start, Finish, Duration, Delay = 0) {
    if (Duration < 0) return "";
    if (!is_string(VarName) || VarName == "") return "";
    if (is_undefined(Finish)) return "";

    var Anim = StorageData.Invoke("Animation");
	
    if (is_undefined(Start)) {
        if (variable_exists(Target, VarName)) {
			Start = variable_get(Target, VarName);
		} else {
			return "";
		}
    }

    var targetStr = (Target == global) ? "global" : string(Target);
    var AnimName = targetStr + "_" + VarName + "_" + string(Anim.Animation_id);

    var AnimStruct = {
        Target: Target,
        VarName: VarName,
        Tween: Tween,
        StartValue: Start,
        FinishValue: Finish,
        Duration: Duration,
        Delay: Delay,
        Time: 0,
        Pause: false,
        LoopMode: AnimLoopMode.NONE,
        Count: 0,
        MaxCount: 0,
		Speed: 1,
		Pause: false
    };

    array_push(Anim.AnimationList, AnimStruct);
    Anim.Animation_id += 1;

    return AnimName;
}