/// @function GetCoordinates(start, finish, index)
/// @description 在给定范围 [start, finish] 内计算对称分布的坐标
/// @param {number} start 起始坐标
/// @param {number} finish 结束坐标
/// @param {number} index 要生成的对称点数量
/// @return {number[]} 计算出的X坐标数组
function GetCoordinates(start, finish, index = 1) {
    var range = finish - start;
    var center = start + range / 2; // 计算中心点
    
    // 验证参数有效性
    if (index <= 0) return []; // 返回空数组如果参数无效
	if (index == 1) return [center]
    
    // 确保返回的点数不超过请求的数量（GML没有array_slice，改用循环）
    var result = [];
    var segmentLength = range / (index - 1);
    for (var i = 0; i < index; i++) {
        var point = start + i * segmentLength;
        array_push(result, point);
    }
    
    return result;
}