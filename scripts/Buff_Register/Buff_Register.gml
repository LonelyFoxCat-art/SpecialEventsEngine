/// @func Buff_Register(Name, Duration, ApplyFn, UpdateFn, RemoveFn)
/// @desc 注册一个新的 buff 效果到系统中
/// @arg {string} Name - buff 的唯一标识名称
/// @arg {number} Duration - buff 的持续时间（单位依系统设定，如秒或帧）
/// @arg {function|undefined} ApplyFn - buff 被应用时执行的回调函数（可选）
/// @arg {function|undefined} UpdateFn - buff 每次更新时执行的回调函数（可选）
/// @arg {function|undefined} RemoveFn - buff 被移除时执行的回调函数（可选）
/// @returns {bool} 注册成功返回 true，若名称已存在则返回 false

function Buff_Register(Name, Duration, ApplyFn = undefined, UpdateFn = undefined, RemoveFn = undefined){
	if (Buff_IsExist(Name)) return false;
	var Buff = global.structure.Invoke("Buff");
	
	var newBuff = {
        Name: Name,
        Duration: Duration,      // 持续时间（单位：秒或帧，依你系统而定）
        Apply: ApplyFn,          // 应用时调用
        Update: UpdateFn,        // 每帧/周期更新时调用
        Remove: RemoveFn         // 移除时调用
    };

    Buff.BuffList[$ Name] = newBuff;

    return true;
}