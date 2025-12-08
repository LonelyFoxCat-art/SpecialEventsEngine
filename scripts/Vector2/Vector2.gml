/// @func Vector2(x, y)
/// @desc 二维向量构造器。
/// @param {Real} x X 分量
/// @param {Real} y Y 分量
/// @returns {Vector2}
function Vector2(_x = 0, _y = 0) constructor {
	self.type = "Vector2";
	self.x = _x;
	self.y = _y;

	// =============== 实例方法 ===============

	self.Abs = function() {
		return new Vector2(abs(self.x), abs(self.y));
	};
	self.Add = function(_v) {
		return new Vector2(self.x + _v.x, self.y + _v.y);
	};
	self.Subtract = function(_v) {
		return new Vector2(self.x - _v.x, self.y - _v.y);
	};
	self.Multiply = function(_arg) {
		if (is_struct(_arg) && _arg.type == "Vector2") {
			return new Vector2(self.x * _arg.x, self.y * _arg.y);
		} else {
			var _s = _arg;
			return new Vector2(self.x * _s, self.y * _s);
		}
	};
	self.Divide = function(_arg) {
		if (is_struct(_arg) && _arg.type == "Vector2") {
			return new Vector2(self.x / _arg.x, self.y / _arg.y);
		} else {
			var _s = _arg;
			if (_s == 0) _s = 0.000001;
			return new Vector2(self.x / _s, self.y / _s);
		}
	};
	self.Dot = function(_v) {
		return self.x * _v.x + self.y * _v.y;
	};
	self.Length = function() {
		return sqrt(self.x * self.x + self.y * self.y);
	};
	self.LengthSquared = function() {
		return self.x * self.x + self.y * self.y;
	};
	self.Normalize = function() {
		var _len = self.Length();
		if (_len == 0) return new Vector2(0, 0);
		var _inv = 1 / _len;
		return new Vector2(self.x * _inv, self.y * _inv);
	};
	self.Negate = function() {
		return new Vector2(-self.x, -self.y);
	};
	self.Clamp = function(_min, _max) {
		return new Vector2(
			clamp(self.x, _min.x, _max.x),
			clamp(self.y, _min.y, _max.y)
		);
	};
	self.Lerp = function(_v, _t) {
		var _t_clamped = clamp(_t, 0, 1);
		return new Vector2(
			self.x + _t_clamped * (_v.x - self.x),
			self.y + _t_clamped * (_v.y - self.y)
		);
	};
	self.Min = function(_v) {
		return new Vector2(min(self.x, _v.x), min(self.y, _v.y));
	};
	self.Max = function(_v) {
		return new Vector2(max(self.x, _v.x), max(self.y, _v.y));
	};
	self.SquareRoot = function() {
		return new Vector2(
			(self.x >= 0) ? sqrt(self.x) : 0,
			(self.y >= 0) ? sqrt(self.y) : 0
		);
	};
	self.Reflect = function(_normal) {
		var _dot = self.Dot(_normal);
		return self.Subtract(_normal.Multiply(2 * _dot));
	};
	self.Equals = function(_v, _tolerance = 0.000001) {
		return (abs(self.x - _v.x) <= _tolerance && abs(self.y - _v.y) <= _tolerance);
	};
	self.ToString = function() {
		return "Vector2(" + string(self.x) + ", " + string(self.y) + ")";
	};
	self.Copy = function() {
		return new Vector2(self.x, self.y) 
	};
	self.Transform = function(_mat) {
		if (_mat.type == "Matrix3x2") {
			var _x = self.x * _mat.m11 + self.y * _mat.m21 + _mat.m31;
			var _y = self.x * _mat.m12 + self.y * _mat.m22 + _mat.m32;
			return new Vector2(_x, _y);
		} else if (_mat.type == "Matrix4x4") {
			var _x = self.x * _mat.m00 + self.y * _mat.m10 + _mat.m30;
			var _y = self.x * _mat.m01 + self.y * _mat.m11 + _mat.m31;
			var _w = self.x * _mat.m03 + self.y * _mat.m13 + _mat.m33;
			if (_w != 0) {
				_x /= _w;
				_y /= _w;
			}
			return new Vector2(_x, _y);
		}
		return Zero;
	};
	self.TransformNormal = function(_mat) {
		if (_mat.type == "Matrix3x2") {
			var _x = self.x * _mat.m11 + self.y * _mat.m21;
			var _y = self.x * _mat.m12 + self.y * _mat.m22;
			return new Vector2(_x, _y);
		} else if (_mat.type == "Matrix4x4") {
			var _x = self.x * _mat.m00 + self.y * _mat.m10;
			var _y = self.x * _mat.m01 + self.y * _mat.m11;
			return new Vector2(_x, _y);
		}
		return Zero;
	};
	self.TransformByQuaternion = function(_q) {
		if (_q.type != "Quaternion") return Zero
		var _ix = self.x;
		var _iy = self.y;
		var _iz = 0;

		var _qx = _q.x;
		var _qy = _q.y;
		var _qz = _q.z;
		var _qw = _q.w;

		var _tx = 2 * (_qy * _iz - _qz * _iy);
		var _ty = 2 * (_qz * _ix - _qx * _iz);
		var _tz = 2 * (_qx * _iy - _qy * _ix);

		var _rx = _ix + _qw * _tx + (_qy * _tz - _qz * _ty);
		var _ry = _iy + _qw * _ty + (_qz * _tx - _qx * _tz);

		return new Vector2(_rx, _ry);
	};

	// =============== 静态常量 ===============

	static Zero = new Vector2(0, 0);
	static One = new Vector2(1, 1);
	static Up = new Vector2(0, -1);
	static Down = new Vector2(0, 1);
	static Left = new Vector2(-1, 0);
	static Right = new Vector2(1, 0);
	
	// =============== 静态方法 ===============
	
	/// @func Vector2.Abs(v)
	/// @desc 返回一个新向量，其每个分量为输入向量对应分量的绝对值。
	/// @param {Vector2} v 输入向量
	/// @returns {Vector2}
	static Abs = function(_v) { return _v.Abs(); };
	/// @func Vector2.Add(a, b)
	/// @desc 将两个向量相加。
	/// @param {Vector2} a 第一个向量
	/// @param {Vector2} b 第二个向量
	/// @returns {Vector2}
	static Add = function(_a, _b) { return _a.Add(_b); };
	/// @func Vector2.Subtract(a, b)
	/// @desc 从第一个向量中减去第二个向量。
	/// @param {Vector2} a 被减向量
	/// @param {Vector2} b 减向量
	/// @returns {Vector2}
	static Subtract = function(_a, _b) { return _a.Subtract(_b); };
	/// @func Vector2.Multiply(a, b_or_s)
	/// @desc 向量与标量相乘，或两个向量逐分量相乘。
	/// @param {Vector2} a 第一个向量
	/// @param {Vector2 | Real} b_or_s 第二个向量或标量
	/// @returns {Vector2}
	static Multiply = function(_a, _b) { return _a.Multiply(_b); };
	/// @func Vector2.Divide(a, b_or_s)
	/// @desc 向量除以标量，或逐分量除以另一个向量。
	/// @param {Vector2} a 被除向量
	/// @param {Vector2 | Real} b_or_s 除数
	/// @returns {Vector2}
	static Divide = function(_a, _b) { return _a.Divide(_b); };
	/// @func Vector2.Dot(a, b)
	/// @desc 计算两个向量的点积。
	/// @param {Vector2} a 第一个向量
	/// @param {Vector2} b 第二个向量
	/// @returns {Real}
	static Dot = function(_a, _b) { return _a.Dot(_b); };
	/// @func Vector2.Distance(a, b)
	/// @desc 计算两点间的欧几里得距离。
	/// @param {Vector2} a 第一个点
	/// @param {Vector2} b 第二个点
	/// @returns {Real}
	static Distance = function(_a, _b) { return _a.Subtract(_b).Length(); };
	/// @func Vector2.DistanceSquared(a, b)
	/// @desc 计算两点间距离的平方（避免开方，性能更高）。
	/// @param {Vector2} a 第一个点
	/// @param {Vector2} b 第二个点
	/// @returns {Real}
	static DistanceSquared = function(_a, _b) { return _a.Subtract(_b).LengthSquared(); };
	/// @func Vector2.Length(v)
	/// @desc 获取向量长度。
	/// @param {Vector2} v 输入向量
	/// @returns {Real}
	static Length = function(_v) { return _v.Length(); };
	/// @func Vector2.LengthSquared(v)
	/// @desc 获取向量长度平方。
	/// @param {Vector2} v 输入向量
	/// @returns {Real}
	static LengthSquared = function(_v) { return _v.LengthSquared(); };
	/// @func Vector2.Normalize(v)
	/// @desc 单位化向量。
	/// @param {Vector2} v 输入向量
	/// @returns {Vector2}
	static Normalize = function(_v) { return _v.Normalize(); };
	/// @func Vector2.Negate(v)
	/// @desc 取反向量。
	/// @param {Vector2} v 输入向量
	/// @returns {Vector2}
	static Negate = function(_v) { return _v.Negate(); };
	/// @func Vector2.Clamp(v, min, max)
	/// @desc 限制向量范围。
	/// @param {Vector2} v 输入向量
	/// @param {Vector2} min 最小值
	/// @param {Vector2} max 最大值
	/// @returns {Vector2}
	static Clamp = function(_v, _min, _max) { return _v.Clamp(_min, _max); };
	/// @func Vector2.Lerp(a, b, t)
	/// @desc 线性插值。
	/// @param {Vector2} a 起始向量
	/// @param {Vector2} b 目标向量
	/// @param {Real} t 插值因子 [0,1]
	/// @returns {Vector2}
	static Lerp = function(_a, _b, _t) { return _a.Lerp(_b, _t); };
	/// @func Vector2.Min(a, b)
	/// @desc 各分量取最小值。
	/// @param {Vector2} a 第一个向量
	/// @param {Vector2} b 第二个向量
	/// @returns {Vector2}
	static Min = function(_a, _b) { return _a.Min(_b); };
	/// @func Vector2.Max(a, b)
	/// @desc 各分量取最大值。
	/// @param {Vector2} a 第一个向量
	/// @param {Vector2} b 第二个向量
	/// @returns {Vector2}
	static Max = function(_a, _b) { return _a.Max(_b); };
	/// @func Vector2.SquareRoot(v)
	/// @desc 各分量开平方（负数返回0）。
	/// @param {Vector2} v 输入向量
	/// @returns {Vector2}
	static SquareRoot = function(_v) { return _v.SquareRoot(); };
	/// @func Vector2.Reflect(v, normal)
	/// @desc 计算向量关于法线的反射向量。
	/// @param {Vector2} v 入射向量
	/// @param {Vector2} normal 单位法线向量
	/// @returns {Vector2}
	static Reflect = function(_v, _normal) { return _v.Reflect(_normal); };
	/// @func Vector2.Equals(a, b, tolerance)
	/// @desc 判断两向量是否相等。
	/// @param {Vector2} a 第一个向量
	/// @param {Vector2} b 第二个向量
	/// @param {Real} [tolerance=0.000001] 容差
	/// @returns {Bool}
	static Equals = function(_a, _b, _tolerance = 0.000001) { return _a.Equals(_b, _tolerance); };
	/// @func Vector2.Copy(v)
	/// @desc 创建并返回输入向量的一个副本（新实例）。
	/// @param {Vector2} v 要复制的向量
	/// @returns {Vector2}
	static Copy = function(_v) { return _v.Copy(); };
	/// @func Vector2.Transform(v, transform)
	/// @desc 根据 transform 类型自动选择变换方式：
	/// @desc - 若 transform 为 Matrix3x2：执行 2D 仿射变换；
	/// @desc - 若 transform 为 Matrix4x4：执行 4x4 矩阵变换（齐次坐标）。
	/// @param {Vector2} v 源向量
	/// @param {Struct} transform 变换对象（Matrix3x2 或 Matrix4x4）
	/// @returns {Vector2} 变换后的二维向量
	static Transform = function(_v, _transform) { return _v.Transform(_transform); };
	/// @func Vector2.TransformNormal(v, transform)
	/// @desc 变换法线向量（忽略平移）。
	/// @param {Vector2} v 法线向量
	/// @param {Struct} transform 变换对象（Matrix3x2 或 Matrix4x4）
	/// @returns {Vector2} 变换后的法线
	static TransformNormal = function(_v, _transform) { return _v.TransformNormal(_transform); };
	/// @func Vector2.TransformByQuaternion(v, q)
	/// @desc 将二维向量视为 (x, y, 0) 并应用四元数旋转（结果取 XY）。
	/// @param {Vector2} v 输入向量
	/// @param {Quaternion} q 旋转四元数
	/// @returns {Vector2}
	static TransformByQuaternion = function(_v, _q) { return _v.TransformByQuaternion(_q); };
}