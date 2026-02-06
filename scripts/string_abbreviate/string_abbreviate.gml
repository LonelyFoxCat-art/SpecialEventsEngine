/// @func string_abbreviate(value, exact)
/// @desc 将数字缩写为带单位的简洁字符串（1000→"1k", 1000000→"1M"）
/// @param {real|string} value 要缩写的数值
/// @param {bool} exact=false 
///        false: 智能修剪（1.0k → "1k"）
///        true: 保留1位小数（1.0k → "1.0k"）
/// @return {string}
function string_abbreviate(value, exact = false) {
	if (is_string(value)) value = real(value);
    if !(is_real(value) || is_string(value)) return "NaN";
    
    if (value == 0) return "0";
    //if (!is_finite(value)) return string(value);
    
    var negative = (value < 0);
    var num = abs(value);
    var unit = "";
    var divisor = 1;
    
    if (num >= 1000000000000) {       // 1e12
        unit = "T";
        divisor = 1000000000000;
    }
    else if (num >= 1000000000) {     // 1e9
        unit = "B";
        divisor = 1000000000;
    }
    else if (num >= 1000000) {        // 1e6
        unit = "M";
        divisor = 1000000;
    }
    else if (num >= 1000) {           // 1e3
        unit = "k";
        divisor = 1000;
    }
    
    var scaled = (divisor > 1) ? (num / divisor) : num;
    var str = string_format(scaled, 0, 1); // 保留1位小数
    
    if (!exact) {
        var len = string_length(str);
        while (len > 0 && string_char_at(str, len) == "0") {
            str = string_copy(str, 1, len - 1);
            len -= 1;
        }
        if (len > 0 && string_char_at(str, len) == ".") {
            str = string_copy(str, 1, len - 1);
        }
    }
    
    if (unit != "") str += unit;
    if (negative) str = "-" + str;
    
    return str;
}