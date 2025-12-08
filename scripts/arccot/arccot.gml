/// @func arccot(x)
/// @desc 反余切函数（主值范围 (0, π)）
/// @param x 任意实数
/// @returns 弧度值 ∈ (0, π)
function arccot(_x){
	return 0.5 * pi - arctan(_x);
}