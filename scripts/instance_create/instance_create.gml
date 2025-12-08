/// @function                  instance_create(X, Y, Object, [Depth], [Layer])
/// @param      {real}         X           - 实例X坐标
/// @param      {real}         Y           - 实例Y坐标
/// @param      {asset|object} Object      - 要创建的对象（对象资源或实例ID）
/// @param      {real}         [Depth]     - 可选深度值（未指定时自动获取）
/// @param      {string}       [Layer]     - 可选图层名称（优先于深度）
/// @returns    {instance|undefined}       - 返回创建的实例，失败返回undefined
/// @description               安全创建实例，支持自动深度管理和图层控制
/// @warning                   若对象无效或创建失败会返回undefined
function instance_create(X, Y, Object, Depth = undefined, Layer = undefined) {
    // 验证对象有效性
    if (!object_exists(Object)) {
        show_debug_message("instance_create 错误：无效对象 " + string(Object));
        return undefined;
    }
    
    // 优先使用图层创建（如果指定）
    if (!is_undefined(Layer)) {
        if (layer_exists(Layer)) {
            return instance_create_layer(X, Y, Layer, Object);
        }
        show_debug_message("instance_create 警告：图层 " + Layer + " 不存在，改用深度创建");
    }
    
    // 确定深度值（未指定时获取对象默认深度）
    var final_depth = is_undefined(Depth) ? object_get_depth(Object) : Depth;
    
    // 创建实例
    var inst = instance_create_depth(X, Y, final_depth, Object);
    
    // 验证创建结果
    if (!instance_exists(inst)) {
        show_debug_message("instance_create 错误：实例创建失败");
        return undefined;
    }
    
    return inst;
}