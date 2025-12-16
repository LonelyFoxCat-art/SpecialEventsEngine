/// @func is_quaternion(quat)
/// @desc 判断给定值是否为合法的四元数结构
/// @arg {any} quat - 待检测的值
/// @returns {bool} 是四元数结构返回 true，否则返回 false

function is_quat(quat) {
	if (quat == undefined) return false;
    return (is_struct(quat) && quat.type == "Quaternion");
}

/// @func Quaternion(x, y, z, w)
/// @desc 创建一个四元数（Quaternion）对象，支持多种构造方式和丰富的静态/实例方法
/// @arg {real|vec2|vec3|vec4} x - 若为数值，则四个分量均设为该值；若为向量，则根据维度填充分量
/// @arg {real} y - 当 x 为数值时，表示 y 分量；当 x 为 vec2/vec3 时，作为 w 或 z 的补充参数
/// @arg {real} z - 当 x 为数值或 vec2 时，作为 w 的补充参数
/// @arg {real} w - 当 x 为数值、vec2 或 vec3 时，指定 w 分量
/// @returns {struct} 包含四元数数据和方法的结构体

function Quaternion(x, y, z, w) {
	var QuaternionStruct = {
		type: "Quaternion",
		x: x,
		y: y,
		z: z,
		w, w,
		
		#region 实例方法
		Add: function(quat) {
			if (is_real(quat)) return Quaternion(self.x + quat, self.y + quat, self.z + quat, self.w + quat);
			return Quaternion(self.x + quat.x, self.y + quat.y, self.z + quat.z, self.w + quat.w);
		},
		Subtract: function(quat) {
			if (is_real(quat)) return Quaternion(self.x - quat, self.y - quat, self.z - quat, self.w - quat);
			return Quaternion(self.x - quat.x, self.y - quat.y, self.z - quat.z, self.w - quat.w);
		},
		Multiply: function(quat) {
			if (is_real(quat)) return Quaternion(self.x * quat, self.y * quat, self.z * quat, self.w * quat);
			return Quaternion(self.x * quat.x, self.y * quat.y, self.z * quat.z, self.w * quat.w);
		},
		Divide: function(quat) {
			return self.Multiply(Quaternion.Inverse(quat));
		},
		Dot: function(quat) {
			return self.x * quat.x + self.y * quat.y + self.z * quat.z + self.w * quat.w;
		},
		Conjugate: function() {
			return Quaternion(-self.x, -self.y, -self.z, self.w);
		},
		Inverse: function() {
			var len_sq = self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w;
			if (len_sq == 0) return Quaternion(0, 0, 0, 0);
			var inv_len_sq = 1 / len_sq;
			var conj = self.Conjugate();
			return Quaternion(
				conj.x * inv_len_sq,
				conj.y * inv_len_sq,
				conj.z * inv_len_sq,
				conj.w * inv_len_sq
			);
		},
		Length: function() {
			return sqrt(self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w);
		},
		LengthSquared: function() {
			return self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w;
		},
		Normalize: function() {
			var len = self.Length();
			if (len == 0) return Quaternion(0, 0, 0, 1);
			var inv_len = 1 / len;
			return Quaternion(
				self.x * inv_len,
				self.y * inv_len,
				self.z * inv_len,
				self.w * inv_len
			);
		},
		Negate: function() {
			return Quaternion(-self.x, -self.y, -self.z, -self.w);
		},
		Lerp: function(quat, t) {
			var t_clamped = clamp(t, 0, 1);
			return Quaternion(
				self.x + t_clamped * (quat.x - self.x),
				self.y + t_clamped * (quat.y - self.y),
				self.z + t_clamped * (quat.z - self.z),
				self.w + t_clamped * (quat.w - self.w)
			).Normalize();
		},
		Slerp: function(quat, t) {
			var t_clamped = clamp(t, 0, 1);
			var dot = self.Dot(quat);

			var q_use = quat;
			if (dot < 0) {
				dot = -dot;
				q_use = quat.Negate();
			}

			if (dot > 0.9995) {
				return self.Lerp(q_use, t_clamped);
			}

			var half_angle = arccos(dot);
			var sin_half = sin(half_angle);
			if (sin_half == 0) return self;

			var ratio_a = sin((1 - t_clamped) * half_angle) / sin_half;
			var ratio_b = sin(t_clamped * half_angle) / sin_half;

			return Quaternion(
				self.x * ratio_a + q_use.x * ratio_b,
				self.y * ratio_a + q_use.y * ratio_b,
				self.z * ratio_a + q_use.z * ratio_b,
				self.w * ratio_a + q_use.w * ratio_b
			);
		},
		Concatenate: function(quat) {
			return self.Multiply(quat);
		},
		Equals: function(quat, tolerance = 0.000001) {
			return (
				abs(self.x - quat.x) <= tolerance &&
				abs(self.y - quat.y) <= tolerance &&
				abs(self.z - quat.z) <= tolerance &&
				abs(self.w - quat.w) <= tolerance
			);
		},
		ToString: function() {
			return "Quaternion(" + string(self.x) + ", " + string(self.y) + ", " + string(self.z) + ", " + string(self.w) + ")";
		},
		ToAxisAngle: function() {
			var qn = self.Normalize();
			var angle = 2 * arccos(clamp(qn.w, -1, 1));
			var sinHalf = sin(angle * 0.5);
			if (abs(sinHalf) < 0.000001) {
				return { axis: Vector3.UnitX, angle: 0 };
			}
			var inv = 1 / sinHalf;
			return {
				axis: new Vector3(qn.x * inv, qn.y * inv, qn.z * inv),
				angle: angle
			};
		},
		#endregion
	};
	
	#region 参数处理
	if (argument_count == 1) {
		QuaternionStruct.x = x
		QuaternionStruct.y = x
		QuaternionStruct.z = x
		QuaternionStruct.w = x
	} else if (is_vec2(x)) {
		QuaternionStruct.x = x.x
		QuaternionStruct.y = x.y
		QuaternionStruct.z = y
		QuaternionStruct.w = z
	} else if (is_vec3(x)) {
		QuaternionStruct.x = x.x
		QuaternionStruct.y = x.y
		QuaternionStruct.z = x.z
		QuaternionStruct.w = y
	} else if (is_vec4(x)) {
		QuaternionStruct.x = x.x
		QuaternionStruct.y = x.y
		QuaternionStruct.z = x.z
		QuaternionStruct.w = x.w
	}
	#endregion
	
	#region 基础静态方法
	static Add = function(quat, quat2) { return quat.Add(quat2); };
	static Subtract = function(quat, quat2) { return quat.Subtract(quat2); };
	static Multiply = function(quat, quat2) { return quat.Multiply(quat2); };
	static Divide = function(quat, quat2) { return quat.Divide(quat2); };
	static Dot = function(quat, quat2) { return quat.Dot(quat2); };
	static Negate = function(quat) { return quat.Negate(); };
	#endregion
	
	#region 变换构造器 - 转换操作
	static Normalize = function(quat) { return quat.Normalize(); };
	static Conjugate = function(quat) { return quat.Conjugate(); };
	static Inverse = function(quat) { return quat.Inverse(); };
	static CreateFromAxisAngle = function(_axis, _angle) {
		var half_angle = _angle * 0.5;
		var sin_half = sin(half_angle);
		var cos_half = cos(half_angle);
		return Quaternion(
			_axis.x * sin_half,
			_axis.y * sin_half,
			_axis.z * sin_half,
			cos_half
		);
	};
	static CreateFromYawPitchRoll = function(_yaw, _pitch, _roll) {
		var half_yaw = _yaw * 0.5;
		var half_pitch = _pitch * 0.5;
		var half_roll = _roll * 0.5;

		var sy = sin(half_yaw);
		var cy = cos(half_yaw);
		var sp = sin(half_pitch);
		var cp = cos(half_pitch);
		var sr = sin(half_roll);
		var cr = cos(half_roll);

		var _x = cr * sp * cy + sr * cp * sy;
		var _y = cr * cp * sy - sr * sp * cy;
		var z = sr * cp * cy - cr * sp * sy;
		var w = cr * cp * cy + sr * sp * sy;

		return Quaternion(_x, _y, z, w);
	};
	static CreateFromRotationMatrix = function(_mat) {
		var m00 = _mat.m00; var m01 = _mat.m01; var m02 = _mat.m02;
		var m10 = _mat.m10; var m11 = _mat.m11; var m12 = _mat.m12;
		var m20 = _mat.m20; var m21 = _mat.m21; var m22 = _mat.m22;

		var trace = m00 + m11 + m22;
		var qx, qy, qz, qw;

		if (trace > 0) {
			var s = sqrt(trace + 1.0) * 2;
			var inv_s = 1 / s;
			qx = (m21 - m12) * inv_s;
			qy = (m02 - m20) * inv_s;
			qz = (m10 - m01) * inv_s;
			qw = 0.25 * s;
		} else if (m00 > m11 && m00 > m22) {
			var s = sqrt(1.0 + m00 - m11 - m22) * 2;
			var inv_s = 1 / s;
			qx = 0.25 * s;
			qy = (m01 + m10) * inv_s;
			qz = (m02 + m20) * inv_s;
			qw = (m21 - m12) * inv_s;
		} else if (m11 > m22) {
			var s = sqrt(1.0 + m11 - m00 - m22) * 2;
			var inv_s = 1 / s;
			qx = (m01 + m10) * inv_s;
			qy = 0.25 * s;
			qz = (m12 + m21) * inv_s;
			qw = (m02 - m20) * inv_s;
		} else {
			var s = sqrt(1.0 + m22 - m00 - m11) * 2;
			var inv_s = 1 / s;
			qx = (m02 + m20) * inv_s;
			qy = (m12 + m21) * inv_s;
			qz = 0.25 * s;
			qw = (m10 - m01) * inv_s;
		}

		return Quaternion(qx, qy, qz, qw).Normalize();
	};
	static LookRotation = function(_forward, _up = Vector3.Up) {
	    var f = _forward.Normalize();
	    if (f.LengthSquared() < 0.000001) return Quaternion(0, 0, 0, 1);
	    var right = _up.Cross(f).Normalize();
	    if (right.LengthSquared() < 0.000001) {
	        right = Vector3.UnitX.Cross(f).Normalize();
	        if (right.LengthSquared() < 0.000001) {
	            right = Vector3.UnitZ.Cross(f).Normalize();
	        }
	    }
	    var up = f.Cross(right).Normalize();
	    var m = Matrix4x4(
	        right.x, up.x, f.x, 0,
	        right.y, up.y, f.y, 0,
	        right.z, up.z, f.z, 0,
	        0, 0, 0, 1
	    );
	    return Quaternion.CreateFromRotationMatrix(m);
	};
	static ToAxisAngle = function(quat) { return quat.ToAxisAngle(); };
	#endregion
	
	#region 变换构造器 - 工具函数
	static Length = function(quat) { return quat.Length(); };
	static LengthSquared = function(quat) { return quat.LengthSquared(); };
	static Lerp = function(quat, quat2, t) { return quat.Lerp(quat2, t); };
	static Slerp = function(quat, quat2, t) { return quat.Slerp(quat2, t); };
	static Concatenate = function(quat, quat2) { return quat.Concatenate(quat2); };
	static Equals = function(quat, quat2, tolerance = 0.000001) { return quat.Equals(quat2, tolerance); };
	#endregion
	
	return QuaternionStruct
}