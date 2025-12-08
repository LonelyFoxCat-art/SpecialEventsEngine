/// @func Anim_IsExist(Target, VarName = "")
/// @desc 检查是否存在指定目标和变量名的动画
/// @desc 若 VarName 为空字符串，则仅检查目标是否存在任何动画
/// @arg {any} Target - 要检查的目标（global、实例ID 或对象ID）
/// @arg {string} VarName - 变量名（可选，为空则忽略变量名匹配）
/// @returns {bool} 若存在匹配的动画返回 true，否则返回 false

function Anim_IsExist(Target, VarName = "") {
	var Anim = global.structure.Invoke("Animation");
	var animList = Anim.AnimationList;
	
	for (var i = 0; i < array_length(animList); i++) {
		var entry = animList[i];
		var targetMatch = false;
		
		if (Target == global) {
			targetMatch = (entry.Target == global);
		} else if (Target <= -10) {
			targetMatch = (entry.Target == Target);
		} else if (instance_exists(Target)) {
			targetMatch = (
				entry.Target == Target || (is_struct(entry.Target) && instance_exists(entry.Target) && entry.Target.object_index == Target)
			);
		}
		
		if (targetMatch) {
			if (VarName == "" || entry.VarName == VarName) {
				return true;
			}
		}
	}
	
	return false;
}