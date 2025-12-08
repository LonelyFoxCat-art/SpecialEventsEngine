/// @function                  InstancelPosition(inst, [deviation])
/// @param      {instance}     inst        - 要检测的实例
/// @param      {real|array}   [deviation] - 单值统一偏移或数组[左,右,上,下]偏移
/// @returns    {array}                    - 碰撞状态数组[上,下,左,右]
/// @description               检测当前实例与目标实例在各方向的碰撞情况
/// @warning                   要求当前实例有有效的sprite索引
function InstancelPosition(inst, deviation = 0) {
    // 初始化碰撞状态
    var collisions = [false, false, false, false];
    
    // 获取当前实例的碰撞体尺寸
    var sw = sprite_width  * abs(image_xscale);
    var sh = sprite_height * abs(image_yscale);
    
    // 解析偏移量
    var dev_left  = is_array(deviation) ? deviation[0] : deviation;
    var dev_right = is_array(deviation) ? deviation[1] : deviation;
    var dev_top   = is_array(deviation) ? deviation[2] : deviation;
    var dev_bottom= is_array(deviation) ? deviation[3] : deviation;
    
    // 四方向精确检测（按需执行）
    if (!collisions[3] && instance_place(x - sw/2 - dev_right, y, inst)) collisions[3] = true;
    if (!collisions[2] && instance_place(x + sw/2 + dev_left,  y, inst)) collisions[2] = true;
    if (!collisions[0] && instance_place(x, y - sh/2 - dev_top,    inst)) collisions[0] = true;
    if (!collisions[1] && instance_place(x, y + sh/2 + dev_bottom, inst)) collisions[1] = true;
    
    return collisions; // [Top, Bottom, Left, Right]
}