/// @function InstanceGetList(inst)
/// @description 获取指定对象的所有活动实例数组（优化版）
/// @param {Any} inst 要查询的游戏对象
/// @returns {Array<inst>} 包含所有活动实例ID的数组（若无实例则返回空数组）
/// @throws 当参数无效时输出调试信息
function InstanceGetList(obj) {
    if (!instance_exists(obj)) return [];
    
    var _count = instance_number(obj);
    if (_count <= 0) return [];
    
    var _list = array_create(_count);
    var _index = 0;
    
    with (obj) _list[_index++] = self
    
    return _list;
}