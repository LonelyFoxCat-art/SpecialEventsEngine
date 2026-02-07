/// @function                  object_get_depth(instance_or_object)
/// @param      {instance|asset} instance_or_object - 实例ID或对象资源
/// @returns    {real}                         - 对象的深度值
/// @description               获取对象/实例的预设深度值，支持动态计算
/// @warning                   传入实例时返回其实例化时的对象深度
function object_get_depth(instance_or_object) {
    switch (instance_or_object) {
		case bullet_gb:
		case bullet_gb_beam:
			return -1000;
        default:
            return 0;
    }
}