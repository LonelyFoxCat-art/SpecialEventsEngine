/// @func arcsinh(x)
/// @desc 反双曲正弦函数
/// @param x 任意实数
/// @returns arcsinh(x) = ln(x + sqrt(x^2 + 1))
function arcsinh(_x){
	return ln(_x + sqrt(_x * _x + 1));
}