/// @func arccosh(x)
/// @desc 反双曲余弦函数
/// @param x 数值，必须 ≥ 1
/// @returns arccosh(x) = ln(x + sqrt(x^2 - 1))
function arccosh(_x){
	if (_x < 1) {
	    show_debug_message("arccosh domain error: x must be >= 1");
	    return 0;
	}
	return ln(_x + sqrt(_x * _x - 1));
}