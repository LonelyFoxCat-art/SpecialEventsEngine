/// @func Vector4(x, y, z, w)
/// @desc 四维向量构造器；支持：()→(0,0,0,0)；(s)→(s,s,s,s)；(x,y,z,w)；(Vector2,z,w)；(Vector3,w)。
/// @param {Real | Vector2 | Vector3} [x=0] X分量 或 Vector2/Vector3 对象
/// @param {Real} [y=0] Y分量（若x为Vector2，则此为Z）
/// @param {Real} [z=0] Z分量（若x为Vector2，则此为W）
/// @param {Real} [w=0] W分量
/// @returns {Vector4}
function Vector4(_x = undefined, _y = undefined, _z = undefined, _w = undefined) constructor {
	self.type = "Vector4";

	if (is_undefined(_x)) {
		self.x = 0; self.y = 0; self.z = 0; self.w = 0;
	} else if (is_real(_x)) {
		if (is_undefined(_y)) {
			self.x = _x; self.y = _x; self.z = _x; self.w = _x;
		} else {
			self.x = _x; self.y = _y; self.z = _z; self.w = _w;
		}
	} else if (is_struct(_x)) {
		if (_x.type == "Vector2") {
			self.x = _x.x;
			self.y = _x.y;
			self.z = _y;
			self.w = _z;
		} else if (_x.type == "Vector3") {
			self.x = _x.x;
			self.y = _x.y;
			self.z = _x.z;
			self.w = _y;
		} else {
			self.x = 0; self.y = 0; self.z = 0; self.w = 0;
		}
	} else {
		self.x = 0; self.y = 0; self.z = 0; self.w = 0;
	}

	// =============== 实例方法 ===============
	
	self.Abs = function() {
		return new Vector4(abs(self.x), abs(self.y), abs(self.z), abs(self.w));
	};
	self.Add = function(_v) {
		return new Vector4(self.x + _v.x, self.y + _v.y, self.z + _v.z, self.w + _v.w);
	};
	self.Subtract = function(_v) {
		return new Vector4(self.x - _v.x, self.y - _v.y, self.z - _v.z, self.w - _v.w);
	};
	self.Multiply = function(_arg) {
		if (is_struct(_arg) && _arg.type == "Vector4") {
			return new Vector4(self.x * _arg.x, self.y * _arg.y, self.z * _arg.z, self.w * _arg.w);
		} else {
			var _s = _arg;
			return new Vector4(self.x * _s, self.y * _s, self.z * _s, self.w * _s);
		}
	};
	self.Divide = function(_arg) {
		if (is_struct(_arg) && _arg.type == "Vector4") {
			return new Vector4(self.x / _arg.x, self.y / _arg.y, self.z / _arg.z, self.w / _arg.w);
		} else {
			var _s = _arg;
			if (_s == 0) _s = 0.000001;
			return new Vector4(self.x / _s, self.y / _s, self.z / _s, self.w / _s);
		}
	};
	self.Dot = function(_v) {
		return self.x * _v.x + self.y * _v.y + self.z * _v.z + self.w * _v.w;
	};
	self.Length = function() {
		return sqrt(self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w);
	};
	self.LengthSquared = function() {
		return self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w;
	};
	self.Normalize = function() {
		var _len = self.Length();
		if (_len == 0) return new Vector4(0, 0, 0, 0);
		var _inv = 1 / _len;
		return new Vector4(self.x * _inv, self.y * _inv, self.z * _inv, self.w * _inv);
	};
	self.Negate = function() {
		return new Vector4(-self.x, -self.y, -self.z, -self.w);
	};
	self.Clamp = function(_min, _max) {
		return new Vector4(
			clamp(self.x, _min.x, _max.x),
			clamp(self.y, _min.y, _max.y),
			clamp(self.z, _min.z, _max.z),
			clamp(self.w, _min.w, _max.w)
		);
	};
	self.Lerp = function(_v, _t) {
		var _t_clamped = clamp(_t, 0, 1);
		return new Vector4(
			self.x + _t_clamped * (_v.x - self.x),
			self.y + _t_clamped * (_v.y - self.y),
			self.z + _t_clamped * (_v.z - self.z),
			self.w + _t_clamped * (_v.w - self.w)
		);
	};
	self.Min = function(_v) {
		return new Vector4(
			min(self.x, _v.x),
			min(self.y, _v.y),
			min(self.z, _v.z),
			min(self.w, _v.w)
		);
	};
	self.Max = function(_v) {
		return new Vector4(
			max(self.x, _v.x),
			max(self.y, _v.y),
			max(self.z, _v.z),
			max(self.w, _v.w)
		);
	};
	self.SquareRoot = function() {
		return new Vector4(
			(self.x >= 0) ? sqrt(self.x) : 0,
			(self.y >= 0) ? sqrt(self.y) : 0,
			(self.z >= 0) ? sqrt(self.z) : 0,
			(self.w >= 0) ? sqrt(self.w) : 0
		);
	};
	self.Equals = function(_v, _tolerance = 0.000001) {
		return (
			abs(self.x - _v.x) <= _tolerance &&
			abs(self.y - _v.y) <= _tolerance &&
			abs(self.z - _v.z) <= _tolerance &&
			abs(self.w - _v.w) <= _tolerance
		);
	};
	self.ToString = function() {
		return "Vector4(" + string(self.x) + ", " + string(self.y) + ", " + string(self.z) + ", " + string(self.w) + ")";
	};
	self.Copy = function() {
		return new Vector4(self.x, self.y, self.z, self.w);
	};
	self.Transform = function(_value, _transform) {
		if (!is_struct(_value) || !is_struct(_transform)) {
			return new Vector4();
		}

		if (_transform.type == "Matrix4x4") {
			// 矩阵变换
			if (_value.type == "Vector2") {
				var _x = _transform.m00 * _value.x + _transform.m01 * _value.y + _transform.m02 * 0 + _transform.m03 * 1;
				var _y = _transform.m10 * _value.x + _transform.m11 * _value.y + _transform.m12 * 0 + _transform.m13 * 1;
				var _z = _transform.m20 * _value.x + _transform.m21 * _value.y + _transform.m22 * 0 + _transform.m23 * 1;
				var _w = _transform.m30 * _value.x + _transform.m31 * _value.y + _transform.m32 * 0 + _transform.m33 * 1;
				return new Vector4(_x, _y, _z, _w);
			} else if (_value.type == "Vector3") {
				var _x = _transform.m00 * _value.x + _transform.m01 * _value.y + _transform.m02 * _value.z + _transform.m03 * 1;
				var _y = _transform.m10 * _value.x + _transform.m11 * _value.y + _transform.m12 * _value.z + _transform.m13 * 1;
				var _z = _transform.m20 * _value.x + _transform.m21 * _value.y + _transform.m22 * _value.z + _transform.m23 * 1;
				var _w = _transform.m30 * _value.x + _transform.m31 * _value.y + _transform.m32 * _value.z + _transform.m33 * 1;
				return new Vector4(_x, _y, _z, _w);
			} else if (_value.type == "Vector4") {
				var _x = _transform.m00 * _value.x + _transform.m01 * _value.y + _transform.m02 * _value.z + _transform.m03 * _value.w;
				var _y = _transform.m10 * _value.x + _transform.m11 * _value.y + _transform.m12 * _value.z + _transform.m13 * _value.w;
				var _z = _transform.m20 * _value.x + _transform.m21 * _value.y + _transform.m22 * _value.z + _transform.m23 * _value.w;
				var _w = _transform.m30 * _value.x + _transform.m31 * _value.y + _transform.m32 * _value.z + _transform.m33 * _value.w;
				return new Vector4(_x, _y, _z, _w);
			} else {
				return new Vector4();
			}
		} else if (_transform.type == "Quaternion") {
			// 四元数旋转
			var _ix, _iy, _iz, _iw;
			if (_value.type == "Vector2") {
				_ix = _value.x; _iy = _value.y; _iz = 0; _iw = 1;
			} else if (_value.type == "Vector3") {
				_ix = _value.x; _iy = _value.y; _iz = _value.z; _iw = 1;
			} else if (_value.type == "Vector4") {
				_ix = _value.x; _iy = _value.y; _iz = _value.z; _iw = _value.w;
			} else {
				return new Vector4();
			}

			var _qx = _transform.x;
			var _qy = _transform.y;
			var _qz = _transform.z;
			var _qw = _transform.w;

			var _tx = 2 * (_qy * _iz - _qz * _iy);
			var _ty = 2 * (_qz * _ix - _qx * _iz);
			var _tz = 2 * (_qx * _iy - _qy * _ix);

			var _rx = _ix + _qw * _tx + (_qy * _tz - _qz * _ty);
			var _ry = _iy + _qw * _ty + (_qz * _tx - _qx * _tz);
			var _rz = _iz + _qw * _tz + (_qx * _ty - _qy * _tx);

			return new Vector4(_rx, _ry, _rz, _iw);
		} else {
			return new Vector4();
		}
	};

	// =============== 静态常量 ===============
	
	static Zero = new Vector4(0, 0, 0, 0);
	static One = new Vector4(1, 1, 1, 1);
	static UnitX = new Vector4(1, 0, 0, 0);
	static UnitY = new Vector4(0, 1, 0, 0);
	static UnitZ = new Vector4(0, 0, 1, 0);
	static UnitW = new Vector4(0, 0, 0, 1);

	// =============== 静态方法 ===============

	/// @func Vector4.Abs(v)
	/// @desc 返回一个新向量，其每个分量为输入向量对应分量的绝对值。
	/// @param {Vector4} v 输入向量
	/// @returns {Vector4}
	static Abs = function(_v) { return _v.Abs(); };
	/// @func Vector4.Add(a, b)
	/// @desc 将两个向量相加。
	/// @param {Vector4} a 第一个向量
	/// @param {Vector4} b 第二个向量
	/// @returns {Vector4}
	static Add = function(_a, _b) { return _a.Add(_b); };
	/// @func Vector4.Subtract(a, b)
	/// @desc 从第一个向量中减去第二个向量。
	/// @param {Vector4} a 被减向量
	/// @param {Vector4} b 减向量
	/// @returns {Vector4}
	static Subtract = function(_a, _b) { return _a.Subtract(_b); };
	/// @func Vector4.Multiply(a, b_or_s)
	/// @desc 向量与标量相乘，或两个向量逐分量相乘。
	/// @param {Vector4} a 第一个向量
	/// @param {Vector4 | Real} b_or_s 第二个向量或标量
	/// @returns {Vector4}
	static Multiply = function(_a, _b) { return _a.Multiply(_b); };
	/// @func Vector4.Divide(a, b_or_s)
	/// @desc 向量除以标量，或逐分量除以另一个向量。
	/// @param {Vector4} a 被除向量
	/// @param {Vector4 | Real} b_or_s 除数
	/// @returns {Vector4}
	static Divide = function(_a, _b) { return _a.Divide(_b); };
	/// @func Vector4.Dot(a, b)
	/// @desc 计算两个向量的点积。
	/// @param {Vector4} a 第一个向量
	/// @param {Vector4} b 第二个向量
	/// @returns {Real}
	static Dot = function(_a, _b) { return _a.Dot(_b); };
	/// @func Vector4.Distance(a, b)
	/// @desc 计算两点间的欧几里得距离。
	/// @param {Vector4} a 第一个点
	/// @param {Vector4} b 第二个点
	/// @returns {Real}
	static Distance = function(_a, _b) { return _a.Subtract(_b).Length(); };
	/// @func Vector4.DistanceSquared(a, b)
	/// @desc 计算两点间距离的平方（避免开方，性能更高）。
	/// @param {Vector4} a 第一个点
	/// @param {Vector4} b 第二个点
	/// @returns {Real}
	static DistanceSquared = function(_a, _b) { return _a.Subtract(_b).LengthSquared(); };
	/// @func Vector4.Length(v)
	/// @desc 获取向量长度。
	/// @param {Vector4} v 输入向量
	/// @returns {Real}
	static Length = function(_v) { return _v.Length(); };
	/// @func Vector4.LengthSquared(v)
	/// @desc 获取向量长度平方。
	/// @param {Vector4} v 输入向量
	/// @returns {Real}
	static LengthSquared = function(_v) { return _v.LengthSquared(); };
	/// @func Vector4.Normalize(v)
	/// @desc 单位化向量。
	/// @param {Vector4} v 输入向量
	/// @returns {Vector4}
	static Normalize = function(_v) { return _v.Normalize(); };
	/// @func Vector4.Negate(v)
	/// @desc 取反向量。
	/// @param {Vector4} v 输入向量
	/// @returns {Vector4}
	static Negate = function(_v) { return _v.Negate(); };
	/// @func Vector4.Clamp(v, min, max)
	/// @desc 限制向量范围。
	/// @param {Vector4} v 输入向量
	/// @param {Vector4} min 最小值
	/// @param {Vector4} max 最大值
	/// @returns {Vector4}
	static Clamp = function(_v, _min, _max) { return _v.Clamp(_min, _max); };
	/// @func Vector4.Lerp(a, b, t)
	/// @desc 线性插值。
	/// @param {Vector4} a 起始向量
	/// @param {Vector4} b 目标向量
	/// @param {Real} t 插值因子 [0,1]
	/// @returns {Vector4}
	static Lerp = function(_a, _b, _t) { return _a.Lerp(_b, _t); };
	/// @func Vector4.Min(a, b)
	/// @desc 各分量取最小值。
	/// @param {Vector4} a 第一个向量
	/// @param {Vector4} b 第二个向量
	/// @returns {Vector4}
	static Min = function(_a, _b) { return _a.Min(_b); };
	/// @func Vector4.Max(a, b)
	/// @desc 各分量取最大值。
	/// @param {Vector4} a 第一个向量
	/// @param {Vector4} b 第二个向量
	/// @returns {Vector4}
	static Max = function(_a, _b) { return _a.Max(_b); };
	/// @func Vector4.SquareRoot(v)
	/// @desc 各分量开平方（负数返回0）。
	/// @param {Vector4} v 输入向量
	/// @returns {Vector4}
	static SquareRoot = function(_v) { return _v.SquareRoot(); };
	/// @func Vector4.Equals(a, b, tolerance)
	/// @desc 判断两向量是否相等。
	/// @param {Vector4} a 第一个向量
	/// @param {Vector4} b 第二个向量
	/// @param {Real} [tolerance=0.000001] 容差
	/// @returns {Bool}
	static Equals = function(_a, _b, _tolerance = 0.000001) { return _a.Equals(_b, _tolerance); };
	/// @func Vector4.Copy(v)
	/// @desc 创建并返回输入向量的一个副本（新实例）。
	/// @param {Vector4} v 要复制的向量
	/// @returns {Vector4}
	static Copy = function(_v) { return _v.Copy(); };
	/// @func Vector4.Reflect(v, normal)
	/// @desc 计算向量关于法线的反射向量（normal 应为单位向量）。
	/// @param {Vector4} v 入射向量
	/// @param {Vector4} normal 单位法线向量
	/// @returns {Vector4}
	static Reflect = function(_v, _normal) {
		var dot = _v.Dot(_normal);
		return _v.Subtract(_normal.Multiply(2 * dot));
	};
	/// @func Vector4.Transform(value, transform)
	/// @desc 自动变换 Vector2/3/4；若 transform 为 Matrix4x4 则矩阵变换，若为 Quaternion 则四元数旋转。
	/// @param {Vector2 | Vector3 | Vector4} value 源向量
	/// @param {Struct} transform 变换对象（Matrix4x4 或 Quaternion）
	/// @returns {Vector4}
	static Transform = function(_value, _transform) { return self.Transform(_value, _transform); };
}