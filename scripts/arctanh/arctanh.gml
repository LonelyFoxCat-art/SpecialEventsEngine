/// @func arctanh(x)
/// @desc 反双曲正切函数
/// @param x 数值，必须满足 |x| < 1
/// @returns arctanh(x) = 0.5 * ln((1 + x) / (1 - x))
function arctanh(_x){
	if (abs(_x) >= 1) {
	    show_debug_message("arctanh domain error: |x| must be < 1");
	    return 0;
	}
	return 0.5 * ln((1.0 + _x) / (1.0 - _x));
}