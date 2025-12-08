/// @func tanh(x)
/// @desc 双曲正切函数
/// @param x 任意实数
/// @returns tanh(x) = sinh(x) / cosh(x) ∈ (-1, 1)
function tanh(_x){
	var ex = exp(_x);
	var emx = exp(-_x);
	return (ex - emx) / (ex + emx);
}