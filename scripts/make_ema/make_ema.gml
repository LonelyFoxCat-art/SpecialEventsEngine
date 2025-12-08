/// @desc 创建指数移动平均器
/// @param alpha 平滑系数（0~1，越小越平滑）
/// @returns 结构体 {value: 0, add: func, get: func}
function make_ema(alpha) {
    return {
        value: undefined,
        alpha: alpha,
		
		add: function(new_value) {
	        if (is_undefined(self.value)) {
	            self.value = new_value;
	        } else {
	            self.value = self.alpha * new_value + (1 - self.alpha) * self.value;
	        }
	    },
		
		get: function() {
	        return self.value;
	    }
    };
}