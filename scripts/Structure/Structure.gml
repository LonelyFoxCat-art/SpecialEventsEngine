/// @func Structure() constructor
/// @desc 结构管理器构造函数，用于注册、调用和更新全局结构实例
/// @returns {object} Structure 实例，包含静态方法用于结构管理
function Structure() constructor {
    self.Date = {};

    /// @func Register(Name, Init = undefined)
    /// @desc 注册一个新结构；若已存在则返回 false；注册后若结构含 Custom 方法则自动调用
    /// @arg {string} Name - 结构名称（唯一标识）
    /// @arg {function|undefined} Init - 初始化函数，返回结构初始内容（可选）
    /// @returns {bool} 注册成功返回 true，已存在则返回 false
    static Register = function(Name, Init = undefined) {
        if (Exists(Name)) return false;
		
        self.Date[$ Name] = Init() ?? {};
		var Date = self.Date[$ Name];
		if (struct_exists(Date, "Custom")) Date.Custom();

        return true;
    };
	
    /// @func Invoke(Name)
    /// @desc 获取已注册的结构实例
    /// @arg {string} Name - 结构名称
    /// @returns {struct|undefined} 若存在则返回结构，否则返回 undefined
    static Invoke = function(Name) {
        if (Exists(Name)) return self.Date[$ Name];
        return undefined;
    };

    /// @func Exists(Name)
    /// @desc 检查指定名称的结构是否已注册
    /// @arg {string} Name - 结构名称
    /// @returns {bool} 存在返回 true，否则 false
    static Exists = function(Name) {
        return struct_exists(self.Date, Name);
    };
	
    /// @func Renewal(Name)
    /// @desc 遍历所有已注册结构，调用其中与指定名称同名的方法（若存在且为函数）
    /// @arg {string} Name - 要调用的方法名称
    /// @returns {bool} 若至少有一个结构执行了该方法，返回 true；否则返回 false
    static Renewal = function(Name) {
		var FnName = "Update" + Name;
        var key = struct_get_names(self.Date);
        for(var i = 0; i < array_length(key); i ++) {
			var Date = self.Date[$ key[i]];
            if (struct_exists(Date, FnName) && !is_undefined(Date[$ FnName])) Date[$ FnName](Date);
        }
    };
	
	static Destroy = function() {
        var key = struct_get_names(self.Date);
        for(var i = 0; i < array_length(key); i ++) {
			var Date = self.Date[$ key[i]];
            if (struct_exists(Date, "Destroy")) Date.Destroy();
        }
    };
}