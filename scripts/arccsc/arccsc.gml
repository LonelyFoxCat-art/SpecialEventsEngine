/// @func arccsc(x)
/// @desc 反余割函数（主值范围 [-π/2, 0) ∪ (0, π/2]）
/// @param x 满足 |x| ≥ 1
/// @returns 弧度值 ∈ [-π/2, π/2] 且 ≠ 0
function arccsc(_x){
	if (abs(_x) < 1) {
	    show_debug_message("arccsc domain error: |x| must be >= 1");
	    return 0;
	}
	return arcsin(1.0 / _x);
}