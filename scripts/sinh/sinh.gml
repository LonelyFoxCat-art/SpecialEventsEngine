/// @func sinh(x)
/// @desc 双曲正弦函数
/// @param x 任意实数
/// @returns sinh(x) = (e^x - e^{-x}) / 2
function sinh(_x) {
	return (exp(_x) - exp(-_x)) * 0.5;
}