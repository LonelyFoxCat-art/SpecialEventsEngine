/// @function InstanceGetList(obj)
/// @description 获取指定对象的所有活动实例数组（优化版）
/// @param {object} obj 要查询的游戏对象
/// @returns {array} 包含所有活动实例ID的数组（若无实例则返回空数组）
/// @throws 当参数无效时输出调试信息
function InstanceGetList(obj) {
    // 有效性检查
    if (!instance_exists(obj)) {
        return [];
    }
    
    var _count = instance_number(obj);
    if (_count <= 0) return [];
    
    // 预分配内存提高性能
    var _list = array_create(_count);
    var _index = 0;
    
    // 使用with迭代器更高效遍历
    with (obj) {
        _list[_index++] = id; // 直接获取实例ID
    }
    
    return _list;
}