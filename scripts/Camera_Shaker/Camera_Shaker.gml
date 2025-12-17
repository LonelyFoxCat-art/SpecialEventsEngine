/// @func Camera_Shaker(Shake, Speed = 0, Random = false, Decrease = 1)
/// @desc 对相机应用震动效果，同时作用于 X 和 Y 轴
/// @arg {real} Shake - 震动强度（偏移幅度）
/// @arg {real} Speed - 震动速度，默认为 0（具体含义由 Shaker_Create 实现决定）
/// @arg {bool} Random - 是否启用随机震动方向
/// @arg {real} Decrease - 震动衰减系数，每次更新时强度乘以此值（通常 ≤1）
/// @returns {bool} 始终返回 true，表示震动已触发

function Camera_Shaker(Shake, Speed = 0, Random = false, Decrease = 1){
	var Camera = StorageData.Invoke("Camera");
	
	Shaker_Create(Camera, "X", Shake, Speed, Random, Decrease);
	Shaker_Create(Camera, "Y", Shake, Speed, Random, Decrease);
	return true;
}