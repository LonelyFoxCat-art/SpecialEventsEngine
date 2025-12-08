/// @func cosh(x)
/// @desc 双曲余弦函数
/// @param x 任意实数
/// @returns cosh(x) = (e^x + e^{-x}) / 2
function cosh(_x){
	return (exp(_x) + exp(-_x)) * 0.5;
}