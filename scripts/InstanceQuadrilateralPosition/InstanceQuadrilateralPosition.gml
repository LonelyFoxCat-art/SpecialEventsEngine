/// @function                  InstanceQuadrilateralPosition(inst, [deviation])
/// @param      {instance|object} inst    - 目标实例或对象类型
/// @param      {real|array}     [deviation] - 单值偏移或数组[左,右,上,下]偏移
/// @returns    {array}                    - 碰撞状态数组[上,下,左,右]
/// @description               检测与目标实例组的多方向碰撞，支持四边形偏移检测
/// @warning                   实例组为空时直接返回[false,false,false,false]
/// @example
/// // 检测与所有敌人的碰撞（2像素偏移）
/// var col = InstanceQuadrilateralPosition(obj_enemy, 2);
/// if (col[3]) show_message("右侧有敌人！");

function InstanceQuadrilateralPosition(inst, deviation = 0) {
    // 获取实例组（兼容单个实例或对象类型）
    var instance_list = InstanceGetList(inst);
    var count = array_length(instance_list);
    
    // 空组快速返回
    if (count <= 0) return [false, false, false, false];
    
    // 初始化碰撞状态和精灵尺寸
    var collisions = [false, false, false, false];
    var sw = sprite_width  * abs(image_xscale);
    var sh = sprite_height * abs(image_yscale);
    
    // 解析偏移量（支持单值或四向独立偏移）
    var dev = is_array(deviation) ? deviation : [deviation, deviation, deviation, deviation];
    
    // 遍历检测每个实例
    for (var i = 0; i < count; i++) {
        var target = instance_list[i];
        
        // 提前终止：如果所有方向都已检测到碰撞
        if (collisions[0] && collisions[1] && collisions[2] && collisions[3]) break;
        
        // 四方向检测（未确认的方向才检测）
        if (!collisions[3]) collisions[3] = instance_place(x - sw/2 - dev[1], y, target);        // Right
        if (!collisions[2]) collisions[2] = instance_place(x + sw/2 + dev[0], y, target);        // Left
        if (!collisions[0]) collisions[0] = instance_place(x, y - sh/2 - dev[2], target);        // Top
        if (!collisions[1]) collisions[1] = instance_place(x, y + sh/2 + dev[3], target);        // Bottom
    }
    
    return collisions;
}