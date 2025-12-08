/// @func coth(x)
/// @desc 双曲余切：coth(x) = cosh(x) / sinh(x) = (e^x + e^{-x}) / (e^x - e^{-x})
/// @param x 任意非零实数（x ≠ 0）
/// @returns 双曲余切值，|coth(x)| > 1
function coth(_x){
	if (_x == 0) {
	    show_debug_message("coth domain error: x must not be 0");
	    return 0;
	}
	var ex = exp(_x);
	var emx = exp(-_x);
	var sinh_val = ex - emx;
	if (sinh_val == 0) {
	    show_debug_message("coth overflow at x=0");
	    return 0;
	}
	return (ex + emx) / sinh_val;
}