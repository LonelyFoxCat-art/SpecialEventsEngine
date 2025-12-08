/// @func Shaker_Update(Shaker)
/// @desc 更新屏幕或对象的抖动效果列表，根据配置动态修改目标变量值，并在抖动结束后移除对应项
/// @arg {struct} Shaker - 抖动系统结构体，包含 ShakerList 数组，其中每个元素为抖动配置对象

function Shaker_Update(Shaker) {
    var List = Shaker.ShakerList;
    
    for (var i = 0; i < array_length(List); i ++) {
	    var config = List[i];
		
		if (config.shake <= 0) {
            variable_set(config.target, config.varname, config.base_value);
            array_delete(List, i, 1);
            continue;
        }
		
		config.time -= 1;
		
		if (config.time <= 0) {
            config.time = config.velocity;
            
            if (config.randomly) {
                config.pos = random_range(-config.shake, config.shake);
            } else {
                if (config.positive) {
                    config.pos = config.shake;
                } else {
                    config.pos = -config.shake;
                }
                config.positive = !config.positive;
            }

            config.shake -= config.decrease;
        }
		
		variable_set(config.target, config.varname, config.base_value + config.pos);
	}
}