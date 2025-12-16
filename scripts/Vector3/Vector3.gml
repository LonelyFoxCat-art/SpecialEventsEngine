/// @func Vector3(x, y, z)
/// @desc 创建一个三维向量（Vector3）结构体，支持多种构造方式（标量、Vec2、Vec3/Vec4）及丰富的向量运算方法
/// @arg {real|Vec2|Vec3|Vec4} x - 若为实数，则作为 x 分量（若仅传入一个参数，则 x=y=z）；若为 Vec2/Vec3/Vec4，则从其提取分量
/// @arg {real} y - y 分量（当 x 为 Vec2 时，此参数视为 z 值；否则作为 y）
/// @arg {real} z - z 分量（仅在 x 非 Vec 类型时有效）
/// @returns {struct} 包含 x/y/z 分量与向量操作方法的 Vector3 实例
Vector3()
function Vector3(x = 0, y = 0, z = 0) {
    var Vector3Struct = {
        type: "Vector3",
        x: x,
        y: y,
        z: z,
        
        #region 实例方法
        Abs: function() {
            return Vector3(abs(self.x), abs(self.y), abs(self.z));
        },
        Add: function(vec) {
            if (is_real(vec)) return Vector3(self.x + vec, self.y + vec, self.z + vec);
            return Vector3(self.x + vec.x, self.y + vec.y, self.z + vec.z);
        },
        Subtract: function(vec) {
            if (is_real(vec)) return Vector3(self.x - vec, self.y - vec, self.z - vec);
            return Vector3(self.x - vec.x, self.y - vec.y, self.z - vec.z);
        },
        Multiply: function(vec) {
			if (is_real(vec)) return Vector3(self.x * vec, self.y * vec, self.z * vec);
            return Vector3(self.x * vec.x, self.y * vec.y, self.z * vec.z);
        },
        Divide: function(vec) {
			if (is_real(vec)){ 
				if (vec == 0) vec = 0.000001;
				return Vector3(self.x / vec.x, self.y / vec.y, self.z / vec.z);
			}
            return Vector3(self.x / vec.x, self.y / vec.y, self.z / vec.z);
        },
        Dot: function(vec) {
            return self.x * vec.x + self.y * vec.y + self.z * vec.z;
        },
        Cross: function(vec) {
            var _x = self.y * vec.z - self.z * vec.y;
            var _y = self.z * vec.x - self.x * vec.z;
            var _z = self.x * vec.y - self.y * vec.x;
            return Vector3(_x, _y, _z);
        },
        Length: function() {
            return sqrt(self.x * self.x + self.y * self.y + self.z * self.z);
        },
        LengthSquared: function() {
            return self.x * self.x + self.y * self.y + self.z * self.z;
        },
        Normalize: function() {
            var _len = self.Length();
            if (_len == 0) return Vector3.Zero;
            var _inv = 1 / _len;
            return Vector3(self.x * _inv, self.y * _inv, self.z * _inv);
        },
        Negate: function() {
            return Vector3(-self.x, -self.y, -self.z);
        },
        Project: function(_onto) {
            var dot = self.Dot(_onto);
            var lenSq = _onto.LengthSquared();
            if (lenSq < 0.000001) return Vector3.Zero;
            return _onto.Multiply(dot / lenSq);
        },
        Reject: function(_onto) {
            return self.Subtract(self.Project(_onto));
        },
        Angle: function(_other) {
            var lenA = self.Length();
            var lenB = _other.Length();
            if (lenA < 0.000001 || lenB < 0.000001) return 0;
            var _cos = self.Dot(_other) / (lenA * lenB);
            return arccos(clamp(_cos, -1, 1));
        },
        SignedAngle: function(_other, _axis) {
            var unsignedAngle = self.Angle(_other);
            var cross = self.Cross(_other);
            var _sign = cross.Dot(_axis) >= 0 ? 1 : -1;
            return _sign * unsignedAngle;
        },
        Clamp: function(_min, _max) {
            return Vector3(
                clamp(self.x, _min.x, _max.x),
                clamp(self.y, _min.y, _max.y),
                clamp(self.z, _min.z, _max.z)
            );
        },
        Lerp: function(vec, _t) {
            var _t_clamped = clamp(_t, 0, 1);
            return Vector3(
                self.x + _t_clamped * (vec.x - self.x),
                self.y + _t_clamped * (vec.y - self.y),
                self.z + _t_clamped * (vec.z - self.z)
            );
        },
        Min: function(vec) {
            return Vector3(min(self.x, vec.x), min(self.y, vec.y), min(self.z, vec.z));
        },
        Max: function(vec) {
            return Vector3(max(self.x, vec.x), max(self.y, vec.y), max(self.z, vec.z));
        },
        SquareRoot: function() {
            return Vector3(
                (self.x >= 0) ? sqrt(self.x) : 0,
                (self.y >= 0) ? sqrt(self.y) : 0,
                (self.z >= 0) ? sqrt(self.z) : 0
            );
        },
        Reflect: function(_normal) {
            var _dot = self.Dot(_normal);
            return self.Subtract(_normal.Multiply(2 * _dot));
        },
        Equals: function(vec, _tolerance = 0.000001) {
            return (
                abs(self.x - vec.x) <= _tolerance &&
                abs(self.y - vec.y) <= _tolerance &&
                abs(self.z - vec.z) <= _tolerance
            );
        },
        ToString: function() {
            return "Vector3(" + string(self.x) + ", " + string(self.y) + ", " + string(self.z) + ")";
        },
        Copy: function() {
            return Vector3(self.x, self.y, self.z);
        },
        Transform: function(trans) {
		    if (is_matrix4x4(trans)) {
		        var _x = self.x * trans.m00 + self.y * trans.m10 + self.z * trans.m20 + trans.m30;
		        var _y = self.x * trans.m01 + self.y * trans.m11 + self.z * trans.m21 + trans.m31;
		        var _z = self.x * trans.m02 + self.y * trans.m12 + self.z * trans.m22 + trans.m32;
		        var _w = self.x * trans.m03 + self.y * trans.m13 + self.z * trans.m23 + trans.m33;
		        if (_w != 0) {
		            _x /= _w;
		            _y /= _w;
		            _z /= _w;
		        }
		        return Vector3(_x, _y, _z);
		    } else if (is_quat(trans)) {
		        var _ix = self.x, _iy = self.y, _iz = self.z;
		        var _qx = trans.x, _qy = trans.y, _qz = trans.z, _qw = trans.w;
		        var _tx = 2 * (_qy * _iz - _qz * _iy);
		        var _ty = 2 * (_qz * _ix - _qx * _iz);
		        var _tz = 2 * (_qx * _iy - _qy * _ix);
		        var _rx = _ix + _qw * _tx + (_qy * _tz - _qz * _ty);
		        var _ry = _iy + _qw * _ty + (_qz * _tx - _qx * _tz);
		        var _rz = _iz + _qw * _tz + (_qx * _ty - _qy * _tx);
		        return Vector3(_rx, _ry, _rz);
		    } else if (is_vec2(trans)) {
		        return Vector3(self.x + trans.x, self.y + trans.y, 0);
		    } else {
		        return Vector3.Zero;
		    }
		},
        TransformNormal: function(_mat) {
            if (_mat.type == "Matrix4x4") {
                var _x = self.x * _mat.m00 + self.y * _mat.m10 + self.z * _mat.m20;
                var _y = self.x * _mat.m01 + self.y * _mat.m11 + self.z * _mat.m21;
                var _z = self.x * _mat.m02 + self.y * _mat.m12 + self.z * _mat.m22;
                return Vector3(_x, _y, _z);
            }
            return Vector3.Zero;
        }
		#endregion
    };
    
    #region 参数处理
	if (argument_count == 1) {
		Vector3Struct.x = x;
		Vector3Struct.y = x;
		Vector3Struct.z = x;
	} else if (is_vec2(x)) {
		Vector3Struct.x = x.x;
		Vector3Struct.y = x.y;
		Vector3Struct.z = y;
    } else if (is_vec3(x) || is_vec4(x)) {
		Vector3Struct.x = x.x;
		Vector3Struct.y = x.y;
		Vector3Struct.z = x.z;
	}
	#endregion
    
    #region 静态常量
    static Zero = Vector3(0, 0, 0);
    static One = Vector3(1, 1, 1);
    static UnitX = Vector3(1, 0, 0);
    static UnitY = Vector3(0, 1, 0);
    static UnitZ = Vector3(0, 0, 1);
    static Up = Vector3(0, 1, 0);
    static Down = Vector3(0, -1, 0);
    static Forward = Vector3(0, 0, 1);
    static Backward = Vector3(0, 0, -1);
    static Left = Vector3(-1, 0, 0);
    static Right = Vector3(1, 0, 0);
	#endregion
    
    #region 静态方法
    static Abs = function(vec) { return vec.Abs(); };
    static Add = function(vec, vec2) { return vec.Add(vec2); };
    static Subtract = function(vec, vec2) { return vec.Subtract(vec2); };
    static Multiply = function(vec, vec2) { return vec.Multiply(vec2); };
    static Divide = function(vec, vec2) { return vec.Divide(vec2); };
    static Dot = function(vec, vec2) { return vec.Dot(vec2); };
    static Cross = function(vec, vec2) { return vec.Cross(vec2); };
    static Distance = function(vec, vec2) { return vec.Subtract(vec2).Length(); };
    static DistanceSquared = function(vec, vec2) { return vec.Subtract(vec2).LengthSquared(); };
    static Length = function(vec) { return vec.Length(); };
    static LengthSquared = function(vec) { return vec.LengthSquared(); };
    static Normalize = function(vec) { return vec.Normalize(); };
    static Negate = function(vec) { return vec.Negate(); };
    static Project = function(vec, _onto) { return vec.Project(_onto); };
    static Reject = function(vec, _onto) { return vec.Reject(_onto); };
    static Angle = function(vec, vec2) { return vec.Angle(vec2); };
    static SignedAngle = function(_from, _to, _axis) { return _from.SignedAngle(_to, _axis); };
    static Clamp = function(vec, _min, _max) { return vec.Clamp(_min, _max); };
    static Lerp = function(vec, vec2, _t) { return vec.Lerp(vec2, _t); };
    static Min = function(vec, vec2) { return vec.Min(vec2); };
    static Max = function(vec, vec2) { return vec.Max(vec2); };
    static SquareRoot = function(vec) { return vec.SquareRoot(); };
    static Reflect = function(vec, _normal) { return vec.Reflect(_normal); };
    static Equals = function(vec, vec2, _tolerance = 0.000001) { return vec.Equals(vec2, _tolerance); };
    static Copy = function(vec) { return vec.Copy(); };
    static Transform = function(vec, trans) { return vec.Transform(trans); };
    static TransformNormal = function(vec, _mat) { return vec.TransformNormal(_mat); };
	#endregion
    
    return Vector3Struct;
}