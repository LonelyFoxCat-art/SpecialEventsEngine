/// @func Shaker_Create(Target, VarName, Shake, Speed = 0, Random = false, Decrease = 1)
/// @desc 创建或更新一个抖动效果，作用于指定目标对象的指定变量
/// @arg {any} Target - 抖动作用的目标对象
/// @arg {string} VarName - 被抖动影响的变量名
/// @arg {real} Shake - 抖动强度（最大偏移量）
/// @arg {real} Speed - 抖动频率（仅在非随机模式下生效），默认为 0
/// @arg {bool} Random - 是否使用随机抖动，若为 false 则使用正弦波抖动，默认为 false
/// @arg {real} Decrease - 每帧抖动衰减量，控制抖动随时间减弱的速度，默认为 1
/// @returns {bool} 若已存在同目标同变量的抖动项并被更新，返回 true；否则为新建，返回 false

function Shaker_Create(Target, VarName, Shake, Speed = 0, Random = false, Decrease = 1){
	var Shaker = StorageData.Invoke("Shaker");
	var ShakerIndex = Shaker_IsExist(Target, VarName);
	show_debug_message("ShakerIndex:"+string(ShakerIndex))
    var newShake = {
		Type: typeof(Target),
        target: Target,
        varname: VarName,
		shake: Shake,
        velocity: Speed,
        randomly: Random,
        decrease: Decrease,
        base_value: 0,
		pos: 0,
		time: 0,
		positive: true,
    };
	
    if (ShakerIndex > 0) {
		var ShakerDate = Shaker.ShakerList[ShakerIndex];
        ShakerDate.shake = Shake;
		ShakerDate.velocity = Speed;
		ShakerDate.randomly = Random;
		ShakerDate.decrease = Decrease;
    } else {
		newShake.base_value = variable_get(Target, VarName);
        array_push(Shaker.ShakerList, newShake);
    }
    
    return ShakerIndex > 0;
}