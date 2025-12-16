/// @function RotCoordinate(vector|real, real|vector, [real], [vector|real])
/// @desc 旋转并缩放坐标/向量（缩放为比例因子）
/// @param {Vector2|real} input 向量或x坐标
/// @param {real|Vector2} angle_or_y 角度或y坐标
/// @param {real} [angle] 角度（当第一个参数不是vector时必需）
/// @param {Vector2|real} [scale=1] 缩放因子（1=不缩放，2=放大一倍）
/// @returns {Vector2} 旋转缩放后的向量
function RotCoordinate() {
    var vec, angle, scale = 1;
    
    if (is_struct(argument[0])) {
        vec = argument[0];
        angle = argument[1];
        scale = argument[2] ?? 1;
    } else {
        vec = Vector2(argument[0], argument[1]);
        angle = argument[2];
        scale = argument[3] ?? 1;
    }
    
    var vsin = dsin(angle);
    var vcos = dcos(angle);
    
    // 旋转计算
    var _x = vec.x * vcos - vec.y * vsin;
    var _y = vec.x * vsin + vec.y * vcos;
    
    // 应用缩放
    if (is_struct(scale)) {
        return Vector2(_x * scale.x, _y * scale.y); // 非均匀缩放
    } else {
        return Vector2(_x * scale, _y * scale); // 均匀缩放
    }
}