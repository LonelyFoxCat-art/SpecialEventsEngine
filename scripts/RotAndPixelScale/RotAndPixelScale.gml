/// @function RotAndPixelScale(vector|real, real|vector, [real], [vector|real])
/// @desc 旋转并按绝对像素值缩放（保持方向，改变长度）
/// @param {Vector2|real} input 向量或x坐标
/// @param {real|Vector2} angle_or_y 角度或y坐标
/// @param {real} [angle] 角度（当第一个参数不是vector时必需）
/// @param {Vector2|real} [pixel_scale] 要增加/减少的像素长度（向量=非均匀，实数=均匀）
/// @returns {Vector2} 旋转并缩放后的向量
function RotAndPixelScale() {
    var vec, angle, pixel_scale = 0;
    
    // 参数解析
    if (is_struct(argument[0])) {
        vec = argument[0];
        angle = argument[1];
        pixel_scale = argument_count > 2 ? argument[2] : 0;
    } else {
        vec = Vector2(argument[0], argument[1]);
        angle = argument[2];
        pixel_scale = argument_count > 3 ? argument[3] : 0;
    }
    
    // 先计算缩放（在局部坐标系中）
    var scaled = Vector2(vec.x, vec.y);
    
    if (vec.x != 0 || vec.y != 0) {
        if (is_struct(pixel_scale)) {
            // 非均匀缩放
            if (scaled.x != 0) scaled.x += pixel_scale.x * sign(scaled.x);
            if (scaled.y != 0) scaled.y += pixel_scale.y * sign(scaled.y);
        } else if (pixel_scale != 0) {
            // 均匀缩放
            if (scaled.x != 0) scaled.x += pixel_scale * sign(scaled.x);
            if (scaled.y != 0) scaled.y += pixel_scale * sign(scaled.y);
        }
    }
    
    // 然后旋转缩放后的向量
    var vsin = dsin(angle);
    var vcos = dcos(angle);
    return Vector2(
        scaled.x * vcos - scaled.y * vsin,
        scaled.x * vsin + scaled.y * vcos
    );
}