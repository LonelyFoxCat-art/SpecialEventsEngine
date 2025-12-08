/// @func arcsec(x)
/// @desc 反正割函数（主值范围 [0, π/2) ∪ (π/2, π]）
/// @param x 满足 |x| ≥ 1
/// @returns 弧度值 ∈ [0, π] 且 ≠ π/2
function arcsec(_x){
	if (abs(_x) < 1) {
	    show_debug_message("arcsec domain error: |x| must be >= 1");
	    return 0;
	}

	return arccos(1.0 / _x);
}