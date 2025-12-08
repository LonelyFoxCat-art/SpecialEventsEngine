/// @func Vector3(x, y, z)
/// @desc 三维向量构造器；支持：()→(0,0,0)；(s)→(s,s,s)；(x,y,z)；(Vector2,z)。
/// @param {Real | Vector2} [x=0] X分量 或 Vector2 对象
/// @param {Real} [y=0] Y分量（若x为Vector2，则此为Z）
/// @param {Real} [z=0] Z分量
/// @returns {Vector3}
function Vector3(_x = undefined, _y = undefined, _z = undefined) constructor {
	self.type = "Vector3";
	
	if (is_undefined(_x)) {
		self.x = 0; self.y = 0; self.z = 0;
	} else if (is_real(_x)) {
		if (is_undefined(_y)) {
			self.x = _x; self.y = _x; self.z = _x;
		} else {
			self.x = _x; self.y = _y; self.z = _z;
		}
	} else if (is_struct(_x) && _x.type == "Vector2") {
		self.x = _x.x;
		self.y = _x.y;
		self.z = _y;
	} else {
		self.x = 0; self.y = 0; self.z = 0;
	}

	// =============== 实例方法 ===============
	
	self.Abs = function() {
		return new Vector3(abs(self.x), abs(self.y), abs(self.z));
	};
	self.Add = function(_v) {
		return new Vector3(self.x + _v.x, self.y + _v.y, self.z + _v.z);
	};
	self.Subtract = function(_v) {
		return new Vector3(self.x - _v.x, self.y - _v.y, self.z - _v.z);
	};
	self.Multiply = function(_arg) {
		if (is_struct(_arg) && _arg.type == "Vector3") {
			return new Vector3(self.x * _arg.x, self.y * _arg.y, self.z * _arg.z);
		} else {
			var _s = _arg;
			return new Vector3(self.x * _s, self.y * _s, self.z * _s);
		}
	};
	self.Divide = function(_arg) {
		if (is_struct(_arg) && _arg.type == "Vector3") {
			return new Vector3(self.x / _arg.x, self.y / _arg.y, self.z / _arg.z);
		} else {
			var _s = _arg;
			if (_s == 0) _s = 0.000001;
			return new Vector3(self.x / _s, self.y / _s, self.z / _s);
		}
	};
	self.Dot = function(_v) {
		return self.x * _v.x + self.y * _v.y + self.z * _v.z;
	};
	self.Cross = function(_v) {
		var _x = self.y * _v.z - self.z * _v.y;
		var _y = self.z * _v.x - self.x * _v.z;
		var _z = self.x * _v.y - self.y * _v.x;
		return new Vector3(_x, _y, _z);
	};
	self.Length = function() {
		return sqrt(self.x * self.x + self.y * self.y + self.z * self.z);
	};
	self.LengthSquared = function() {
		return self.x * self.x + self.y * self.y + self.z * self.z;
	};
	self.Normalize = function() {
		var _len = self.Length();
		if (_len == 0) return new Vector3(0, 0, 0);
		var _inv = 1 / _len;
		return new Vector3(self.x * _inv, self.y * _inv, self.z * _inv);
	};
	self.Negate = function() {
		return new Vector3(-self.x, -self.y, -self.z);
	};
	self.Project = function(_onto) {
		var dot = self.Dot(_onto);
		var lenSq = _onto.LengthSquared();
		if (lenSq < 0.000001) return Vector3.Zero;
		return _onto.Multiply(dot / lenSq);
	};
	self.Reject = function(_onto) {
		return self.Subtract(self.Project(_onto));
	};
	self.Angle = function(_other) {
		var lenA = self.Length();
		var lenB = _other.Length();
		if (lenA < 0.000001 || lenB < 0.000001) return 0;
		var _cos = self.Dot(_other) / (lenA * lenB);
		return arccos(clamp(_cos, -1, 1));
	};
	self.SignedAngle = function(_other, _axis) {
		var unsignedAngle = self.Angle(_other);
		var cross = self.Cross(_other);
		var _sign = cross.Dot(_axis) >= 0 ? 1 : -1;
		return _sign * unsignedAngle;
	};
	self.Clamp = function(_min, _max) {
		return new Vector3(
			clamp(self.x, _min.x, _max.x),
			clamp(self.y, _min.y, _max.y),
			clamp(self.z, _min.z, _max.z)
		);
	};
	self.Lerp = function(_v, _t) {
		var _t_clamped = clamp(_t, 0, 1);
		return new Vector3(
			self.x + _t_clamped * (_v.x - self.x),
			self.y + _t_clamped * (_v.y - self.y),
			self.z + _t_clamped * (_v.z - self.z)
		);
	};
	self.Min = function(_v) {
		return new Vector3(min(self.x, _v.x), min(self.y, _v.y), min(self.z, _v.z));
	};
	self.Max = function(_v) {
		return new Vector3(max(self.x, _v.x), max(self.y, _v.y), max(self.z, _v.z));
	};
	self.SquareRoot = function() {
		return new Vector3(
			(self.x >= 0) ? sqrt(self.x) : 0,
			(self.y >= 0) ? sqrt(self.y) : 0,
			(self.z >= 0) ? sqrt(self.z) : 0
		);
	};
	self.Reflect = function(_normal) {
		var _dot = self.Dot(_normal);
		return self.Subtract(_normal.Multiply(2 * _dot));
	};
	self.Equals = function(_v, _tolerance = 0.000001) {
		return (
			abs(self.x - _v.x) <= _tolerance &&
			abs(self.y - _v.y) <= _tolerance &&
			abs(self.z - _v.z) <= _tolerance
		);
	};
	self.ToString = function() {
		return "Vector3(" + string(self.x) + ", " + string(self.y) + ", " + string(self.z) + ")";
	};
	self.Copy = function() {
		return new Vector3(self.x, self.y, self.z);
	};
	self.Transform = function(_mat) {
		if (_mat.type == "Matrix4x4") {
			var _x = self.x * _mat.m00 + self.y * _mat.m10 + self.z * _mat.m20 + _mat.m30;
			var _y = self.x * _mat.m01 + self.y * _mat.m11 + self.z * _mat.m21 + _mat.m31;
			var _z = self.x * _mat.m02 + self.y * _mat.m12 + self.z * _mat.m22 + _mat.m32;
			var _w = self.x * _mat.m03 + self.y * _mat.m13 + self.z * _mat.m23 + _mat.m33;
			if (_w != 0) {
				_x /= _w;
				_y /= _w;
				_z /= _w;
			}
			return new Vector3(_x, _y, _z);
		}
		return Zero;
	};
	self.TransformNormal = function(_mat) {
		if (_mat.type == "Matrix4x4") {
			var _x = self.x * _mat.m00 + self.y * _mat.m10 + self.z * _mat.m20;
			var _y = self.x * _mat.m01 + self.y * _mat.m11 + self.z * _mat.m21;
			var _z = self.x * _mat.m02 + self.y * _mat.m12 + self.z * _mat.m22;
			return new Vector3(_x, _y, _z);
		}
		return Zero;
	};
	self.TransformQuaternion = function(_q) {
		if (_q.type != "Quaternion") return Zero
		var _ix = self.x, _iy = self.y, _iz = self.z;
		var _qx = _q.x, _qy = _q.y, _qz = _q.z, _qw = _q.w;

		// 计算 t = 2 * cross(q.xyz, v)
		var _tx = 2 * (_qy * _iz - _qz * _iy);
		var _ty = 2 * (_qz * _ix - _qx * _iz);
		var _tz = 2 * (_qx * _iy - _qy * _ix);

		// v' = v + qw * t + cross(q.xyz, t)
		var _rx = _ix + _qw * _tx + (_qy * _tz - _qz * _ty);
		var _ry = _iy + _qw * _ty + (_qz * _tx - _qx * _tz);
		var _rz = _iz + _qw * _tz + (_qx * _ty - _qy * _tx);

		return new Vector3(_rx, _ry, _rz);
	};

	// =============== 静态常量 ===============
	
	static Zero = new Vector3(0, 0, 0);
	static One = new Vector3(1, 1, 1);
	static UnitX = new Vector3(1, 0, 0);
	static UnitY = new Vector3(0, 1, 0);
	static UnitZ = new Vector3(0, 0, 1);
	static Up = new Vector3(0, 1, 0);
	static Down = new Vector3(0, -1, 0);
	static Forward = new Vector3(0, 0, 1);
	static Backward = new Vector3(0, 0, -1);
	static Left = new Vector3(-1, 0, 0);
	static Right = new Vector3(1, 0, 0);

	// =============== 静态方法 ===============
	
	/// @func Vector3.Abs(v)
	/// @desc 返回一个新向量，其每个分量为输入向量对应分量的绝对值。
	/// @param {Vector3} v 输入向量
	/// @returns {Vector3}
	static Abs = function(_v) { return _v.Abs(); };
	/// @func Vector3.Add(a, b)
	/// @desc 将两个向量相加。
	/// @param {Vector3} a 第一个向量
	/// @param {Vector3} b 第二个向量
	/// @returns {Vector3}
	static Add = function(_a, _b) { return _a.Add(_b); };
	/// @func Vector3.Subtract(a, b)
	/// @desc 从第一个向量中减去第二个向量。
	/// @param {Vector3} a 被减向量
	/// @param {Vector3} b 减向量
	/// @returns {Vector3}
	static Subtract = function(_a, _b) { return _a.Subtract(_b); };
	/// @func Vector3.Multiply(a, b_or_s)
	/// @desc 向量与标量相乘，或两个向量逐分量相乘。
	/// @param {Vector3} a 第一个向量
	/// @param {Vector3 | Real} b_or_s 第二个向量或标量
	/// @returns {Vector3}
	static Multiply = function(_a, _b) { return _a.Multiply(_b); };
	/// @func Vector3.Divide(a, b_or_s)
	/// @desc 向量除以标量，或逐分量除以另一个向量。
	/// @param {Vector3} a 被除向量
	/// @param {Vector3 | Real} b_or_s 除数
	/// @returns {Vector3}
	static Divide = function(_a, _b) { return _a.Divide(_b); };
	/// @func Vector3.Dot(a, b)
	/// @desc 计算两个向量的点积。
	/// @param {Vector3} a 第一个向量
	/// @param {Vector3} b 第二个向量
	/// @returns {Real}
	static Dot = function(_a, _b) { return _a.Dot(_b); };
	/// @func Vector3.Cross(a, b)
	/// @desc 计算两个三维向量的叉积（右手定则）。
	/// @param {Vector3} a 第一个向量
	/// @param {Vector3} b 第二个向量
	/// @returns {Vector3}
	static Cross = function(_a, _b) { return _a.Cross(_b); };
	/// @func Vector3.Distance(a, b)
	/// @desc 计算两点间的欧几里得距离。
	/// @param {Vector3} a 第一个点
	/// @param {Vector3} b 第二个点
	/// @returns {Real}
	static Distance = function(_a, _b) { return _a.Subtract(_b).Length(); };
	/// @func Vector3.DistanceSquared(a, b)
	/// @desc 计算两点间距离的平方（避免开方，性能更高）。
	/// @param {Vector3} a 第一个点
	/// @param {Vector3} b 第二个点
	/// @returns {Real}
	static DistanceSquared = function(_a, _b) { return _a.Subtract(_b).LengthSquared(); };
	/// @func Vector3.Length(v)
	/// @desc 获取向量长度。
	/// @param {Vector3} v 输入向量
	/// @returns {Real}
	static Length = function(_v) { return _v.Length(); };
	/// @func Vector3.LengthSquared(v)
	/// @desc 获取向量长度平方。
	/// @param {Vector3} v 输入向量
	/// @returns {Real}
	static LengthSquared = function(_v) { return _v.LengthSquared(); };
	/// @func Vector3.Normalize(v)
	/// @desc 单位化向量。
	/// @param {Vector3} v 输入向量
	/// @returns {Vector3}
	static Normalize = function(_v) { return _v.Normalize(); };
	/// @func Vector3.Negate(v)
	/// @desc 取反向量。
	/// @param {Vector3} v 输入向量
	/// @returns {Vector3}
	static Negate = function(_v) { return _v.Negate(); };
	/// @func Vector3.Project(v, onto)
	/// @desc 返回向量 v 在 onto 方向上的投影。
	/// @param {Vector3} v 被投影向量
	/// @param {Vector3} onto 投影方向
	/// @returns {Vector3}
	static Project = function(_v, _onto) { return _v.Project(_onto); };

	/// @func Vector3.Reject(v, onto)
	/// @desc 返回向量 v 垂直于 onto 的分量。
	/// @param {Vector3} v 输入向量
	/// @param {Vector3} onto 参考方向
	/// @returns {Vector3}
	static Reject = function(_v, _onto) { return _v.Reject(_onto); };

	/// @func Vector3.Angle(a, b)
	/// @desc 计算两个向量之间的夹角（弧度）。
	/// @param {Vector3} a 第一个向量
	/// @param {Vector3} b 第二个向量
	/// @returns {Real}
	static Angle = function(_a, _b) { return _a.Angle(_b); };

	/// @func Vector3.SignedAngle(from, to, axis)
	/// @desc 计算 from 到 to 绕 axis 的有符号角度（弧度）。
	/// @param {Vector3} from 起始向量
	/// @param {Vector3} to 目标向量
	/// @param {Vector3} axis 旋转轴
	/// @returns {Real}
	static SignedAngle = function(_from, _to, _axis) { return _from.SignedAngle(_to, _axis); };
	/// @func Vector3.Clamp(v, min, max)
	/// @desc 限制向量范围。
	/// @param {Vector3} v 输入向量
	/// @param {Vector3} min 最小值
	/// @param {Vector3} max 最大值
	/// @returns {Vector3}
	static Clamp = function(_v, _min, _max) { return _v.Clamp(_min, _max); };
	/// @func Vector3.Lerp(a, b, t)
	/// @desc 线性插值。
	/// @param {Vector3} a 起始向量
	/// @param {Vector3} b 目标向量
	/// @param {Real} t 插值因子 [0,1]
	/// @returns {Vector3}
	static Lerp = function(_a, _b, _t) { return _a.Lerp(_b, _t); };
	/// @func Vector3.Min(a, b)
	/// @desc 各分量取最小值。
	/// @param {Vector3} a 第一个向量
	/// @param {Vector3} b 第二个向量
	/// @returns {Vector3}
	static Min = function(_a, _b) { return _a.Min(_b); };
	/// @func Vector3.Max(a, b)
	/// @desc 各分量取最大值。
	/// @param {Vector3} a 第一个向量
	/// @param {Vector3} b 第二个向量
	/// @returns {Vector3}
	static Max = function(_a, _b) { return _a.Max(_b); };
	/// @func Vector3.SquareRoot(v)
	/// @desc 各分量开平方（负数返回0）。
	/// @param {Vector3} v 输入向量
	/// @returns {Vector3}
	static SquareRoot = function(_v) { return _v.SquareRoot(); };
	/// @func Vector3.Reflect(v, normal)
	/// @desc 计算向量关于法线的反射向量（法线应为单位向量）。
	/// @param {Vector3} v 入射向量
	/// @param {Vector3} normal 单位法线向量
	/// @returns {Vector3}
	static Reflect = function(_v, _normal) { return _v.Reflect(_normal); };
	/// @func Vector3.Equals(a, b, tolerance)
	/// @desc 判断两向量是否相等。
	/// @param {Vector3} a 第一个向量
	/// @param {Vector3} b 第二个向量
	/// @param {Real} [tolerance=0.000001] 容差
	/// @returns {Bool}
	static Equals = function(_a, _b, _tolerance = 0.000001) { return _a.Equals(_b, _tolerance); };
	/// @func Vector3.Copy(v)
	/// @desc 创建并返回输入向量的一个副本（新实例）。
	/// @param {Vector3} v 要复制的向量
	/// @returns {Vector3}
	static Copy = function(_v) { return _v.Copy(); };
	/// @func Vector3.Transform(v, transform)
	/// @desc 自动变换 Vector3；若 transform 为 Matrix4x4 则矩阵变换（齐次坐标），若为 Quaternion 则四元数旋转。
	/// @param {Vector3} v 源向量
	/// @param {Struct} transform 变换对象（Matrix4x4 或 Quaternion）
	/// @returns {Vector3}
	static Transform = function(_v, _mat) { return _v.Transform(_mat); };
	/// @func Vector3.TransformQuaternion(v, q)
	/// @desc 将三维向量应用四元数旋转。
	/// @param {Vector3} v 输入向量
	/// @param {Quaternion} q 旋转四元数
	/// @returns {Vector3}
	static TransformQuaternion = function(_v, _q) { return _v.TransformQuaternion(_q); };
	/// @func Vector3.TransformNormal(v, matrix)
	/// @desc 变换法线向量（忽略平移，适用于 Matrix4x4）。
	/// @param {Vector3} v 法线向量
	/// @param {Matrix4x4} matrix 变换矩阵
	/// @returns {Vector3}
	static TransformNormal = function(_v, _mat) { return _v.TransformNormal(_mat); };
}