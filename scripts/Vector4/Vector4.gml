/// @func Vector4(x, y, z, w)
/// @desc 创建一个四维向量（Vector4）实例，支持多种构造方式（标量、Vector2、Vector3、Vector4），并提供丰富的向量运算方法
/// @arg {real|Vector2|Vector3|Vector4} x - X 分量，或作为整体输入的向量（若为数值则 y/z/w 可选，否则 y/z 用于补全 w 分量）
/// @arg {real} y - Y 分量（当 x 为数值时）或 W 分量（当 x 为 Vector2/Vector3 时）
/// @arg {real} z - Z 分量（当 x 为数值时）或被忽略（当 x 为 Vector2/Vector3/Vector4 时）
/// @arg {real} w - W 分量（当 x 为数值时）
/// @returns {struct} 包含 x/y/z/w 属性及一系列向量运算方法的 Vector4 结构体
Vector4()
function Vector4(x = 0, y = 0, z = 0, w = 0) {
	var Vector4Struct = {
		type: "Vector4",
		x: x,
		y: y,
		z: z,
		w: w,
		
		#region 实例方法
		Abs: function() {
			return Vector4(abs(self.x), abs(self.y), abs(self.z), abs(self.w));
		},
		Add: function(vec) {
			if (is_real(vec)) return Vector4(self.x + vec, self.y + vec, self.z + vec, self.w + vec);
			return Vector4(self.x + vec.x, self.y + vec.y, self.z + vec.z, self.w + vec.w);
		},
		Subtract: function(vec) {
			if (is_real(vec)) return Vector4(self.x - vec, self.y - vec, self.z - vec, self.w - vec);
			return Vector4(self.x - vec.x, self.y - vec.y, self.z - vec.z, self.w - vec.w);
		},
		Multiply: function(vec) {
			if (is_real(vec)) return Vector4(self.x * vec, self.y * vec, self.z * vec, self.w * vec);
			return Vector4(self.x * vec.x, self.y * vec.y, self.z * vec.z, self.w * vec.w);
		},
		Divide: function(vec) {
			if (is_real(vec)) {
				if (vec == 0) vec = 0.000001;
				return Vector4(self.x / vec, self.y / vec, self.z / vec, self.w / vec);
			}
			return Vector4(self.x / vec.x, self.y / vec.y, self.z / vec.z, self.w / vec.w);
		},
		Dot: function(vec) {
			return self.x * vec.x + self.y * vec.y + self.z * vec.z + self.w * vec.w;
		},
		Length: function() {
			return sqrt(self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w);
		},
		LengthSquared: function() {
			return self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w;
		},
		Normalize: function() {
			var _len = self.Length();
			if (_len == 0) return Vector4(0, 0, 0, 0);
			var _inv = 1 / _len;
			return Vector4(self.x * _inv, self.y * _inv, self.z * _inv, self.w * _inv);
		},
		Negate: function() {
			return Vector4(-self.x, -self.y, -self.z, -self.w);
		},
		Clamp: function(_min, _max) {
			return Vector4(
				clamp(self.x, _min.x, _max.x),
				clamp(self.y, _min.y, _max.y),
				clamp(self.z, _min.z, _max.z),
				clamp(self.w, _min.w, _max.w)
			);
		},
		Lerp: function(vec, _t) {
			var _t_clamped = clamp(_t, 0, 1);
			return Vector4(
				self.x + _t_clamped * (vec.x - self.x),
				self.y + _t_clamped * (vec.y - self.y),
				self.z + _t_clamped * (vec.z - self.z),
				self.w + _t_clamped * (vec.w - self.w)
			);
		},
		Min: function(vec) {
			return Vector4(
				min(self.x, vec.x),
				min(self.y, vec.y),
				min(self.z, vec.z),
				min(self.w, vec.w)
			);
		},
		Max: function(vec) {
			return Vector4(
				max(self.x, vec.x),
				max(self.y, vec.y),
				max(self.z, vec.z),
				max(self.w, vec.w)
			);
		},
		Reflect: function(normal) {
			var dot = self.Dot(normal);
			return self.Subtract(normal.Multiply(2 * dot));
		},
		SquareRoot: function() {
			return Vector4(
				(self.x >= 0) ? sqrt(self.x) : 0,
				(self.y >= 0) ? sqrt(self.y) : 0,
				(self.z >= 0) ? sqrt(self.z) : 0,
				(self.w >= 0) ? sqrt(self.w) : 0
			);
		},
		Equals: function(vec, _tolerance = 0.000001) {
			return (
				abs(self.x - vec.x) <= _tolerance &&
				abs(self.y - vec.y) <= _tolerance &&
				abs(self.z - vec.z) <= _tolerance &&
				abs(self.w - vec.w) <= _tolerance
			);
		},
		ToString: function() {
			return "Vector4(" + string(self.x) + ", " + string(self.y) + ", " + string(self.z) + ", " + string(self.w) + ")";
		},
		Copy: function() {
			return Vector4(self.x, self.y, self.z, self.w);
		},
		Transform: function(trans) {
			if (is_matrix4x4(trans)) {
				var _x = trans.m00 * self.x + trans.m01 * self.y + trans.m02 * self.z + trans.m03 * self.w;
				var _y = trans.m10 * self.x + trans.m11 * self.y + trans.m12 * self.z + trans.m13 * self.w;
				var _z = trans.m20 * self.x + trans.m21 * self.y + trans.m22 * self.z + trans.m23 * self.w;
				var _w = trans.m30 * self.x + trans.m31 * self.y + trans.m32 * self.z + trans.m33 * self.w;
				return Vector4(_x, _y, _z, _w);
			} else if (is_quat(trans)) {
				var _qx = trans.x;
				var _qy = trans.y;
				var _qz = trans.z;
				var _qw = trans.w;
		
				var _tx = 2 * (_qy * self.z - _qz * self.y);
				var _ty = 2 * (_qz * self.x - _qx * self.z);
				var _tz = 2 * (_qx * self.y - _qy * self.x);
		
				var _rx = self.x + _qw * _tx + (_qy * _tz - _qz * _ty);
				var _ry = self.y + _qw * _ty + (_qz * _tx - _qx * _tz);
				var _rz = self.z + _qw * _tz + (_qx * _ty - _qy * _tx);
				
				return Vector4(_rx, _ry, _rz, self.w);
			} else if (is_vec3(trans)) {
				return Vector4(self.x + trans.x, self.y + trans.y, self.z + trans.z, self.w);
			} else if (is_vec2(trans)) {
				return Vector4(self.x + trans.x, self.y + trans.y, self.z, self.w);
			} else {
				return Vector4.Zero;
			}
		}
		#endregion
	};
	
	#region 参数处理
	if (argument_count == 1) {
		Vector4Struct.x = x
		Vector4Struct.y = x
		Vector4Struct.z = x
		Vector4Struct.w = x
	} else if (is_vec2(x)) {
		Vector4Struct.x = x.x
		Vector4Struct.y = x.y
		Vector4Struct.z = y
		Vector4Struct.w = z
	} else if (is_vec3(x)) {
		Vector4Struct.x = x.x
		Vector4Struct.y = x.y
		Vector4Struct.z = x.z
		Vector4Struct.w = y
	} else if (is_vec4(x)) {
		Vector4Struct.x = x.x
		Vector4Struct.y = x.y
		Vector4Struct.z = x.z
		Vector4Struct.w = x.w
	}
	#endregion
	
	#region 静态常量
	static Zero = Vector4(0, 0, 0, 0);
	static One = Vector4(1, 1, 1, 1);
	static UnitX = Vector4(1, 0, 0, 0);
	static UnitY = Vector4(0, 1, 0, 0);
	static UnitZ = Vector4(0, 0, 1, 0);
	static UnitW = Vector4(0, 0, 0, 1);
	#endregion
	
	#region 静态方法
	static Abs = function(vec) { return vec.Abs(); };
	static Add = function(vec, vec2) { return vec.Add(vec2); };
	static Subtract = function(vec, vec2) { return vec.Subtract(vec2); };
	static Multiply = function(vec, vec2) { return vec.Multiply(vec2); };
	static Divide = function(vec, vec2) { return vec.Divide(vec2); };
	static Dot = function(vec, vec2) { return vec.Dot(vec2); };
	static Distance = function(vec, vec2) { return vec.Subtract(vec2).Length(); };
	static DistanceSquared = function(vec, vec2) { return vec.Subtract(vec2).LengthSquared(); };
	static Length = function(vec) { return vec.Length(); };
	static LengthSquared = function(vec) { return vec.LengthSquared(); };
	static Normalize = function(vec) { return vec.Normalize(); };
	static Negate = function(vec) { return vec.Negate(); };
	static Clamp = function(vec, _min, _max) { return vec.Clamp(_min, _max); };
	static Lerp = function(vec, vec2, _t) { return vec.Lerp(vec2, _t); };
	static Min = function(vec, vec2) { return vec.Min(vec2); };
	static Max = function(vec, vec2) { return vec.Max(vec2); };
	static SquareRoot = function(vec) { return vec.SquareRoot(); };
	static Equals = function(vec, vec2, _tolerance = 0.000001) { return vec.Equals(vec2, _tolerance); };
	static Copy = function(vec) { return vec.Copy(); };
	static Reflect = function(vec, _normal) { vec.Reflect(_normal) };
	static Transform = function(vec, trans) { return vec.Transform(trans); };
	#endregion
	
	return Vector4Struct
}