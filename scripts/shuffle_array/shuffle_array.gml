/// @desc 洗牌（原地打乱）
/// @param arr 数组（会被修改）
/// @returns 打乱后的数组（同一引用）
function shuffle_array(arr) {
    var n = array_length(arr);
    for (var i = n - 1; i > 0; i--) {
        var j = irandom(i);
        var temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }
    return arr;
}