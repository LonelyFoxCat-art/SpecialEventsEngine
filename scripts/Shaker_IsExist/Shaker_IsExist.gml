/// @func Shaker_IsExist(Target, VarName)
/// @desc 检查指定目标和变量名的抖动效果是否已存在于抖动列表中
/// @arg {any} Target - 抖动作用的目标对象
/// @arg {string} VarName - 抖动所影响的变量名
/// @returns {int} 若存在，返回其在 ShakerList 中的索引；否则返回 -1

function Shaker_IsExist(Target, VarName) {
    var Shaker = StorageData.Invoke("Shaker");
    var List = Shaker.ShakerList;
    for (var i = 0; i < array_length(List); i++) {
        if (List[i].target == Target && List[i].varname == VarName) {
            return i;
        }
    }
    return -1;
}