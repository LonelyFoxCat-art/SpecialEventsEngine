/// @func Quaternion(x, y, z, w)
/// @desc 四元数构造器。创建一个表示旋转的四元数。
/// @param {Real} x X 分量
/// @param {Real} y Y 分量
/// @param {Real} z Z 分量
/// @param {Real} w W 分量
/// @returns {Quaternion}
function Quaternion(_x, _y, _z, _w) constructor {
	self.type = "Quaternion";
	self.x = _x;
	self.y = _y;
	self.z = _z;
	self.w = _w;

	/* -------------- 实例方法 -------------- */
	
	self.Add = function(_q) {
		return new Quaternion(
			self.x + _q.x,
			self.y + _q.y,
			self.z + _q.z,
			self.w + _q.w
		);
	};
	self.Subtract = function(_q) {
		return new Quaternion(
			self.x - _q.x,
			self.y - _q.y,
			self.z - _q.z,
			self.w - _q.w
		);
	};
	self.Multiply = function(_arg) {
		if (is_struct(_arg) && _arg.type == "Quaternion") {
			var qx = _arg.x;
			var qy = _arg.y;
			var qz = _arg.z;
			var qw = _arg.w;
			return new Quaternion(
				self.w * qx + self.x * qw + self.y * qz - self.z * qy,
				self.w * qy - self.x * qz + self.y * qw + self.z * qx,
				self.w * qz + self.x * qy - self.y * qx + self.z * qw,
				self.w * qw - self.x * qx - self.y * qy - self.z * qz
			);
		} else {
			var scale = _arg;
			return new Quaternion(
				self.x * scale,
				self.y * scale,
				self.z * scale,
				self.w * scale
			);
		}
	};
	self.Divide = function(_q) {
		return self.Multiply(Quaternion.Inverse(_q));
	};
	self.Dot = function(_q) {
		return self.x * _q.x + self.y * _q.y + self.z * _q.z + self.w * _q.w;
	};
	self.Conjugate = function() {
		return new Quaternion(-self.x, -self.y, -self.z, self.w);
	};
	self.Inverse = function() {
		var len_sq = self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w;
		if (len_sq == 0) return new Quaternion(0, 0, 0, 0);
		var inv_len_sq = 1 / len_sq;
		var conj = self.Conjugate();
		return new Quaternion(
			conj.x * inv_len_sq,
			conj.y * inv_len_sq,
			conj.z * inv_len_sq,
			conj.w * inv_len_sq
		);
	};
	self.Length = function() {
		return sqrt(self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w);
	};
	self.LengthSquared = function() {
		return self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w;
	};
	self.Normalize = function() {
		var len = self.Length();
		if (len == 0) return new Quaternion(0, 0, 0, 1);
		var inv_len = 1 / len;
		return new Quaternion(
			self.x * inv_len,
			self.y * inv_len,
			self.z * inv_len,
			self.w * inv_len
		);
	};
	self.Negate = function() {
		return new Quaternion(-self.x, -self.y, -self.z, -self.w);
	};
	self.Lerp = function(_q, _t) {
		var t_clamped = clamp(_t, 0, 1);
		return new Quaternion(
			self.x + t_clamped * (_q.x - self.x),
			self.y + t_clamped * (_q.y - self.y),
			self.z + t_clamped * (_q.z - self.z),
			self.w + t_clamped * (_q.w - self.w)
		).Normalize();
	};
	self.Slerp = function(_q, _t) {
		var t_clamped = clamp(_t, 0, 1);
		var dot = self.Dot(_q);

		var q_use = _q;
		if (dot < 0) {
			dot = -dot;
			q_use = _q.Negate();
		}

		if (dot > 0.9995) {
			return self.Lerp(q_use, t_clamped);
		}

		var half_angle = arccos(dot);
		var sin_half = sin(half_angle);
		if (sin_half == 0) return self;

		var ratio_a = sin((1 - t_clamped) * half_angle) / sin_half;
		var ratio_b = sin(t_clamped * half_angle) / sin_half;

		return new Quaternion(
			self.x * ratio_a + q_use.x * ratio_b,
			self.y * ratio_a + q_use.y * ratio_b,
			self.z * ratio_a + q_use.z * ratio_b,
			self.w * ratio_a + q_use.w * ratio_b
		);
	};
	self.Concatenate = function(_q) {
		return self.Multiply(_q);
	};
	self.Equals = function(_q, _tolerance = 0.000001) {
		return (
			abs(self.x - _q.x) <= _tolerance &&
			abs(self.y - _q.y) <= _tolerance &&
			abs(self.z - _q.z) <= _tolerance &&
			abs(self.w - _q.w) <= _tolerance
		);
	};
	self.ToString = function() {
		return "Quaternion(" + string(self.x) + ", " + string(self.y) + ", " + string(self.z) + ", " + string(self.w) + ")";
	};
	self.ToAxisAngle = function() {
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
	};
	
	/* -------------- 静态成员 -------------- */

	/// @func Quaternion.Add(a, b)
	/// @desc 将两个四元数相加，返回新四元数。
	/// @param {Quaternion} a 第一个四元数
	/// @param {Quaternion} b 第二个四元数
	/// @returns {Quaternion} 结果四元数（a + b）
	static Add = function(a, b) { return a.Add(b); };
	/// @func Quaternion.Subtract(a, b)
	/// @desc 从第一个四元数中减去第二个四元数，返回新四元数。
	/// @param {Quaternion} a 被减数（第一个四元数）
	/// @param {Quaternion} b 减数（第二个四元数）
	/// @returns {Quaternion} 结果四元数（a - b）
	static Subtract = function(a, b) { return a.Subtract(b); };
	/// @func Quaternion.Multiply(a, b_or_s)
	/// @desc 将两个四元数相乘，或将一个四元数与标量相乘。
	/// @param {Quaternion} a 第一个四元数
	/// @param {Quaternion | Real} b_or_s 第二个四元数或标量
	/// @returns {Quaternion} 相乘结果（若为标量，则缩放所有分量）
	static Multiply = function(a, b) { return a.Multiply(b); };
	/// @func Quaternion.Divide(a, b)
	/// @desc 将第一个四元数除以第二个四元数（等价于 a * Inverse(b)）。
	/// @param {Quaternion} a 被除数
	/// @param {Quaternion} b 除数
	/// @returns {Quaternion} 除法结果
	static Divide = function(a, b) { return a.Divide(b); };
	/// @func Quaternion.Dot(a, b)
	/// @desc 计算两个四元数的点积（标量）。
	/// @param {Quaternion} a 第一个四元数
	/// @param {Quaternion} b 第二个四元数
	/// @returns {Real} 点积结果
	static Dot = function(a, b) { return a.Dot(b); };
	/// @func Quaternion.Conjugate(q)
	/// @desc 返回指定四元数的共轭（x, y, z 取反，w 不变）。
	/// @param {Quaternion} q 输入四元数
	/// @returns {Quaternion} 共轭四元数
	static Conjugate = function(q) { return q.Conjugate(); };
	/// @func Quaternion.Inverse(q)
	/// @desc 返回指定四元数的逆（共轭除以模长平方）。
	/// @param {Quaternion} q 输入四元数
	/// @returns {Quaternion} 逆四元数
	static Inverse = function(q) { return q.Inverse(); };
	/// @func Quaternion.Length(q)
	/// @desc 计算四元数的欧几里得长度（模）。
	/// @param {Quaternion} q 输入四元数
	/// @returns {Real} 长度（非负实数）
	static Length = function(q) { return q.Length(); };
	/// @func Quaternion.LengthSquared(q)
	/// @desc 计算四元数长度的平方（避免开方，性能更高）。
	/// @param {Quaternion} q 输入四元数
	/// @returns {Real} 长度平方
	static LengthSquared = function(q) { return q.LengthSquared(); };
	/// @func Quaternion.Normalize(q)
	/// @desc 将四元数单位化（使其长度为 1），用于表示纯旋转。
	/// @param {Quaternion} q 输入四元数
	/// @returns {Quaternion} 单位四元数
	static Normalize = function(q) { return q.Normalize(); };
	/// @func Quaternion.Negate(q)
	/// @desc 对四元数所有分量取反。
	/// @param {Quaternion} q 输入四元数
	/// @returns {Quaternion} 取反后的四元数
	static Negate = function(q) { return q.Negate(); };
	/// @func Quaternion.Lerp(a, b, t)
	/// @desc 在两个四元数之间进行线性插值（结果会自动归一化）。
	/// @param {Quaternion} a 起始四元数
	/// @param {Quaternion} b 目标四元数
	/// @param {Real} t 插值参数，范围 [0, 1]
	/// @returns {Quaternion} 插值结果（单位四元数）
	static Lerp = function(a, b, t) { return a.Lerp(b, t); };
	/// @func Quaternion.Slerp(a, b, t)
	/// @desc 在两个四元数之间进行球面线性插值（保持恒定角速度，适合旋转动画）。
	/// @param {Quaternion} a 起始四元数
	/// @param {Quaternion} b 目标四元数
	/// @param {Real} t 插值参数，范围 [0, 1]
	/// @returns {Quaternion} 插值结果（单位四元数）
	static Slerp = function(a, b, t) { return a.Slerp(b, t); };
	/// @func Quaternion.Concatenate(a, b)
	/// @desc 连接两个旋转（等价于 Quaternion.Multiply(a, b)）。
	/// @param {Quaternion} a 第一个旋转（先应用）
	/// @param {Quaternion} b 第二个旋转（后应用）
	/// @returns {Quaternion} 合成后的旋转
	static Concatenate = function(a, b) { return a.Concatenate(b); };
	/// @func Quaternion.Equals(a, b, tolerance)
	/// @desc 判断两个四元数是否在容差范围内相等。
	/// @param {Quaternion} a 第一个四元数
	/// @param {Quaternion} b 第二个四元数
	/// @param {Real} [tolerance=0.000001] 比较容差（默认 1e-6）
	/// @returns {Bool} 是否相等
	static Equals = function(a, b, tolerance = 0.000001) { return a.Equals(b, tolerance); };
	/// @func Quaternion.CreateFromAxisAngle(axis, angle)
	/// @desc 从单位轴向量和旋转角度（弧度）创建四元数。
	/// @param {Vector3} axis 单位轴向量（需含 x, y, z）
	/// @param {Real} angle 旋转角度（弧度）
	/// @returns {Quaternion} 新四元数
	static CreateFromAxisAngle = function(_axis, _angle) {
		var half_angle = _angle * 0.5;
		var sin_half = sin(half_angle);
		var cos_half = cos(half_angle);
		return new Quaternion(
			_axis.x * sin_half,
			_axis.y * sin_half,
			_axis.z * sin_half,
			cos_half
		);
	};
	/// @func Quaternion.CreateFromYawPitchRoll(yaw, pitch, roll)
	/// @desc 从偏航、俯仰、滚转角（弧度）创建四元数。
	/// @param {Real} yaw 偏航角（绕Y轴）
	/// @param {Real} pitch 俯仰角（绕X轴）
	/// @param {Real} roll 滚转角（绕Z轴）
	/// @returns {Quaternion} 新四元数
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

		return new Quaternion(_x, _y, z, w);
	};
	/// @func Quaternion.CreateFromRotationMatrix(mat)
	/// @desc 从 4x4 旋转矩阵创建四元数。
	/// @param {Matrix4x4} mat 旋转矩阵（需含 m00~m33 字段）
	/// @returns {Quaternion} 新四元数
	static CreateFromRotationMatrix = function(_mat) {
		var m00 = _mat.m00; var m01 = _mat.m01; var m02 = _mat.m02;
		var m10 = _mat.m10; var m11 = _mat.m11; var m12 = _mat.m12;
		var m20 = _mat.m20; var m21 = _mat.m21; var m22 = _mat.m22;

		var trace = m00 + m11 + m22;
		var qx, qy, qz, qw;

		if (trace > 0) {
			var s = sqrt(trace + 1.0) * 2; // s = 4 * qw
			var inv_s = 1 / s;
			qx = (m21 - m12) * inv_s;
			qy = (m02 - m20) * inv_s;
			qz = (m10 - m01) * inv_s;
			qw = 0.25 * s;
		} else if (m00 > m11 && m00 > m22) {
			var s = sqrt(1.0 + m00 - m11 - m22) * 2; // s = 4 * qx
			var inv_s = 1 / s;
			qx = 0.25 * s;
			qy = (m01 + m10) * inv_s;
			qz = (m02 + m20) * inv_s;
			qw = (m21 - m12) * inv_s;
		} else if (m11 > m22) {
			var s = sqrt(1.0 + m11 - m00 - m22) * 2; // s = 4 * qy
			var inv_s = 1 / s;
			qx = (m01 + m10) * inv_s;
			qy = 0.25 * s;
			qz = (m12 + m21) * inv_s;
			qw = (m02 - m20) * inv_s;
		} else {
			var s = sqrt(1.0 + m22 - m00 - m11) * 2; // s = 4 * qz
			var inv_s = 1 / s;
			qx = (m02 + m20) * inv_s;
			qy = (m12 + m21) * inv_s;
			qz = 0.25 * s;
			qw = (m10 - m01) * inv_s;
		}

		return new Quaternion(qx, qy, qz, qw).Normalize();
	};
	/// @func Quaternion.LookRotation(forward, up)
	/// @desc 从前方向和上方向生成旋转四元数（类似 Unity 的 LookRotation）。
	/// @param {Vector3} forward 前方向（必须非零）
	/// @param {Vector3} [up=Vector3.Up] 上方向（默认 Vector3.Up）
	/// @returns {Quaternion} 旋转四元数
	static LookRotation = function(_forward, _up = Vector3.Up) {
	    var f = _forward.Normalize();
	    if (f.LengthSquared() < 0.000001) return new Quaternion(0, 0, 0, 1);
	    var right = _up.Cross(f).Normalize();
	    if (right.LengthSquared() < 0.000001) {
	        // forward 与 up 平行，选择替代 up
	        right = Vector3.UnitX.Cross(f).Normalize();
	        if (right.LengthSquared() < 0.000001) {
	            right = Vector3.UnitZ.Cross(f).Normalize();
	        }
	    }
	    var up = f.Cross(right).Normalize();
	    var m = new Matrix4x4(
	        right.x, up.x, f.x, 0,
	        right.y, up.y, f.y, 0,
	        right.z, up.z, f.z, 0,
	        0, 0, 0, 1
	    );
	    return Quaternion.CreateFromRotationMatrix(m);
	};
	/// @func Quaternion.ToAxisAngle(q)
	/// @desc 将四元数分解为旋转轴和角度。
	/// @param {Quaternion} q 输入四元数
	/// @returns {Struct} { axis: Vector3, angle: Real }
	static ToAxisAngle = function(_q) { return _q.ToAxisAngle(); };
}