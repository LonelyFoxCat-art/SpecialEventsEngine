/// @desc 创建移动平均器
/// @param window_size 窗口大小
/// @returns 结构体（含 add/get 方法）
function make_moving_average(window_size) {
    return {
		buffer: [],
        sum: 0,
        count: 0,
        window: window_size,
		
		add: function(value) {
	        if (self.count < self.window) {
	            array_push(self.buffer, value);
	            self.sum += value;
	            self.count++;
	        } else {
	            var old = self.buffer[0];
	            for (var i = 0; i < self.window - 1; i++) {
	                self.buffer[i] = self.buffer[i + 1];
	            }
	            self.buffer[self.window - 1] = value;
	            self.sum = self.sum - old + value;
	        }
	    },
		
	    get: function() {
	        if (self.count == 0) return undefined;

	        return self.sum / self.count;
	    }
	}
}