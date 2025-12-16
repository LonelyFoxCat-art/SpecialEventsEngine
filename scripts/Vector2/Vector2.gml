/// @func Vector2(x, y)
/// @desc 创建一个二维向量结构。支持通过两个分量、单个数值（用于 x 和 y）或另一个向量/兼容结构初始化。
/// @arg {real|struct} x - 若为数值且只提供了x，则 x 和 y 均设为此值；若为向量结构，则复制其 x、y；否则视为 x 分量
/// @arg {real} y - 向量的 y 分量（x为非向量的时候提供）
/// @returns {struct} 包含 x、y 分量及多种向量运算方法的 Vector2 结构
Vector2()
function Vector2(x = 0, y = 0) {
    var Vector2Struct = {
        type: "Vector2",
        x: x,
        y: y,
        
		#region 实例方法
        Abs: function() {
            return Vector2(abs(self.x), abs(self.y));
        },
        Add: function(vec) {
			if (is_real(vec)) return Vector2(self.x + vec, self.y + vec);
            return Vector2(self.x + vec.x, self.y + vec.y);
        },
        Subtract: function(vec) {
			if (is_real(vec)) return Vector2(self.x - vec, self.y - vec);
            return Vector2(self.x - vec.x, self.y - vec.y);
        },
        Multiply: function(vec) {
            if (is_real(vec)) return Vector2(self.x * vec, self.y * vec);
            return Vector2(self.x * vec.x, self.y * vec.y);
        },
        Divide: function(arg) {
            if (is_real(vec)) {
				if (vec == 0) vec = 0.000001;
				return Vector2(self.x / vec, self.y / vec)
			}
            return Vector2(self.x / arg.x, self.y / arg.y);
        },
        Dot: function(vec) {
			if (is_real(vec)) return Vector2(self.x + vec, self.y + vec);
            return self.x * vec.x + self.y * vec.y;
        },
        Length: function() {
            return sqrt(self.x * self.x + self.y * self.y);
        },
        LengthSquared: function() {
            return self.x * self.x + self.y * self.y;
        },
        Normalize: function() {
            var len = self.Length();
            if (len == 0) return Vector2(0, 0);
            var inv = 1 / len;
            return Vector2(self.x * inv, self.y * inv);
        },
        Negate: function() {
            return Vector2(-self.x, -self.y);
        },
        Clamp: function(min, max) {
            return Vector2(
                clamp(self.x, min.x, max.x),
                clamp(self.y, min.y, max.y)
            );
        },
        Lerp: function(vec, t) {
            var t_clamped = clamp(t, 0, 1);
            return Vector2(
                self.x + t_clamped * (vec.x - self.x),
                self.y + t_clamped * (vec.y - self.y)
            );
        },
        Min: function(vec) {
            return Vector2(min(self.x, vec.x), min(self.y, vec.y));
        },
        Max: function(vec) {
            return Vector2(max(self.x, vec.x), max(self.y, vec.y));
        },
        SquareRoot: function() {
            return Vector2(
                (self.x >= 0) ? sqrt(self.x) : 0,
                (self.y >= 0) ? sqrt(self.y) : 0
            );
        },
        Reflect: function(normal) {
            var dot = self.Dot(normal);
            return self.Subtract(normal.Multiply(2 * dot));
        },
        Equals: function(vec, tolerance = 0.000001) {
            return (abs(self.x - vec.x) <= tolerance && abs(self.y - vec.y) <= tolerance);
        },
        ToString: function() {
            return "Vector2(" + string(self.x) + ", " + string(self.y) + ")";
        },
        Copy: function() {
            return Vector2(self.x, self.y);
        },
        Transform: function(trans) {
            if (is_matrix3x2(trans)) {
                var X = self.x * trans.m11 + self.y * trans.m21 + trans.m31;
                var Y = self.x * trans.m12 + self.y * trans.m22 + trans.m32;
                return Vector2(X, Y);
            } else if (is_matrix4x4(trans)) {
                var X = self.x * trans.m00 + self.y * trans.m10 + trans.m30;
                var Y = self.x * trans.m01 + self.y * trans.m11 + trans.m31;
                var w = self.x * trans.m03 + self.y * trans.m13 + trans.m33;
                if (w != 0) {
                    X /= w; Y /= w;
                }
                return Vector2(X, Y);
            } else if (is_quat(trans)) {
				var ix = self.x, iy = self.y, iz = 0;
	            var qx = trans.x, qy = trans.y, qz = trans.z, qw = trans.w;

	            var tx = 2 * (qy * iz - qz * iy);
	            var ty = 2 * (qz * ix - qx * iz);
	            var tz = 2 * (qx * iy - qy * ix);

	            var rx = ix + qw * tx + (qy * tz - qz * ty);
	            var ry = iy + qw * ty + (qz * tx - qx * tz);

	            return Vector2(rx, ry);
			}
			
            return Vector2.Zero;
        },
        TransformNormal: function(Transform) {
            if (is_matrix3x2(Transform)) {
                var X = self.x * Transform.m11 + self.y * Transform.m21;
                var Y = self.x * Transform.m12 + self.y * Transform.m22;
                return Vector2(X, Y);
            } else if (is_matrix4x4(Transform)) {
                var X = self.x * Transform.m00 + self.y * Transform.m10;
                var Y = self.x * Transform.m01 + self.y * Transform.m11;
                return Vector2(X, Y);
            }
            return Vector2.Zero;
        }
		#endregion
    };
	
	#region 参数处理
	if (argument_count == 1) {
		Vector2Struct.x = x;
		Vector2Struct.y = x;
	} else if (is_vec(x)) {
		Vector2Struct.x = x.x;
		Vector2Struct.y = x.y;
	}
    #endregion
	
    #region 静态常量
	static Zero = Vector2(0, 0);
	static One = Vector2(1, 1);
	static Up = Vector2(0, -1);
	static Down = Vector2(0, 1);
	static Left = Vector2(-1, 0);
	static Right = Vector2(1, 0);
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
    static Clamp = function(vec, min, max) { return vec.Clamp(min, max); };
    static Lerp = function(vec, vec2, t) { return vec.Lerp(vec2, t); };
    static Min = function(vec, vec2) { return vec.Min(vec2); };
    static Max = function(vec, vec2) { return vec.Max(vec2); };
    static SquareRoot = function(vec) { return vec.SquareRoot(); };
    static Reflect = function(vec, normal) { return vec.Reflect(normal); };
    static Equals = function(vec, vec2, tolerance = 0.000001) { return vec.Equals(vec2, tolerance); };
    static Copy = function(vec) { return vec.Copy(); };
    static Transform = function(vec, trans) { return vec.Transform(trans); };
    static TransformNormal = function(vec, transform) { return vec.TransformNormal(transform); };
    #endregion
	
    return Vector2Struct;
}