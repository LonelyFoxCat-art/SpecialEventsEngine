/// @func sech(x)
/// @desc 双曲正割：sech(x) = 1 / cosh(x)
/// @param x 任意实数
/// @returns (0, 1] 范围内的值
function sech(_x){
	var cosh_val = (exp(_x) + exp(-_x)) * 0.5;
	if (cosh_val == 0) return 0;
	return 1.0 / cosh_val;
}