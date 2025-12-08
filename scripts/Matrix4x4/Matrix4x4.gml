/// @func Matrix4x4(m00, m01, ..., m33)
/// @desc 4x4 矩阵构造器；支持 (Matrix3x2) 或 16 个分量；默认为单位矩阵。
/// @param {Matrix3x2 | Real} [m00=1] Matrix3x2 或 m00
/// @param {Real} [m01=0] m01
/// @param {Real} [m02=0] m02
/// @param {Real} [m03=0] m03
/// @param {Real} [m10=0] m10
/// @param {Real} [m11=1] m11
/// @param {Real} [m12=0] m12
/// @param {Real} [m13=0] m13
/// @param {Real} [m20=0] m20
/// @param {Real} [m21=0] m21
/// @param {Real} [m22=1] m22
/// @param {Real} [m23=0] m23
/// @param {Real} [m30=0] m30
/// @param {Real} [m31=0] m31
/// @param {Real} [m32=0] m32
/// @param {Real} [m33=1] m33
/// @returns {Matrix4x4}
function Matrix4x4(_m00 = 1, _m01 = 0, _m02 = 0, _m03 = 0, _m10 = 0, _m11 = 1, _m12 = 0, _m13 = 0, _m20 = 0, _m21 = 0, _m22 = 1, _m23 = 0, _m30 = 0, _m31 = 0, _m32 = 0, _m33 = 1) constructor {
	self.type = "Matrix4x4";

	if (is_struct(_m00) && _m00.type == "Matrix3x2") {
		self.m00 = _m00.m11; self.m01 = _m00.m12; self.m02 = 0; self.m03 = 0;
		self.m10 = _m00.m21; self.m11 = _m00.m22; self.m12 = 0; self.m13 = 0;
		self.m20 = 0;        self.m21 = 0;        self.m22 = 1; self.m23 = 0;
		self.m30 = _m00.m31; self.m31 = _m00.m32; self.m32 = 0; self.m33 = 1;
	} else {
		self.m00 = _m00; self.m01 = _m01; self.m02 = _m02; self.m03 = _m03;
		self.m10 = _m10; self.m11 = _m11; self.m12 = _m12; self.m13 = _m13;
		self.m20 = _m20; self.m21 = _m21; self.m22 = _m22; self.m23 = _m23;
		self.m30 = _m30; self.m31 = _m31; self.m32 = _m32; self.m33 = _m33;
	}

	// =============== 实例方法 ===============
	
	self.Add = function(_other) {
		return new Matrix4x4(
			self.m00 + _other.m00, self.m01 + _other.m01, self.m02 + _other.m02, self.m03 + _other.m03,
			self.m10 + _other.m10, self.m11 + _other.m11, self.m12 + _other.m12, self.m13 + _other.m13,
			self.m20 + _other.m20, self.m21 + _other.m21, self.m22 + _other.m22, self.m23 + _other.m23,
			self.m30 + _other.m30, self.m31 + _other.m31, self.m32 + _other.m32, self.m33 + _other.m33
		);
	};
	self.Subtract = function(_other) {
		return new Matrix4x4(
			self.m00 - _other.m00, self.m01 - _other.m01, self.m02 - _other.m02, self.m03 - _other.m03,
			self.m10 - _other.m10, self.m11 - _other.m11, self.m12 - _other.m12, self.m13 - _other.m13,
			self.m20 - _other.m20, self.m21 - _other.m21, self.m22 - _other.m22, self.m23 - _other.m23,
			self.m30 - _other.m30, self.m31 - _other.m31, self.m32 - _other.m32, self.m33 - _other.m33
		);
	};
	self.Multiply = function(_arg) {
		if (is_struct(_arg) && _arg.type == "Matrix4x4") {
			var a = self; var b = _arg;
			return new Matrix4x4(
				a.m00*b.m00 + a.m01*b.m10 + a.m02*b.m20 + a.m03*b.m30,
				a.m00*b.m01 + a.m01*b.m11 + a.m02*b.m21 + a.m03*b.m31,
				a.m00*b.m02 + a.m01*b.m12 + a.m02*b.m22 + a.m03*b.m32,
				a.m00*b.m03 + a.m01*b.m13 + a.m02*b.m23 + a.m03*b.m33,

				a.m10*b.m00 + a.m11*b.m10 + a.m12*b.m20 + a.m13*b.m30,
				a.m10*b.m01 + a.m11*b.m11 + a.m12*b.m21 + a.m13*b.m31,
				a.m10*b.m02 + a.m11*b.m12 + a.m12*b.m22 + a.m13*b.m32,
				a.m10*b.m03 + a.m11*b.m13 + a.m12*b.m23 + a.m13*b.m33,

				a.m20*b.m00 + a.m21*b.m10 + a.m22*b.m20 + a.m23*b.m30,
				a.m20*b.m01 + a.m21*b.m11 + a.m22*b.m21 + a.m23*b.m31,
				a.m20*b.m02 + a.m21*b.m12 + a.m22*b.m22 + a.m23*b.m32,
				a.m20*b.m03 + a.m21*b.m13 + a.m22*b.m23 + a.m23*b.m33,

				a.m30*b.m00 + a.m31*b.m10 + a.m32*b.m20 + a.m33*b.m30,
				a.m30*b.m01 + a.m31*b.m11 + a.m32*b.m21 + a.m33*b.m31,
				a.m30*b.m02 + a.m31*b.m12 + a.m32*b.m22 + a.m33*b.m32,
				a.m30*b.m03 + a.m31*b.m13 + a.m32*b.m23 + a.m33*b.m33
			);
		} else {
			var _s = _arg;
			return new Matrix4x4(
				self.m00*_s, self.m01*_s, self.m02*_s, self.m03*_s,
				self.m10*_s, self.m11*_s, self.m12*_s, self.m13*_s,
				self.m20*_s, self.m21*_s, self.m22*_s, self.m23*_s,
				self.m30*_s, self.m31*_s, self.m32*_s, self.m33*_s
			);
		}
	};
	self.Negate = function() {
		return new Matrix4x4(
			-self.m00, -self.m01, -self.m02, -self.m03,
			-self.m10, -self.m11, -self.m12, -self.m13,
			-self.m20, -self.m21, -self.m22, -self.m23,
			-self.m30, -self.m31, -self.m32, -self.m33
		);
	};
	self.Equals = function(_other, _tolerance = 0.000001) {
		return (
			abs(self.m00 - _other.m00) <= _tolerance &&
			abs(self.m01 - _other.m01) <= _tolerance &&
			abs(self.m02 - _other.m02) <= _tolerance &&
			abs(self.m03 - _other.m03) <= _tolerance &&
			abs(self.m10 - _other.m10) <= _tolerance &&
			abs(self.m11 - _other.m11) <= _tolerance &&
			abs(self.m12 - _other.m12) <= _tolerance &&
			abs(self.m13 - _other.m13) <= _tolerance &&
			abs(self.m20 - _other.m20) <= _tolerance &&
			abs(self.m21 - _other.m21) <= _tolerance &&
			abs(self.m22 - _other.m22) <= _tolerance &&
			abs(self.m23 - _other.m23) <= _tolerance &&
			abs(self.m30 - _other.m30) <= _tolerance &&
			abs(self.m31 - _other.m31) <= _tolerance &&
			abs(self.m32 - _other.m32) <= _tolerance &&
			abs(self.m33 - _other.m33) <= _tolerance
		);
	};
	self.ToString = function() {
		return "Matrix4x4(" +
			string(self.m00) + ", " + string(self.m01) + ", " + string(self.m02) + ", " + string(self.m03) + ", " +
			string(self.m10) + ", " + string(self.m11) + ", " + string(self.m12) + ", " + string(self.m13) + ", " +
			string(self.m20) + ", " + string(self.m21) + ", " + string(self.m22) + ", " + string(self.m23) + ", " +
			string(self.m30) + ", " + string(self.m31) + ", " + string(self.m32) + ", " + string(self.m33) + ")";
	};
	self.GetDeterminant = function() {
		var a = self.m00, b = self.m01, c = self.m02, d = self.m03;
		var det = 
			a * (
				self.m11*(self.m22*self.m33 - self.m23*self.m32) -
				self.m12*(self.m21*self.m33 - self.m23*self.m31) +
				self.m13*(self.m21*self.m32 - self.m22*self.m31)
			) -
			b * (
				self.m10*(self.m22*self.m33 - self.m23*self.m32) -
				self.m12*(self.m20*self.m33 - self.m23*self.m30) +
				self.m13*(self.m20*self.m32 - self.m22*self.m30)
			) +
			c * (
				self.m10*(self.m21*self.m33 - self.m23*self.m31) -
				self.m11*(self.m20*self.m33 - self.m23*self.m30) +
				self.m13*(self.m20*self.m31 - self.m21*self.m30)
			) -
			d * (
				self.m10*(self.m21*self.m32 - self.m22*self.m31) -
				self.m11*(self.m20*self.m32 - self.m22*self.m30) +
				self.m12*(self.m20*self.m31 - self.m21*self.m30)
			);
		return det;
	};
	self.Invert = function() {
		var det = self.GetDeterminant();
		if (abs(det) < 0.000001) return undefined;
		var inv_det = 1 / det;

		var m = self;
		var inv = new Matrix4x4();

		inv.m00 = (m.m11*(m.m22*m.m33 - m.m23*m.m32) - m.m12*(m.m21*m.m33 - m.m23*m.m31) + m.m13*(m.m21*m.m32 - m.m22*m.m31)) * inv_det;
		inv.m01 = -(m.m01*(m.m22*m.m33 - m.m23*m.m32) - m.m02*(m.m21*m.m33 - m.m23*m.m31) + m.m03*(m.m21*m.m32 - m.m22*m.m31)) * inv_det;
		inv.m02 = (m.m01*(m.m12*m.m33 - m.m13*m.m32) - m.m02*(m.m11*m.m33 - m.m13*m.m31) + m.m03*(m.m11*m.m32 - m.m12*m.m31)) * inv_det;
		inv.m03 = -(m.m01*(m.m12*m.m23 - m.m13*m.m22) - m.m02*(m.m11*m.m23 - m.m13*m.m21) + m.m03*(m.m11*m.m22 - m.m12*m.m21)) * inv_det;

		inv.m10 = -(m.m10*(m.m22*m.m33 - m.m23*m.m32) - m.m12*(m.m20*m.m33 - m.m23*m.m30) + m.m13*(m.m20*m.m32 - m.m22*m.m30)) * inv_det;
		inv.m11 = (m.m00*(m.m22*m.m33 - m.m23*m.m32) - m.m02*(m.m20*m.m33 - m.m23*m.m30) + m.m03*(m.m20*m.m32 - m.m22*m.m30)) * inv_det;
		inv.m12 = -(m.m00*(m.m12*m.m33 - m.m13*m.m32) - m.m02*(m.m10*m.m33 - m.m13*m.m30) + m.m03*(m.m10*m.m32 - m.m12*m.m30)) * inv_det;
		inv.m13 = (m.m00*(m.m12*m.m23 - m.m13*m.m22) - m.m02*(m.m10*m.m23 - m.m13*m.m20) + m.m03*(m.m10*m.m22 - m.m12*m.m20)) * inv_det;

		inv.m20 = (m.m10*(m.m21*m.m33 - m.m23*m.m31) - m.m11*(m.m20*m.m33 - m.m23*m.m30) + m.m13*(m.m20*m.m31 - m.m21*m.m30)) * inv_det;
		inv.m21 = -(m.m00*(m.m21*m.m33 - m.m23*m.m31) - m.m01*(m.m20*m.m33 - m.m23*m.m30) + m.m03*(m.m20*m.m31 - m.m21*m.m30)) * inv_det;
		inv.m22 = (m.m00*(m.m11*m.m33 - m.m13*m.m31) - m.m01*(m.m10*m.m33 - m.m13*m.m30) + m.m03*(m.m10*m.m31 - m.m11*m.m30)) * inv_det;
		inv.m23 = -(m.m00*(m.m11*m.m23 - m.m13*m.m21) - m.m01*(m.m10*m.m23 - m.m13*m.m20) + m.m03*(m.m10*m.m21 - m.m11*m.m20)) * inv_det;

		inv.m30 = -(m.m10*(m.m21*m.m32 - m.m22*m.m31) - m.m11*(m.m20*m.m32 - m.m22*m.m30) + m.m12*(m.m20*m.m31 - m.m21*m.m30)) * inv_det;
		inv.m31 = (m.m00*(m.m21*m.m32 - m.m22*m.m31) - m.m01*(m.m20*m.m32 - m.m22*m.m30) + m.m02*(m.m20*m.m31 - m.m21*m.m30)) * inv_det;
		inv.m32 = -(m.m00*(m.m11*m.m32 - m.m12*m.m31) - m.m01*(m.m10*m.m32 - m.m12*m.m30) + m.m02*(m.m10*m.m31 - m.m11*m.m30)) * inv_det;
		inv.m33 = (m.m00*(m.m11*m.m22 - m.m12*m.m21) - m.m01*(m.m10*m.m22 - m.m12*m.m20) + m.m02*(m.m10*m.m21 - m.m11*m.m20)) * inv_det;

		return inv;
	};
	self.Lerp = function(_other, _t) {
		var t = clamp(_t, 0, 1);
		return new Matrix4x4(
			self.m00 + t*(_other.m00 - self.m00), self.m01 + t*(_other.m01 - self.m01), self.m02 + t*(_other.m02 - self.m02), self.m03 + t*(_other.m03 - self.m03),
			self.m10 + t*(_other.m10 - self.m10), self.m11 + t*(_other.m11 - self.m11), self.m12 + t*(_other.m12 - self.m12), self.m13 + t*(_other.m13 - self.m13),
			self.m20 + t*(_other.m20 - self.m20), self.m21 + t*(_other.m21 - self.m21), self.m22 + t*(_other.m22 - self.m22), self.m23 + t*(_other.m23 - self.m23),
			self.m30 + t*(_other.m30 - self.m30), self.m31 + t*(_other.m31 - self.m31), self.m32 + t*(_other.m32 - self.m32), self.m33 + t*(_other.m33 - self.m33)
		);
	};
	self.Transpose = function() {
		return new Matrix4x4(
			self.m00, self.m10, self.m20, self.m30,
			self.m01, self.m11, self.m21, self.m31,
			self.m02, self.m12, self.m22, self.m32,
			self.m03, self.m13, self.m23, self.m33
		);
	};
	self.ExtractFrustumPlanes = function() {
		var m = self;
		var planes = [];
		// Left
		planes[0] = new Plane(m.m30 + m.m00, m.m31 + m.m01, m.m32 + m.m02, m.m33 + m.m03).Normalize();
		// Right
		planes[1] = new Plane(m.m30 - m.m00, m.m31 - m.m01, m.m32 - m.m02, m.m33 - m.m03).Normalize();
		// Bottom
		planes[2] = new Plane(m.m30 + m.m10, m.m31 + m.m11, m.m32 + m.m12, m.m33 + m.m13).Normalize();
		// Top
		planes[3] = new Plane(m.m30 - m.m10, m.m31 - m.m11, m.m32 - m.m12, m.m33 - m.m13).Normalize();
		// Near
		planes[4] = new Plane(m.m20 + m.m30, m.m21 + m.m31, m.m22 + m.m32, m.m23 + m.m33).Normalize();
		// Far
		planes[5] = new Plane(m.m30 - m.m20, m.m31 - m.m21, m.m32 - m.m22, m.m33 - m.m23).Normalize();
		return planes;
	};

	// =============== 静态常量 ===============

	static Identity = new Matrix4x4();

	// =============== 静态方法 ===============

	/// @func Matrix4x4.Add(a, b)
	/// @desc 将两个 4x4 矩阵对应元素相加。
	/// @param {Matrix4x4} a 第一个矩阵
	/// @param {Matrix4x4} b 第二个矩阵
	/// @returns {Matrix4x4}
	static Add = function(_a, _b) { return _a.Add(_b); };

	/// @func Matrix4x4.Subtract(a, b)
	/// @desc 从第一个矩阵中减去第二个矩阵的对应元素。
	/// @param {Matrix4x4} a 被减矩阵
	/// @param {Matrix4x4} b 减矩阵
	/// @returns {Matrix4x4}
	static Subtract = function(_a, _b) { return _a.Subtract(_b); };

	/// @func Matrix4x4.Multiply(a, b_or_s)
	/// @desc 将两个矩阵相乘，或将矩阵与标量相乘。
	/// @param {Matrix4x4} a 第一个矩阵
	/// @param {Matrix4x4 | Real} b_or_s 第二个矩阵或标量
	/// @returns {Matrix4x4}
	static Multiply = function(_a, _b) { return _a.Multiply(_b); };

	/// @func Matrix4x4.Negate(m)
	/// @desc 对矩阵所有元素取反。
	/// @param {Matrix4x4} m 输入矩阵
	/// @returns {Matrix4x4}
	static Negate = function(_m) { return _m.Negate(); };

	/// @func Matrix4x4.Equals(a, b, tolerance)
	/// @desc 判断两个矩阵是否在容差范围内相等。
	/// @param {Matrix4x4} a 第一个矩阵
	/// @param {Matrix4x4} b 第二个矩阵
	/// @param {Real} [tolerance=0.000001] 比较容差
	/// @returns {Bool}
	static Equals = function(_a, _b, _tolerance = 0.000001) { return _a.Equals(_b, _tolerance); };

	/// @func Matrix4x4.Lerp(a, b, t)
	/// @desc 在两个矩阵之间线性插值。
	/// @param {Matrix4x4} a 起始矩阵
	/// @param {Matrix4x4} b 目标矩阵
	/// @param {Real} t 插值因子 [0,1]
	/// @returns {Matrix4x4}
	static Lerp = function(_a, _b, _t) { return _a.Lerp(_b, _t); };

	/// @func Matrix4x4.GetDeterminant(m)
	/// @desc 计算 4x4 矩阵的行列式。
	/// @param {Matrix4x4} m 输入矩阵
	/// @returns {Real}
	static GetDeterminant = function(_m) { return _m.GetDeterminant(); };

	/// @func Matrix4x4.Invert(m)
	/// @desc 对 4x4 矩阵求逆；若不可逆（行列式≈0），返回 undefined。
	/// @param {Matrix4x4} m 要求逆的矩阵
	/// @returns {Matrix4x4 | undefined}
	static Invert = function(_m) { return _m.Invert(); };

	/// @func Matrix4x4.Transpose(m)
	/// @desc 转置矩阵的行和列。
	/// @param {Matrix4x4} m 输入矩阵
	/// @returns {Matrix4x4}
	static Transpose = function(_m) { return _m.Transpose(); };

	// ====== 旋转 ======
	
	/// @func Matrix4x4.CreateRotationX(radians)
	/// @desc 创建绕 X 轴旋转的 4x4 矩阵（右手系）。
	/// @param {Real} radians 旋转角度（弧度）
	/// @returns {Matrix4x4}
	static CreateRotationX = function(_radians) {
		var c = cos(_radians), s = sin(_radians);
		return new Matrix4x4(
			1, 0, 0, 0,
			0, c, s, 0,
			0,-s, c, 0,
			0, 0, 0, 1
		);
	};

	/// @func Matrix4x4.CreateRotationY(radians)
	/// @desc 创建绕 Y 轴旋转的 4x4 矩阵（右手系）。
	/// @param {Real} radians 旋转角度（弧度）
	/// @returns {Matrix4x4}
	static CreateRotationY = function(_radians) {
		var c = cos(_radians), s = sin(_radians);
		return new Matrix4x4(
			 c, 0,-s, 0,
			 0, 1, 0, 0,
			 s, 0, c, 0,
			 0, 0, 0, 1
		);
	};

	/// @func Matrix4x4.CreateRotationZ(radians)
	/// @desc 创建绕 Z 轴旋转的 4x4 矩阵（右手系）。
	/// @param {Real} radians 旋转角度（弧度）
	/// @returns {Matrix4x4}
	static CreateRotationZ = function(_radians) {
		var c = cos(_radians), s = sin(_radians);
		return new Matrix4x4(
			c, s, 0, 0,
			-s, c, 0, 0,
			0, 0, 1, 0,
			0, 0, 0, 1
		);
	};

	// ====== 缩放 ======
	
	/// @func Matrix4x4.CreateScale(s)
	/// @desc 创建统一缩放矩阵（绕原点）。
	/// @param {Real} s 缩放比例
	/// @returns {Matrix4x4}
	static CreateScaleUniform = function(_s) {
		return new Matrix4x4(_s,0,0,0, 0,_s,0,0, 0,0,_s,0, 0,0,0,1);
	};

	/// @func Matrix4x4.CreateScale(x, y, z)
	/// @desc 创建非统一缩放矩阵（绕原点）。
	/// @param {Real} x X 缩放
	/// @param {Real} y Y 缩放
	/// @param {Real} z Z 缩放
	/// @returns {Matrix4x4}
	static CreateScaleXYZ = function(_x, _y, _z) {
		return new Matrix4x4(_x,0,0,0, 0,_y,0,0, 0,0,_z,0, 0,0,0,1);
	};

	/// @func Matrix4x4.CreateScale(v)
	/// @desc 从 Vector3 创建缩放矩阵（绕原点）。
	/// @param {Vector3} v 缩放向量
	/// @returns {Matrix4x4}
	static CreateScaleVector = function(_v) {
		return new Matrix4x4(_v.x,0,0,0, 0,_v.y,0,0, 0,0,_v.z,0, 0,0,0,1);
	};

	// ====== 平移 ======
	
	/// @func Matrix4x4.CreateTranslation(x, y, z)
	/// @desc 创建平移矩阵。
	/// @param {Real} x X 平移
	/// @param {Real} y Y 平移
	/// @param {Real} z Z 平移
	/// @returns {Matrix4x4}
	static CreateTranslationXYZ = function(_x, _y, _z) {
		return new Matrix4x4(1,0,0,0, 0,1,0,0, 0,0,1,0, _x,_y,_z,1);
	};

	/// @func Matrix4x4.CreateTranslation(v)
	/// @desc 从 Vector3 创建平移矩阵。
	/// @param {Vector3} v 平移向量
	/// @returns {Matrix4x4}
	static CreateTranslationVector = function(_v) {
		return new Matrix4x4(1,0,0,0, 0,1,0,0, 0,0,1,0, _v.x,_v.y,_v.z,1);
	};

	// ====== 四元数 ======
	
	/// @func Matrix4x4.CreateFromQuaternion(q)
	/// @desc 从四元数创建右手系旋转矩阵。
	/// @param {Quaternion} q 旋转四元数
	/// @returns {Matrix4x4}
	static CreateFromQuaternion = function(_q) {
		var _x = _q.x, _y = _q.y, z = _q.z, w = _q.w;
		var xx = _x * _x, yy = _y * _y, zz = z * z;
		var xy = _x * _y, xz = _x * z, yz = _y * z;
		var wx = w * _x, wy = w * _y, wz = w * z;

		return new Matrix4x4(
			1 - 2*(yy + zz),     2*(xy - wz),         2*(xz + wy),         0,
			2*(xy + wz),         1 - 2*(xx + zz),     2*(yz - wx),         0,
			2*(xz - wy),         2*(yz + wx),         1 - 2*(xx + yy),     0,
			0,                   0,                   0,                   1
		);
	};
	// ====== 视图矩阵 ======
	/// @func Matrix4x4.CreateLookAt(eye, target, up)
	/// @desc 创建右手视图矩阵（相机在 eye，看向 target，up 为上方向）。
	/// @param {Vector3} eye 相机位置
	/// @param {Vector3} target 目标点
	/// @param {Vector3} up 上方向
	/// @returns {Matrix4x4}
	static CreateLookAt = function(_eye, _target, _up) {
		var zaxis = _target.Subtract(_eye).Normalize();
		var xaxis = _up.Cross(zaxis).Normalize();
		var yaxis = zaxis.Cross(xaxis).Normalize();
		return new Matrix4x4(
			xaxis.x, yaxis.x, zaxis.x, 0,
			xaxis.y, yaxis.y, zaxis.y, 0,
			xaxis.z, yaxis.z, zaxis.z, 0,
			-xaxis.Dot(_eye), -yaxis.Dot(_eye), -zaxis.Dot(_eye), 1
		);
	};

	// ====== 投影矩阵 ======
	
	/// @func Matrix4x4.CreatePerspectiveFieldOfView(fov, aspect, near, far)
	/// @desc 创建右手透视投影矩阵；fov 为垂直视野（弧度）。
	/// @param {Real} fov 垂直视野（弧度）
	/// @param {Real} aspect 宽高比
	/// @param {Real} near 近裁剪面 (>0)
	/// @param {Real} far 远裁剪面 (>near)
	/// @returns {Matrix4x4}
	static CreatePerspectiveFieldOfView = function(_fov, _aspect, _near, _far) {
	    var h = 1 / tan(_fov * 0.5);
	    var w = h / _aspect;
	    var q = _far / (_far - _near);
	    return new Matrix4x4(
	        w, 0, 0, 0,
	        0, h, 0, 0,
	        0, 0, q, -1,
	        0, 0, q * _near, 0
	    );
	};

	// ====== 其他函数 ======
	
	/// @func Matrix4x4.CreateFromMatrix3x2(mat)
	/// @desc 从 Matrix3x2 创建 Matrix4x4（嵌入到左上 2x2 + 平移，Z 保持单位）。
	/// @param {Matrix3x2} mat 2D 仿射变换矩阵
	/// @returns {Matrix4x4}
	static CreateFromMatrix3x2 = function(_mat) { return new Matrix4x4(_mat); };

	/// @func Matrix4x4.CreateFromAxisAngle(axis, angle)
	/// @desc 创建绕任意向量旋转的矩阵。
	/// @param {Vector3} axis 旋转轴（需单位向量）
	/// @param {Real} angle 旋转角度（弧度）
	/// @returns {Matrix4x4}
	static CreateFromAxisAngle = function(_axis, _angle) {
		var q = Quaternion.CreateFromAxisAngle(_axis, _angle);
		return Matrix4x4.CreateFromQuaternion(q);
	};

	/// @func Matrix4x4.CreateFromYawPitchRoll(yaw, pitch, roll)
	/// @desc 从欧拉角创建旋转矩阵（Y-X-Z 顺序）。
	/// @param {Real} yaw 绕 Y 轴
	/// @param {Real} pitch 绕 X 轴
	/// @param {Real} roll 绕 Z 轴
	/// @returns {Matrix4x4}
	static CreateFromYawPitchRoll = function(_yaw, _pitch, _roll) {
		var q = new Quaternion().CreateFromYawPitchRoll(_yaw, _pitch, _roll);
		return CreateFromQuaternion(q);
	};
	
	/// @func Matrix4x4.CreateBillboard(objectPos, cameraPos, cameraUp, cameraForward)
	/// @desc 创建球面公告牌矩阵（始终面向相机）。
	/// @param {Vector3} objectPos 对象位置
	/// @param {Vector3} cameraPos 相机位置
	/// @param {Vector3} cameraUp 相机上方向
	/// @param {Vector3} cameraForward 相机前方向（可为 Zero）
	/// @returns {Matrix4x4}
	static CreateBillboard = function(_objectPos, _cameraPos, _cameraUp, _cameraForward) {
		var _diff = _objectPos.Subtract(_cameraPos);
		if (_diff.LengthSquared() < 0.000001) {
			_diff = Vector3.UnitZ;
		}
		var _zaxis = _diff.Normalize();
		var _xaxis, _yaxis;

		if (_cameraForward.Equals(Vector3.Zero)) {
			_yaxis = _cameraUp;
			_xaxis = _yaxis.Cross(_zaxis).Normalize();
			_yaxis = _zaxis.Cross(_xaxis).Normalize();
		} else {
			_xaxis = _cameraForward.Cross(_cameraUp).Normalize();
			_yaxis = _zaxis.Cross(_xaxis).Normalize();
		}

		return new Matrix4x4(
			_xaxis.x, _yaxis.x, _zaxis.x, 0,
			_xaxis.y, _yaxis.y, _zaxis.y, 0,
			_xaxis.z, _yaxis.z, _zaxis.z, 0,
			_objectPos.x, _objectPos.y, _objectPos.z, 1
		);
	};

	/// @func Matrix4x4.CreateConstrainedBillboard(objectPos, cameraPos, rotateAxis, cameraForward, objectForward)
	/// @desc 创建柱面公告牌矩阵（绕指定轴旋转）。
	/// @param {Vector3} objectPos 对象位置
	/// @param {Vector3} cameraPos 相机位置
	/// @param {Vector3} rotateAxis 旋转约束轴
	/// @param {Vector3} cameraForward 相机前方向
	/// @param {Vector3} objectForward 对象前方向
	/// @returns {Matrix4x4}
	static CreateConstrainedBillboard = function(_objectPos, _cameraPos, _rotateAxis, _cameraForward, _objectForward) {
		var _zaxis = _rotateAxis.Normalize();
		var _diff = _cameraPos.Subtract(_objectPos);
		var _xaxis = _diff.Subtract(_zaxis.Multiply(_diff.Dot(_zaxis))).Normalize();
		var _yaxis = _zaxis.Cross(_xaxis).Normalize();

		return new Matrix4x4(
			_xaxis.x, _yaxis.x, _zaxis.x, 0,
			_xaxis.y, _yaxis.y, _zaxis.y, 0,
			_xaxis.z, _yaxis.z, _zaxis.z, 0,
			_objectPos.x, _objectPos.y, _objectPos.z, 1
		);
	};

	/// @func Matrix4x4.CreateLookAtLeftHanded(eye, target, up)
	/// @desc 创建左手视图矩阵。
	/// @param {Vector3} eye 相机位置
	/// @param {Vector3} target 目标点
	/// @param {Vector3} up 上方向
	/// @returns {Matrix4x4}
	static CreateLookAtLeftHanded = function(_eye, _target, _up) {
		var zaxis = _target.Subtract(_eye).Normalize();
		var xaxis = _up.Cross(zaxis).Normalize();
		var yaxis = zaxis.Cross(xaxis).Normalize();
		return new Matrix4x4(
			xaxis.x, yaxis.x, zaxis.x, 0,
			xaxis.y, yaxis.y, zaxis.y, 0,
			xaxis.z, yaxis.z, zaxis.z, 0,
			-xaxis.Dot(_eye), -yaxis.Dot(_eye), -zaxis.Dot(_eye), 1
		);
	};

	/// @func Matrix4x4.CreateOrthographic(width, height, zNear, zFar)
	/// @desc 创建右手正交投影矩阵。
	/// @param {Real} width 视体宽度
	/// @param {Real} height 视体高度
	/// @param {Real} zNear 近裁剪面
	/// @param {Real} zFar 远裁剪面
	/// @returns {Matrix4x4}
	static CreateOrthographic = function(_width, _height, _zNear, _zFar) {
		return new Matrix4x4(
			2/_width, 0, 0, 0,
			0, 2/_height, 0, 0,
			0, 0, 1/(_zNear - _zFar), 0,
			0, 0, _zNear/(_zNear - _zFar), 1
		);
	};

	/// @func Matrix4x4.CreateOrthographicLeftHanded(width, height, zNear, zFar)
	/// @desc 创建左手正交投影矩阵。
	/// @param {Real} width 视体宽度
	/// @param {Real} height 视体高度
	/// @param {Real} zNear 近裁剪面
	/// @param {Real} zFar 远裁剪面
	/// @returns {Matrix4x4}
	static CreateOrthographicLeftHanded = function(_width, _height, _zNear, _zFar) {
		return new Matrix4x4(
			2/_width, 0, 0, 0,
			0, 2/_height, 0, 0,
			0, 0, 1/(_zFar - _zNear), 0,
			0, 0, _zNear/(_zNear - _zFar), 1
		);
	};

	/// @func Matrix4x4.CreateOrthographicOffCenter(left, right, bottom, top, zNear, zFar)
	/// @desc 创建右手自定义正交投影矩阵。
	/// @param {Real} left 左平面
	/// @param {Real} right 右平面
	/// @param {Real} bottom 下平面
	/// @param {Real} top 上平面
	/// @param {Real} zNear 近裁剪面
	/// @param {Real} zFar 远裁剪面
	/// @returns {Matrix4x4}
	static CreateOrthographicOffCenter = function(_left, _right, _bottom, _top, _zNear, _zFar) {
		return new Matrix4x4(
			2/(_right - _left), 0, 0, 0,
			0, 2/(_top - _bottom), 0, 0,
			0, 0, 1/(_zNear - _zFar), 0,
			(_left + _right)/(_left - _right), (_top + _bottom)/(_bottom - _top), _zNear/(_zNear - _zFar), 1
		);
	};

	/// @func Matrix4x4.CreateOrthographicOffCenterLeftHanded(left, right, bottom, top, zNear, zFar)
	/// @desc 创建左手自定义正交投影矩阵。
	/// @param {Real} left 左平面
	/// @param {Real} right 右平面
	/// @param {Real} bottom 下平面
	/// @param {Real} top 上平面
	/// @param {Real} zNear 近裁剪面
	/// @param {Real} zFar 远裁剪面
	/// @returns {Matrix4x4}
	static CreateOrthographicOffCenterLeftHanded = function(_left, _right, _bottom, _top, _zNear, _zFar) {
		return new Matrix4x4(
			2/(_right - _left), 0, 0, 0,
			0, 2/(_top - _bottom), 0, 0,
			0, 0, 1/(_zFar - _zNear), 0,
			(_left + _right)/(_left - _right), (_top + _bottom)/(_bottom - _top), _zNear/(_zNear - _zFar), 1
		);
	};

	/// @func Matrix4x4.CreatePerspective(width, height, zNear, zFar)
	/// @desc 创建右手透视投影矩阵。
	/// @param {Real} width 近平面宽度
	/// @param {Real} height 近平面高度
	/// @param {Real} zNear 近裁剪面
	/// @param {Real} zFar 远裁剪面
	/// @returns {Matrix4x4}
	static CreatePerspective = function(_width, _height, _zNear, _zFar) {
		return new Matrix4x4(
			2*_zNear/_width, 0, 0, 0,
			0, 2*_zNear/_height, 0, 0,
			0, 0, _zFar/(_zNear - _zFar), -1,
			0, 0, _zNear*_zFar/(_zNear - _zFar), 0
		);
	};

	/// @func Matrix4x4.CreatePerspectiveLeftHanded(width, height, zNear, zFar)
	/// @desc 创建左手透视投影矩阵。
	/// @param {Real} width 近平面宽度
	/// @param {Real} height 近平面高度
	/// @param {Real} zNear 近裁剪面
	/// @param {Real} zFar 远裁剪面
	/// @returns {Matrix4x4}
	static CreatePerspectiveLeftHanded = function(_width, _height, _zNear, _zFar) {
		return new Matrix4x4(
			2*_zNear/_width, 0, 0, 0,
			0, 2*_zNear/_height, 0, 0,
			0, 0, _zFar/(_zFar - _zNear), 1,
			0, 0, _zNear*_zFar/(_zNear - _zFar), 0
		);
	};

	/// @func Matrix4x4.CreatePerspectiveOffCenter(left, right, bottom, top, zNear, zFar)
	/// @desc 创建右手自定义透视投影矩阵。
	/// @param {Real} left 左平面
	/// @param {Real} right 右平面
	/// @param {Real} bottom 下平面
	/// @param {Real} top 上平面
	/// @param {Real} zNear 近裁剪面
	/// @param {Real} zFar 远裁剪面
	/// @returns {Matrix4x4}
	static CreatePerspectiveOffCenter = function(_left, _right, _bottom, _top, _zNear, _zFar) {
		return new Matrix4x4(
			2*_zNear/(_right - _left), 0, 0, 0,
			0, 2*_zNear/(_top - _bottom), 0, 0,
			(_left + _right)/(_right - _left), (_top + _bottom)/(_top - _bottom), _zFar/(_zNear - _zFar), -1,
			0, 0, _zNear*_zFar/(_zNear - _zFar), 0
		);
	};

	/// @func Matrix4x4.CreatePerspectiveOffCenterLeftHanded(left, right, bottom, top, zNear, zFar)
	/// @desc 创建左手自定义透视投影矩阵。
	/// @param {Real} left 左平面
	/// @param {Real} right 右平面
	/// @param {Real} bottom 下平面
	/// @param {Real} top 上平面
	/// @param {Real} zNear 近裁剪面
	/// @param {Real} zFar 远裁剪面
	/// @returns {Matrix4x4}
	static CreatePerspectiveOffCenterLeftHanded = function(_left, _right, _bottom, _top, _zNear, _zFar) {
		return new Matrix4x4(
			2*_zNear/(_right - _left), 0, 0, 0,
			0, 2*_zNear/(_top - _bottom), 0, 0,
			(_left + _right)/(_right - _left), (_top + _bottom)/(_top - _bottom), _zFar/(_zFar - _zNear), 1,
			0, 0, _zNear*_zFar/(_zNear - _zFar), 0
		);
	};

	/// @func Matrix4x4.CreateReflection(plane)
	/// @desc 创建关于平面的反射矩阵。
	/// @param {Plane} plane 反射平面
	/// @returns {Matrix4x4}
	static CreateReflection = function(_plane) {
		var _a = _plane.normal.x;
		var _b = _plane.normal.y;
		var _c = _plane.normal.z;
		var _d = _plane.distance;
		return new Matrix4x4(
			1-2*_a*_a,  -2*_a*_b,   -2*_a*_c,   0,
			-2*_a*_b,   1-2*_b*_b,  -2*_b*_c,   0,
			-2*_a*_c,   -2*_b*_c,   1-2*_c*_c,  0,
			-2*_a*_d,   -2*_b*_d,   -2*_c*_d,   1
		);
	};

	/// @func Matrix4x4.CreateShadow(lightDir, plane)
	/// @desc 创建阴影投影矩阵（将几何体投影到平面上）。
	/// @param {Vector3} lightDir 光源方向（需单位向量）
	/// @param {Plane} plane 投影平面
	/// @returns {Matrix4x4}
	static CreateShadow = function(_lightDir, _plane) {
		var _dot = _plane.normal.Dot(_lightDir);
		if (abs(_dot) < 0.000001) {
			return Matrix4x4.Identity;
		}
		var _a = _plane.normal.x;
		var _b = _plane.normal.y;
		var _c = _plane.normal.z;
		var _d = _plane.distance;
		var _x = -_lightDir.x;
		var _y = -_lightDir.y;
		var _z = -_lightDir.z;
		var _w = -_dot;

		return new Matrix4x4(
			_w - _a*_x,    -_a*_y,        -_a*_z,        -_a*_w,
			-_b*_x,        _w - _b*_y,    -_b*_z,        -_b*_w,
			-_c*_x,        -_c*_y,        _w - _c*_z,    -_c*_w,
			-_d*_x,        -_d*_y,        -_d*_z,        _w - _d*_w
		);
	};

	/// @func Matrix4x4.CreateViewport(x, y, width, height, minZ, maxZ)
	/// @desc 创建右手视口变换矩阵。
	/// @param {Real} x 视口左上角 X
	/// @param {Real} y 视口左上角 Y
	/// @param {Real} width 视口宽度
	/// @param {Real} height 视口高度
	/// @param {Real} minZ 最小深度
	/// @param {Real} maxZ 最大深度
	/// @returns {Matrix4x4}
	static CreateViewport = function(_x, _y, _width, _height, _minZ, _maxZ) {
		return new Matrix4x4(
			_width * 0.5, 0, 0, 0,
			0, -_height * 0.5, 0, 0,
			0, 0, _maxZ - _minZ, 0,
			_x + _width * 0.5, _y + _height * 0.5, _minZ, 1
		);
	};

	/// @func Matrix4x4.CreateViewportLeftHanded(x, y, width, height, minZ, maxZ)
	/// @desc 创建左手视口变换矩阵。
	/// @param {Real} x 视口左上角 X
	/// @param {Real} y 视口左上角 Y
	/// @param {Real} width 视口宽度
	/// @param {Real} height 视口高度
	/// @param {Real} minZ 最小深度
	/// @param {Real} maxZ 最大深度
	/// @returns {Matrix4x4}
	static CreateViewportLeftHanded = function(_x, _y, _width, _height, _minZ, _maxZ) {
		return new Matrix4x4(
			_width * 0.5, 0, 0, 0,
			0, _height * 0.5, 0, 0,
			0, 0, _maxZ - _minZ, 0,
			_x + _width * 0.5, _y + _height * 0.5, _minZ, 1
		);
	};

	/// @func Matrix4x4.CreateWorld(position, forward, up)
	/// @desc 创建世界变换矩阵。
	/// @param {Vector3} position 位置
	/// @param {Vector3} forward 前方向（需单位向量）
	/// @param {Vector3} up 上方向（需单位向量）
	/// @returns {Matrix4x4}
	static CreateWorld = function(_position, _forward, _up) {
		var _zaxis = _forward.Normalize();
		var _xaxis = _up.Cross(_zaxis).Normalize();
		var _yaxis = _zaxis.Cross(_xaxis).Normalize();
		return new Matrix4x4(
			_xaxis.x, _yaxis.x, _zaxis.x, 0,
			_xaxis.y, _yaxis.y, _zaxis.y, 0,
			_xaxis.z, _yaxis.z, _zaxis.z, 0,
			_position.x, _position.y, _position.z, 1
		);
	};

	/// @func Matrix4x4.Decompose(matrix, scale, rotation, translation)
	/// @desc 从矩阵提取缩放、旋转、平移分量；成功返回 true。
	/// @param {Matrix4x4} matrix 输入矩阵
	/// @param {Vector3} scale 输出缩放（引用）
	/// @param {Quaternion} rotation 输出旋转（引用）
	/// @param {Vector3} translation 输出平移（引用）
	/// @returns {Bool}
	static Decompose = function(_matrix, _scale, _rotation, _translation) {
		// 提取平移
		_translation.x = _matrix.m30;
		_translation.y = _matrix.m31;
		_translation.z = _matrix.m32;

		// 提取缩放
		var sx = new Vector3(_matrix.m00, _matrix.m01, _matrix.m02).Length();
		var sy = new Vector3(_matrix.m10, _matrix.m11, _matrix.m12).Length();
		var sz = new Vector3(_matrix.m20, _matrix.m21, _matrix.m22).Length();
		_scale.x = sx; _scale.y = sy; _scale.z = sz;

		// 检查是否可逆
		if (sx < 0.000001 || sy < 0.000001 || sz < 0.000001) {
			_rotation.x = 0; _rotation.y = 0; _rotation.z = 0; _rotation.w = 1;
			return false;
		}

		// 归一化旋转部分
		var invSx = 1 / sx;
		var invSy = 1 / sy;
		var invSz = 1 / sz;
		var rotMat = new Matrix4x4(
			_matrix.m00 * invSx, _matrix.m01 * invSx, _matrix.m02 * invSx, 0,
			_matrix.m10 * invSy, _matrix.m11 * invSy, _matrix.m12 * invSy, 0,
			_matrix.m20 * invSz, _matrix.m21 * invSz, _matrix.m22 * invSz, 0,
			0, 0, 0, 1
		);

		// 从旋转矩阵转四元数
		var trace = rotMat.m00 + rotMat.m11 + rotMat.m22;
		var qx, qy, qz, qw;
		if (trace > 0) {
			var s = sqrt(trace + 1.0) * 2;
			qw = 0.25 * s;
			qx = (rotMat.m21 - rotMat.m12) / s;
			qy = (rotMat.m02 - rotMat.m20) / s;
			qz = (rotMat.m10 - rotMat.m01) / s;
		} else if (rotMat.m00 > rotMat.m11 && rotMat.m00 > rotMat.m22) {
			var s = sqrt(1.0 + rotMat.m00 - rotMat.m11 - rotMat.m22) * 2;
			qw = (rotMat.m21 - rotMat.m12) / s;
			qx = 0.25 * s;
			qy = (rotMat.m01 + rotMat.m10) / s;
			qz = (rotMat.m02 + rotMat.m20) / s;
		} else if (rotMat.m11 > rotMat.m22) {
			var s = sqrt(1.0 + rotMat.m11 - rotMat.m00 - rotMat.m22) * 2;
			qw = (rotMat.m02 - rotMat.m20) / s;
			qx = (rotMat.m01 + rotMat.m10) / s;
			qy = 0.25 * s;
			qz = (rotMat.m12 + rotMat.m21) / s;
		} else {
			var s = sqrt(1.0 + rotMat.m22 - rotMat.m00 - rotMat.m11) * 2;
			qw = (rotMat.m10 - rotMat.m01) / s;
			qx = (rotMat.m02 + rotMat.m20) / s;
			qy = (rotMat.m12 + rotMat.m21) / s;
			qz = 0.25 * s;
		}
		_rotation.x = qx; _rotation.y = qy; _rotation.z = qz; _rotation.w = qw;
		return true;
	};

	/// @func Matrix4x4.Transform(matrix, quaternion)
	/// @desc 将四元数旋转应用到矩阵的旋转部分。
	/// @param {Matrix4x4} matrix 输入矩阵
	/// @param {Quaternion} quaternion 旋转四元数
	/// @returns {Matrix4x4}
	static Transform = function(_matrix, _quaternion) {
		var rotMat = CreateFromQuaternion(_quaternion);
		// 保留原矩阵的缩放和平移
		var sx = new Vector3(_matrix.m00, _matrix.m01, _matrix.m02).Length();
		var sy = new Vector3(_matrix.m10, _matrix.m11, _matrix.m12).Length();
		var sz = new Vector3(_matrix.m20, _matrix.m21, _matrix.m22).Length();
		var tx = _matrix.m30;
		var ty = _matrix.m31;
		var tz = _matrix.m32;

		// 应用新旋转并恢复缩放
		return new Matrix4x4(
			rotMat.m00 * sx, rotMat.m01 * sx, rotMat.m02 * sx, 0,
			rotMat.m10 * sy, rotMat.m11 * sy, rotMat.m12 * sy, 0,
			rotMat.m20 * sz, rotMat.m21 * sz, rotMat.m22 * sz, 0,
			tx, ty, tz, 1
		);
	};
		
	/// @func Matrix4x4.ExtractFrustumPlanes(viewProj)
	/// @desc 从视图*投影矩阵中提取 6 个裁剪平面（右手系）。
	/// @param {Matrix4x4} viewProj 视图投影矩阵
	/// @returns {Array} Plane[6]
	static ExtractFrustumPlanes = function(_viewProj) { return _viewProj.ExtractFrustumPlanes(); };
}