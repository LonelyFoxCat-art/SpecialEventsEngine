/// @func Matrix3x2(m11, m12, m21, m22, m31, m32)
/// @desc 3x2 仿射变换矩阵构造器；格式为 [m11 m12; m21 m22; m31 m32]，其中 (m31,m32) 为平移分量。
/// @param {Real} [m11=1] 第1行第1列（默认1）
/// @param {Real} [m12=0] 第1行第2列（默认0）
/// @param {Real} [m21=0] 第2行第1列（默认0）
/// @param {Real} [m22=1] 第2行第2列（默认1）
/// @param {Real} [m31=0] X 平移（默认0）
/// @param {Real} [m32=0] Y 平移（默认0）
/// @returns {Matrix3x2}
function Matrix3x2(_m11 = 1, _m12 = 0, _m21 = 0, _m22 = 1, _m31 = 0, _m32 = 0) constructor {
	self.type = "Matrix3x2";
	self.m11 = _m11;
	self.m12 = _m12;
	self.m21 = _m21;
	self.m22 = _m22;
	self.m31 = _m31;
	self.m32 = _m32;

	// =============== 实例方法 ===============
	
	self.Add = function(_other) {
		return new Matrix3x2(
			self.m11 + _other.m11, self.m12 + _other.m12,
			self.m21 + _other.m21, self.m22 + _other.m22,
			self.m31 + _other.m31, self.m32 + _other.m32
		);
	};
	self.Subtract = function(_other) {
		return new Matrix3x2(
			self.m11 - _other.m11, self.m12 - _other.m12,
			self.m21 - _other.m21, self.m22 - _other.m22,
			self.m31 - _other.m31, self.m32 - _other.m32
		);
	};
	self.Multiply = function(_arg) {
		if (is_struct(_arg) && _arg.type == "Matrix3x2") {
			// 矩阵乘法：this * other
			var a = self; var b = _arg;
			return new Matrix3x2(
				a.m11 * b.m11 + a.m12 * b.m21,
				a.m11 * b.m12 + a.m12 * b.m22,
				a.m21 * b.m11 + a.m22 * b.m21,
				a.m21 * b.m12 + a.m22 * b.m22,
				a.m31 * b.m11 + a.m32 * b.m21 + b.m31,
				a.m31 * b.m12 + a.m32 * b.m22 + b.m32
			);
		} else {
			var _s = _arg;
			return new Matrix3x2(
				self.m11 * _s, self.m12 * _s,
				self.m21 * _s, self.m22 * _s,
				self.m31 * _s, self.m32 * _s
			);
		}
	};
	self.Negate = function() {
		return new Matrix3x2(
			-self.m11, -self.m12,
			-self.m21, -self.m22,
			-self.m31, -self.m32
		);
	};
	self.Equals = function(_other, _tolerance = 0.000001) {
		return (
			abs(self.m11 - _other.m11) <= _tolerance &&
			abs(self.m12 - _other.m12) <= _tolerance &&
			abs(self.m21 - _other.m21) <= _tolerance &&
			abs(self.m22 - _other.m22) <= _tolerance &&
			abs(self.m31 - _other.m31) <= _tolerance &&
			abs(self.m32 - _other.m32) <= _tolerance
		);
	};
	self.ToString = function() {
		return "Matrix3x2(" +
			string(self.m11) + ", " + string(self.m12) + ", " +
			string(self.m21) + ", " + string(self.m22) + ", " +
			string(self.m31) + ", " + string(self.m32) + ")";
	};
	self.GetDeterminant = function() {
		return self.m11 * self.m22 - self.m12 * self.m21;
	};
	self.Invert = function() {
		var _det = self.GetDeterminant();
		if (abs(_det) < 0.000001) {
			return undefined;
		}
		var _inv_det = 1 / _det;
		return new Matrix3x2(
			self.m22 * _inv_det,
			-self.m12 * _inv_det,
			-self.m21 * _inv_det,
			self.m11 * _inv_det,
			(self.m21 * self.m32 - self.m22 * self.m31) * _inv_det,
			(self.m12 * self.m31 - self.m11 * self.m32) * _inv_det
		);
	};
	self.Lerp = function(_other, _t) {
		var t = clamp(_t, 0, 1);
		return new Matrix3x2(
			self.m11 + t * (_other.m11 - self.m11),
			self.m12 + t * (_other.m12 - self.m12),
			self.m21 + t * (_other.m21 - self.m21),
			self.m22 + t * (_other.m22 - self.m22),
			self.m31 + t * (_other.m31 - self.m31),
			self.m32 + t * (_other.m32 - self.m32)
		);
	};

	// =============== 静态常量 ===============
	
	static Identity = new Matrix3x2(1, 0, 0, 1, 0, 0);

	// =============== 基础静态方法 ===============
	
	/// @func Matrix3x2.Add(a, b)
	/// @desc 将两个 3x2 矩阵对应元素相加。
	/// @param {Matrix3x2} a 第一个矩阵
	/// @param {Matrix3x2} b 第二个矩阵
	/// @returns {Matrix3x2}
	static Add = function(_a, _b) { return _a.Add(_b); };

	/// @func Matrix3x2.Subtract(a, b)
	/// @desc 从第一个矩阵中减去第二个矩阵的对应元素。
	/// @param {Matrix3x2} a 被减矩阵
	/// @param {Matrix3x2} b 减矩阵
	/// @returns {Matrix3x2}
	static Subtract = function(_a, _b) { return _a.Subtract(_b); };

	/// @func Matrix3x2.Multiply(a, b_or_s)
	/// @desc 将两个矩阵相乘，或将矩阵与标量相乘。
	/// @param {Matrix3x2} a 第一个矩阵
	/// @param {Matrix3x2 | Real} b_or_s 第二个矩阵或标量
	/// @returns {Matrix3x2}
	static Multiply = function(_a, _b) { return _a.Multiply(_b); };

	/// @func Matrix3x2.Negate(m)
	/// @desc 对矩阵所有元素取反。
	/// @param {Matrix3x2} m 输入矩阵
	/// @returns {Matrix3x2}
	static Negate = function(_m) { return _m.Negate(); };

	/// @func Matrix3x2.Equals(a, b, tolerance)
	/// @desc 判断两个矩阵是否在容差范围内相等。
	/// @param {Matrix3x2} a 第一个矩阵
	/// @param {Matrix3x2} b 第二个矩阵
	/// @param {Real} [tolerance=0.000001] 比较容差
	/// @returns {Bool}
	static Equals = function(_a, _b, _tolerance = 0.000001) { return _a.Equals(_b, _tolerance); };

	/// @func Matrix3x2.Lerp(a, b, t)
	/// @desc 在两个矩阵之间线性插值。
	/// @param {Matrix3x2} a 起始矩阵
	/// @param {Matrix3x2} b 目标矩阵
	/// @param {Real} t 插值因子 [0,1]
	/// @returns {Matrix3x2}
	static Lerp = function(_a, _b, _t) { return _a.Lerp(_b, _t); };

	/// @func Matrix3x2.GetDeterminant(m)
	/// @desc 计算 3x2 矩阵的行列式（仅使用旋转/缩放部分）。
	/// @desc det = m11 * m22 - m12 * m21
	/// @param {Matrix3x2} m 输入矩阵
	/// @returns {Real}
	static GetDeterminant = function(_m) { return _m.GetDeterminant(); };

	/// @func Matrix3x2.Invert(m)
	/// @desc 对指定 3x2 矩阵求逆。
	/// @desc 若矩阵不可逆（行列式接近0），返回 undefined。
	/// @param {Matrix3x2} m 要求逆的矩阵
	/// @returns {Matrix3x2 | undefined}
	static Invert = function(_m) { return _m.Invert(); };

	// =============== 变换构造器 ===============
	
	/// @func Matrix3x2.CreateRotation(radians)
	/// @desc 创建绕原点旋转的 3x2 矩阵（右手系，+角度为逆时针）。
	/// @param {Real} radians 旋转角度（弧度）
	/// @returns {Matrix3x2}
	static CreateRotation = function(_radians) {
		var _cos = cos(_radians);
		var _sin = sin(_radians);
		return new Matrix3x2(
			_cos, _sin,
			-_sin, _cos,
			0, 0
		);
	};

	/// @func Matrix3x2.CreateRotation(radians, center)
	/// @desc 创建绕指定中心点旋转的 3x2 矩阵。
	/// @param {Real} radians 旋转角度（弧度）
	/// @param {Vector2} center 旋转中心（type="Vector2"）
	/// @returns {Matrix3x2}
	static CreateRotationCenter = function(_radians, _center) {
		var _cos = cos(_radians);
		var _sin = sin(_radians);
		var _x = _center.x;
		var _y = _center.y;
		var _m31 = _x - _x * _cos + _y * _sin;
		var _m32 = _y - _x * _sin - _y * _cos;
		return new Matrix3x2(
			_cos, _sin,
			-_sin, _cos,
			_m31, _m32
		);
	};

	// =============== 变换构造器 ===============
	
	/// @func Matrix3x2.CreateScale(scale)
	/// @desc 创建统一缩放的 3x2 矩阵（绕原点）。
	/// @param {Real} scale 缩放比例
	/// @returns {Matrix3x2}
	static CreateScaleUniform = function(_scale) { return new Matrix3x2(_scale, 0, 0, _scale, 0, 0); };

	/// @func Matrix3x2.CreateScale(x, y)
	/// @desc 创建非统一缩放的 3x2 矩阵（绕原点）。
	/// @param {Real} x X 轴缩放
	/// @param {Real} y Y 轴缩放
	/// @returns {Matrix3x2}
	static CreateScaleXY = function(_x, _y) { return new Matrix3x2(_x, 0, 0, _y, 0, 0); };

	/// @func Matrix3x2.CreateScale(v)
	/// @desc 从 Vector2 创建缩放矩阵（绕原点）。
	/// @param {Vector2} v 缩放向量（type="Vector2"）
	/// @returns {Matrix3x2}
	static CreateScaleVector = function(_v) { return new Matrix3x2(_v.x, 0, 0, _v.y, 0, 0); };

	/// @func Matrix3x2.CreateScale(scale, center)
	/// @desc 创建绕指定中心统一缩放的 3x2 矩阵。
	/// @param {Real} scale 缩放比例
	/// @param {Vector2} center 缩放中心（type="Vector2"）
	/// @returns {Matrix3x2}
	static CreateScaleUniformCenter = function(_scale, _center) {
		var _x = _center.x;
		var _y = _center.y;
		var _m31 = _x - _x * _scale;
		var _m32 = _y - _y * _scale;
		return new Matrix3x2(_scale, 0, 0, _scale, _m31, _m32);
	};

	/// @func Matrix3x2.CreateScale(x, y, center)
	/// @desc 创建绕指定中心非统一缩放的 3x2 矩阵。
	/// @param {Real} x X 轴缩放
	/// @param {Real} y Y 轴缩放
	/// @param {Vector2} center 缩放中心（type="Vector2"）
	/// @returns {Matrix3x2}
	static CreateScaleXYCenter = function(_x, _y, _center) {
		var _cx = _center.x;
		var _cy = _center.y;
		var _m31 = _cx - _cx * _x;
		var _m32 = _cy - _cy * _y;
		return new Matrix3x2(_x, 0, 0, _y, _m31, _m32);
	};

	/// @func Matrix3x2.CreateScale(v, center)
	/// @desc 从 Vector2 和中心点创建缩放矩阵。
	/// @param {Vector2} v 缩放向量（type="Vector2"）
	/// @param {Vector2} center 缩放中心（type="Vector2"）
	/// @returns {Matrix3x2}
	static CreateScaleVectorCenter = function(_v, _center) {
		var _sx = _v.x;
		var _sy = _v.y;
		var _cx = _center.x;
		var _cy = _center.y;
		var _m31 = _cx - _cx * _sx;
		var _m32 = _cy - _cy * _sy;
		return new Matrix3x2(_sx, 0, 0, _sy, _m31, _m32);
	};

	// =============== 变换构造器 ===============
	
	/// @func Matrix3x2.CreateSkew(xAngle, yAngle)
	/// @desc 创建斜切（错切）矩阵（绕原点）。
	/// @param {Real} xAngle X 轴斜切角度（弧度）
	/// @param {Real} yAngle Y 轴斜切角度（弧度）
	/// @returns {Matrix3x2}
	static CreateSkew = function(_xAngle, _yAngle) {
		return new Matrix3x2(
			1, tan(_yAngle),
			tan(_xAngle), 1,
			0, 0
		);
	};

	/// @func Matrix3x2.CreateSkew(xAngle, yAngle, center)
	/// @desc 创建绕指定中心点的斜切矩阵。
	/// @param {Real} xAngle X 轴斜切角度（弧度）
	/// @param {Real} yAngle Y 轴斜切角度（弧度）
	/// @param {Vector2} center 斜切中心（type="Vector2"）
	/// @returns {Matrix3x2}
	static CreateSkewCenter = function(_xAngle, _yAngle, _center) {
		var _skew = Matrix3x2.CreateSkew(_xAngle, _yAngle);
		var _cx = _center.x;
		var _cy = _center.y;
		var _m31 = _skew.m11 * _cx + _skew.m12 * _cy - _cx;
		var _m32 = _skew.m21 * _cx + _skew.m22 * _cy - _cy;
		return new Matrix3x2(
			_skew.m11, _skew.m12,
			_skew.m21, _skew.m22,
			-_m31, -_m32
		);
	};

	// =============== 变换构造器 ===============
	
	/// @func Matrix3x2.CreateTranslation(x, y)
	/// @desc 创建平移矩阵。
	/// @param {Real} x X 平移量
	/// @param {Real} y Y 平移量
	/// @returns {Matrix3x2}
	static CreateTranslationXY = function(_x, _y) { return new Matrix3x2(1, 0, 0, 1, _x, _y); };

	/// @func Matrix3x2.CreateTranslation(v)
	/// @desc 从 Vector2 创建平移矩阵。
	/// @param {Vector2} v 平移向量（type="Vector2"）
	/// @returns {Matrix3x2}
	static CreateTranslationVector = function(_v) { return new Matrix3x2(1, 0, 0, 1, _v.x, _v.y); };

	// =============== 工具方法 ===============
	
	/// @func Matrix3x2.CreateFromMatrix4x4(mat)
	/// @desc 从 Matrix4x4 提取 2D 仿射部分（仅适用于正交 2D 变换）。
	/// @param {Matrix4x4} mat 4x4 矩阵
	/// @returns {Matrix3x2}
	static CreateFromMatrix4x4 = function(_mat) {
		return new Matrix3x2(
			_mat.m00, _mat.m01,
			_mat.m10, _mat.m11,
			_mat.m30, _mat.m31
		);
	};
}