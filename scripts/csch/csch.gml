/// @func csch(x)
/// @desc 双曲余割：csch(x) = 1 / sinh(x)
/// @param x 任意非零实数（x ≠ 0）
/// @returns 实数，|csch(x)| > 0
function csch(_x){
	if (_x == 0) {
	    show_debug_message("csch domain error: x must not be 0");
	    return 0;
	}
	var sinh_val = (exp(_x) - exp(-_x)) * 0.5;
	if (sinh_val == 0) return 0;
	return 1.0 / sinh_val;
}