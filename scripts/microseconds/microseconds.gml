/// @func microseconds(_speed = 1)
/// @desc 获取基于游戏帧率的时间增量，用于实现帧率无关的时间计算
/// @arg {real} _speed - 速度倍数，默认为 1
/// @returns {real} 时间增量值
function microseconds(_speed = 1){
	return (delta_time / 1000000) * _speed;
}