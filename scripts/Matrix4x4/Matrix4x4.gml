/// @func Matrix4x4(m00, m01, ..., m33)
/// @desc 创建一个 4x4 矩阵结构。支持通过 16 个分量初始化，或通过单个数值、Matrix3x2 实例进行构造。
/// @arg {real|Matrix3x2} m00 - 若为数值，则所有元素设为此值；若为 Matrix3x2，则转换为 4x4 矩阵；否则视为 m00 分量
/// @arg {real} [m01] - 矩阵第 0 行第 1 列元素
/// @arg {real} [m02] - 矩阵第 0 行第 2 列元素
/// @arg {real} [m03] - 矩阵第 0 行第 3 列元素
/// @arg {real} [m10] - 矩阵第 1 行第 0 列元素
/// @arg {real} [m11] - 矩阵第 1 行第 1 列元素
/// @arg {real} [m12] - 矩阵第 1 行第 2 列元素
/// @arg {real} [m13] - 矩阵第 1 行第 3 列元素
/// @arg {real} [m20] - 矩阵第 2 行第 0 列元素
/// @arg {real} [m21] - 矩阵第 2 行第 1 列元素
/// @arg {real} [m22] - 矩阵第 2 行第 2 列元素
/// @arg {real} [m23] - 矩阵第 2 行第 3 列元素
/// @arg {real} [m30] - 矩阵第 3 行第 0 列元素
/// @arg {real} [m31] - 矩阵第 3 行第 1 列元素
/// @arg {real} [m32] - 矩阵第 3 行第 2 列元素
/// @arg {real} [m33] - 矩阵第 3 行第 3 列元素
/// @returns {struct} 包含 16 个分量和多种矩阵操作方法的 4x4 矩阵结构
Matrix4x4()
function Matrix4x4(m00 = 0, m01 = 0, m02 = 0, m03 = 0, m10 = 0, m11 = 0, m12 = 0, m13 = 0, m20 = 0, m21 = 0, m22 = 0, m23 = 0, m30 = 0, m31 = 0, m32 = 0, m33 = 0) {
	var Matrix4x4Struct = {
        type: "Matrix4x4",
        m00: m00, m01: m01, m02: m02, m03: m03,
		m10: m10, m11: m11, m12: m12, m13: m13,
		m20: m20, m21: m21, m22: m22, m23: m23,
		m30: m30, m31: m31, m32: m32, m33: m33,
        
		#region 实例方法
        Add: function(matrix) {
			if (is_real(matrix)) return Matrix4x4(
				self.m00 + matrix, self.m01 + matrix, self.m02 + matrix, self.m03 + matrix,
				self.m10 + matrix, self.m11 + matrix, self.m12 + matrix, self.m13 + matrix,
				self.m20 + matrix, self.m21 + matrix, self.m22 + matrix, self.m23 + matrix,
				self.m30 + matrix, self.m31 + matrix, self.m32 + matrix, self.m33 + matrix
			);
			
			return Matrix4x4(
				self.m00 + matrix.m00, self.m01 + matrix.m01, self.m02 + matrix.m02, self.m03 + matrix.m03,
				self.m10 + matrix.m10, self.m11 + matrix.m11, self.m12 + matrix.m12, self.m13 + matrix.m13,
				self.m20 + matrix.m20, self.m21 + matrix.m21, self.m22 + matrix.m22, self.m23 + matrix.m23,
				self.m30 + matrix.m30, self.m31 + matrix.m31, self.m32 + matrix.m32, self.m33 + matrix.m33
			);
        },
		Subtract: function(matrix) {
			if (is_real(matrix)) return Matrix4x4(
				self.m00 - matrix, self.m01 - matrix, self.m02 - matrix, self.m03 - matrix,
				self.m10 - matrix, self.m11 - matrix, self.m12 - matrix, self.m13 - matrix,
				self.m20 - matrix, self.m21 - matrix, self.m22 - matrix, self.m23 - matrix,
				self.m30 - matrix, self.m31 - matrix, self.m32 - matrix, self.m33 - matrix
			);
			
			return Matrix4x4(
				self.m00 - matrix.m00, self.m01 - matrix.m01, self.m02 - matrix.m02, self.m03 - matrix.m03,
				self.m10 - matrix.m10, self.m11 - matrix.m11, self.m12 - matrix.m12, self.m13 - matrix.m13,
				self.m20 - matrix.m20, self.m21 - matrix.m21, self.m22 - matrix.m22, self.m23 - matrix.m23,
				self.m30 - matrix.m30, self.m31 - matrix.m31, self.m32 - matrix.m32, self.m33 - matrix.m33
			);
        },
		Multiply: function(matrix) {
			if (is_real(matrix)) return Matrix4x4(
				self.m00 * matrix, self.m01 * matrix, self.m02 * matrix, self.m03 * matrix,
				self.m10 * matrix, self.m11 * matrix, self.m12 * matrix, self.m13 * matrix,
				self.m20 * matrix, self.m21 * matrix, self.m22 * matrix, self.m23 * matrix,
				self.m30 * matrix, self.m31 * matrix, self.m32 * matrix, self.m33 * matrix
			);
			
			return Matrix4x4(
				self.m00 * matrix.m00, self.m01 * matrix.m01, self.m02 * matrix.m02, self.m03 * matrix.m03,
				self.m10 * matrix.m10, self.m11 * matrix.m11, self.m12 * matrix.m12, self.m13 * matrix.m13,
				self.m20 * matrix.m20, self.m21 * matrix.m21, self.m22 * matrix.m22, self.m23 * matrix.m23,
				self.m30 * matrix.m30, self.m31 * matrix.m31, self.m32 * matrix.m32, self.m33 * matrix.m33
			);
        },
		Negate: function() {
			return Matrix4x4(
				-self.m00, -self.m01, -self.m02, -self.m03,
				-self.m10, -self.m11, -self.m12, -self.m13,
				-self.m20, -self.m21, -self.m22, -self.m23,
				-self.m30, -self.m31, -self.m32, -self.m33
			);
		},
		Equals: function(matrix, _tolerance = 0.000001) {
			return (
				abs(self.m00 - matrix.m00) <= _tolerance &&
				abs(self.m01 - matrix.m01) <= _tolerance &&
				abs(self.m02 - matrix.m02) <= _tolerance &&
				abs(self.m03 - matrix.m03) <= _tolerance &&
				abs(self.m10 - matrix.m10) <= _tolerance &&
				abs(self.m11 - matrix.m11) <= _tolerance &&
				abs(self.m12 - matrix.m12) <= _tolerance &&
				abs(self.m13 - matrix.m13) <= _tolerance &&
				abs(self.m20 - matrix.m20) <= _tolerance &&
				abs(self.m21 - matrix.m21) <= _tolerance &&
				abs(self.m22 - matrix.m22) <= _tolerance &&
				abs(self.m23 - matrix.m23) <= _tolerance &&
				abs(self.m30 - matrix.m30) <= _tolerance &&
				abs(self.m31 - matrix.m31) <= _tolerance &&
				abs(self.m32 - matrix.m32) <= _tolerance &&
				abs(self.m33 - matrix.m33) <= _tolerance
			);
		},
		ToString: function() {
			return "Matrix4x4(" +
				string(self.m00) + ", " + string(self.m01) + ", " + string(self.m02) + ", " + string(self.m03) + ", " +
				string(self.m10) + ", " + string(self.m11) + ", " + string(self.m12) + ", " + string(self.m13) + ", " +
				string(self.m20) + ", " + string(self.m21) + ", " + string(self.m22) + ", " + string(self.m23) + ", " +
				string(self.m30) + ", " + string(self.m31) + ", " + string(self.m32) + ", " + string(self.m33) + ")";
		},
		GetDeterminant: function() {
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
		},
		Invert: function() {
			var det = self.GetDeterminant();
			if (abs(det) < 0.000001) return undefined;
			var inv_det = 1 / det;
			var m = self;
			var inv = Matrix4x4();
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
		},
		Lerp: function(matrix, _t) {
			var t = clamp(_t, 0, 1);
			return Matrix4x4(
				self.m00 + t*(matrix.m00 - self.m00), self.m01 + t*(matrix.m01 - self.m01), self.m02 + t*(matrix.m02 - self.m02), self.m03 + t*(matrix.m03 - self.m03),
				self.m10 + t*(matrix.m10 - self.m10), self.m11 + t*(matrix.m11 - self.m11), self.m12 + t*(matrix.m12 - self.m12), self.m13 + t*(matrix.m13 - self.m13),
				self.m20 + t*(matrix.m20 - self.m20), self.m21 + t*(matrix.m21 - self.m21), self.m22 + t*(matrix.m22 - self.m22), self.m23 + t*(matrix.m23 - self.m23),
				self.m30 + t*(matrix.m30 - self.m30), self.m31 + t*(matrix.m31 - self.m31), self.m32 + t*(matrix.m32 - self.m32), self.m33 + t*(matrix.m33 - self.m33)
			);
		},
		Transpose: function() {
			return Matrix4x4(
				self.m00, self.m10, self.m20, self.m30,
				self.m01, self.m11, self.m21, self.m31,
				self.m02, self.m12, self.m22, self.m32,
				self.m03, self.m13, self.m23, self.m33
			);
		},
		ExtractFrustumPlanes: function() {
			var m = self;
			var planes = [];
			planes[0] = Plane(m.m30 + m.m00, m.m31 + m.m01, m.m32 + m.m02, m.m33 + m.m03).Normalize();
			planes[1] = Plane(m.m30 - m.m00, m.m31 - m.m01, m.m32 - m.m02, m.m33 - m.m03).Normalize();
			planes[2] = Plane(m.m30 + m.m10, m.m31 + m.m11, m.m32 + m.m12, m.m33 + m.m13).Normalize();
			planes[3] = Plane(m.m30 - m.m10, m.m31 - m.m11, m.m32 - m.m12, m.m33 - m.m13).Normalize();
			planes[4] = Plane(m.m20 + m.m30, m.m21 + m.m31, m.m22 + m.m32, m.m23 + m.m33).Normalize();
			planes[5] = Plane(m.m30 - m.m20, m.m31 - m.m21, m.m32 - m.m22, m.m33 - m.m23).Normalize();
			return planes;
		}
		#endregion
    };
	
	#region 参数处理
	var _mat = m00;
	if (argument_count == 1) {
		Matrix4x4Struct.m00 = _mat; Matrix4x4Struct.m01 = _mat; Matrix4x4Struct.m02 = _mat; Matrix4x4Struct.m03 = _mat;
		Matrix4x4Struct.m10 = _mat; Matrix4x4Struct.m11 = _mat; Matrix4x4Struct.m12 = _mat; Matrix4x4Struct.m13 = _mat;
		Matrix4x4Struct.m20 = _mat;	Matrix4x4Struct.m21 = _mat;	Matrix4x4Struct.m22 = _mat; Matrix4x4Struct.m23 = _mat;
		Matrix4x4Struct.m30 = _mat; Matrix4x4Struct.m31 = _mat; Matrix4x4Struct.m32 = _mat; Matrix4x4Struct.m33 = _mat;
	} else if (is_matrix3x2(m00)) {
		Matrix4x4Struct.m00 = _mat.m11; Matrix4x4Struct.m01 = _mat.m12; Matrix4x4Struct.m02 = 0; Matrix4x4Struct.m03 = 0;
		Matrix4x4Struct.m10 = _mat.m21; Matrix4x4Struct.m11 = _mat.m22; Matrix4x4Struct.m12 = 0; Matrix4x4Struct.m13 = 0;
		Matrix4x4Struct.m20 = 0;        Matrix4x4Struct.m21 = 0;        Matrix4x4Struct.m22 = 1; Matrix4x4Struct.m23 = 0;
		Matrix4x4Struct.m30 = _mat.m31; Matrix4x4Struct.m31 = _mat.m32; Matrix4x4Struct.m32 = 0; Matrix4x4Struct.m33 = 1;
	}
    #endregion
	
	#region 静态常量
	static Identity = Matrix4x4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
	#endregion
    
    #region 基础静态方法
    static Add = function(matrix, matrix2) { return matrix.Add(matrix2); };
	static Subtract = function(matrix, matrix2) { return matrix.Subtract(matrix2); };
	static Multiply = function(matrix, matrix2) { return matrix.Multiply(matrix2); };
	static Negate = function(matrix) { return matrix.Negate(); };
	static Equals = function(matrix, matrix2, _tolerance = 0.000001) { return matrix.Equals(matrix2, _tolerance); };
	static Lerp = function(matrix, matrix2, _t) { return matrix.Lerp(matrix2, _t); };
	static GetDeterminant = function(matrix) { return matrix.GetDeterminant(); };
	static Invert = function(matrix) { return matrix.Invert(); };
	static Transpose = function(matrix) { return matrix.Transpose(); };
    #endregion
	
	#region 变换构造器 - 变换矩阵
	static CreateTranslationXYZ = function(_x, _y, _z) {
		return Matrix4x4(1,0,0,0, 0,1,0,0, 0,0,1,0, _x,_y,_z,1);
	};
	static CreateTranslationVector = function(_v) {
		return Matrix4x4(1,0,0,0, 0,1,0,0, 0,0,1,0, _v.x,_v.y,_v.z,1);
	};
	static CreateScaleUniform = function(_s) {
		return Matrix4x4(_s,0,0,0, 0,_s,0,0, 0,0,_s,0, 0,0,0,1);
	};
	static CreateScaleXYZ = function(_x, _y, _z) {
		return Matrix4x4(_x,0,0,0, 0,_y,0,0, 0,0,_z,0, 0,0,0,1);
	};
	static CreateScaleVector = function(_v) {
		return Matrix4x4(_v.x,0,0,0, 0,_v.y,0,0, 0,0,_v.z,0, 0,0,0,1);
	};
	static CreateWorld = function(_position, _forward, _up) {
		var _zaxis = _forward.Normalize();
		var _xaxis = _up.Cross(_zaxis).Normalize();
		var _yaxis = _zaxis.Cross(_xaxis).Normalize();
		return Matrix4x4(
			_xaxis.x, _yaxis.x, _zaxis.x, 0,
			_xaxis.y, _yaxis.y, _zaxis.y, 0,
			_xaxis.z, _yaxis.z, _zaxis.z, 0,
			_position.x, _position.y, _position.z, 1
		);
	};
	#endregion
	
	#region 变换构造器 - 旋转变换
	static CreateRotationX = function(_radians) {
		var c = cos(_radians), s = sin(_radians);
		return Matrix4x4(1,0,0,0, 0,c,s,0, 0,-s,c,0, 0,0,0,1);
	};
	static CreateRotationY = function(_radians) {
		var c = cos(_radians), s = sin(_radians);
		return Matrix4x4(c,0,-s,0, 0,1,0,0, s,0,c,0, 0,0,0,1);
	};
	static CreateRotationZ = function(_radians) {
		var c = cos(_radians), s = sin(_radians);
		return Matrix4x4(c,s,0,0, -s,c,0,0, 0,0,1,0, 0,0,0,1);
	};
	static CreateFromQuaternion = function(_q) {
		var _x = _q.x, _y = _q.y, z = _q.z, w = _q.w;
		var xx = _x * _x, yy = _y * _y, zz = z * z;
		var xy = _x * _y, xz = _x * z, yz = _y * z;
		var wx = w * _x, wy = w * _y, wz = w * z;
		return Matrix4x4(
			1 - 2*(yy + zz),     2*(xy - wz),         2*(xz + wy),         0,
			2*(xy + wz),         1 - 2*(xx + zz),     2*(yz - wx),         0,
			2*(xz - wy),         2*(yz + wx),         1 - 2*(xx + yy),     0,
			0,                   0,                   0,                   1
		);
	};
	static CreateFromAxisAngle = function(_axis, _angle) {
		var q = Quaternion.CreateFromAxisAngle(_axis, _angle);
		return Matrix4x4.CreateFromQuaternion(q);
	};
	static CreateFromYawPitchRoll = function(_yaw, _pitch, _roll) {
		var q = Quaternion().CreateFromYawPitchRoll(_yaw, _pitch, _roll);
		return Matrix4x4.CreateFromQuaternion(q);
	};
	#endregion
	
	#region 变换构造器 - 视图矩阵
	static CreateLookAt = function(_eye, _target, _up) {
		var zaxis = _target.Subtract(_eye).Normalize();
		var xaxis = _up.Cross(zaxis).Normalize();
		var yaxis = zaxis.Cross(xaxis).Normalize();
		return Matrix4x4(
			xaxis.x, yaxis.x, zaxis.x, 0,
			xaxis.y, yaxis.y, zaxis.y, 0,
			xaxis.z, yaxis.z, zaxis.z, 0,
			-xaxis.Dot(_eye), -yaxis.Dot(_eye), -zaxis.Dot(_eye), 1
		);
	};
	static CreateLookAtLeftHanded = function(_eye, _target, _up) {
		var zaxis = _target.Subtract(_eye).Normalize();
		var xaxis = _up.Cross(zaxis).Normalize();
		var yaxis = zaxis.Cross(xaxis).Normalize();
		return Matrix4x4(
			xaxis.x, yaxis.x, zaxis.x, 0,
			xaxis.y, yaxis.y, zaxis.y, 0,
			xaxis.z, yaxis.z, zaxis.z, 0,
			-xaxis.Dot(_eye), -yaxis.Dot(_eye), -zaxis.Dot(_eye), 1
		);
	};
	#endregion
	
	#region 变换构造器 - 投影矩阵
	static CreatePerspectiveFieldOfView = function(_fov, _aspect, _near, _far) {
		var h = 1 / tan(_fov * 0.5);
		var w = h / _aspect;
		var q = _far / (_far - _near);
		return Matrix4x4(w,0,0,0, 0,h,0,0, 0,0,q,-1, 0,0,q*_near,0);
	};
	static CreatePerspective = function(_width, _height, _zNear, _zFar) {
		return Matrix4x4(2*_zNear/_width,0,0,0, 0,2*_zNear/_height,0,0, 0,0,_zFar/(_zNear-_zFar),-1, 0,0,_zNear*_zFar/(_zNear-_zFar),0);
	};
	static CreatePerspectiveLeftHanded = function(_width, _height, _zNear, _zFar) {
		return Matrix4x4(2*_zNear/_width,0,0,0, 0,2*_zNear/_height,0,0, 0,0,_zFar/(_zFar-_zNear),1, 0,0,_zNear*_zFar/(_zNear-_zFar),0);
	};
	static CreatePerspectiveOffCenter = function(_left, _right, _bottom, _top, _zNear, _zFar) {
		return Matrix4x4(2*_zNear/(_right-_left),0,0,0, 0,2*_zNear/(_top-_bottom),0,0, (_left+_right)/(_right-_left),(_top+_bottom)/(_top-_bottom),_zFar/(_zNear-_zFar),-1, 0,0,_zNear*_zFar/(_zNear-_zFar),0);
	};
	static CreatePerspectiveOffCenterLeftHanded = function(_left, _right, _bottom, _top, _zNear, _zFar) {
		return Matrix4x4(2*_zNear/(_right-_left),0,0,0, 0,2*_zNear/(_top-_bottom),0,0, (_left+_right)/(_right-_left),(_top+_bottom)/(_top-_bottom),_zFar/(_zFar-_zNear),1, 0,0,_zNear*_zFar/(_zNear-_zFar),0);
	};
	static CreateOrthographic = function(_width, _height, _zNear, _zFar) {
		return Matrix4x4(2/_width,0,0,0, 0,2/_height,0,0, 0,0,1/(_zNear-_zFar),0, 0,0,_zNear/(_zNear-_zFar),1);
	};
	static CreateOrthographicLeftHanded = function(_width, _height, _zNear, _zFar) {
		return Matrix4x4(2/_width,0,0,0, 0,2/_height,0,0, 0,0,1/(_zFar-_zNear),0, 0,0,_zNear/(_zNear-_zFar),1);
	};
	static CreateOrthographicOffCenter = function(_left, _right, _bottom, _top, _zNear, _zFar) {
		return Matrix4x4(2/(_right-_left),0,0,0, 0,2/(_top-_bottom),0,0, 0,0,1/(_zNear-_zFar),0, (_left+_right)/(_left-_right),(_top+_bottom)/(_bottom-_top),_zNear/(_zNear-_zFar),1);
	};
	static CreateOrthographicOffCenterLeftHanded = function(_left, _right, _bottom, _top, _zNear, _zFar) {
		return Matrix4x4(2/(_right-_left),0,0,0, 0,2/(_top-_bottom),0,0, 0,0,1/(_zFar-_zNear),0, (_left+_right)/(_left-_right),(_top+_bottom)/(_bottom-_top),_zNear/(_zNear-_zFar),1);
	};
	#endregion
	
	#region 变换构造器 - 视口变换
	static CreateViewport = function(_x, _y, _width, _height, _minZ, _maxZ) {
		return Matrix4x4(_width*0.5,0,0,0, 0,-_height*0.5,0,0, 0,0,_maxZ-_minZ,0, _x+_width*0.5,_y+_height*0.5,_minZ,1);
	};
	static CreateViewportLeftHanded = function(_x, _y, _width, _height, _minZ, _maxZ) {
		return Matrix4x4(_width*0.5,0,0,0, 0,_height*0.5,0,0, 0,0,_maxZ-_minZ,0, _x+_width*0.5,_y+_height*0.5,_minZ,1);
	};
	#endregion
	
	#region 变换构造器 - 特殊效果矩阵
	static CreateBillboard = function(_objectPos, _cameraPos, _cameraUp, _cameraForward) {
		var _diff = _objectPos.Subtract(_cameraPos);
		if (_diff.LengthSquared() < 0.000001) _diff = Vector3.UnitZ;
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
		return Matrix4x4(
			_xaxis.x, _yaxis.x, _zaxis.x, 0,
			_xaxis.y, _yaxis.y, _zaxis.y, 0,
			_xaxis.z, _yaxis.z, _zaxis.z, 0,
			_objectPos.x, _objectPos.y, _objectPos.z, 1
		);
	};
	static CreateConstrainedBillboard = function(_objectPos, _cameraPos, _rotateAxis, _cameraForward, _objectForward) {
		var _zaxis = _rotateAxis.Normalize();
		var _diff = _cameraPos.Subtract(_objectPos);
		var _xaxis = _diff.Subtract(_zaxis.Multiply(_diff.Dot(_zaxis))).Normalize();
		var _yaxis = _zaxis.Cross(_xaxis).Normalize();
		return Matrix4x4(
			_xaxis.x, _yaxis.x, _zaxis.x, 0,
			_xaxis.y, _yaxis.y, _zaxis.y, 0,
			_xaxis.z, _yaxis.z, _zaxis.z, 0,
			_objectPos.x, _objectPos.y, _objectPos.z, 1
		);
	};
	static CreateReflection = function(_plane) {
		var _a = _plane.normal.x, _b = _plane.normal.y, _c = _plane.normal.z, _d = _plane.distance;
		return Matrix4x4(
			1-2*_a*_a, -2*_a*_b, -2*_a*_c, 0,
			-2*_a*_b, 1-2*_b*_b, -2*_b*_c, 0,
			-2*_a*_c, -2*_b*_c, 1-2*_c*_c, 0,
			-2*_a*_d, -2*_b*_d, -2*_c*_d, 1
		);
	};
	static CreateShadow = function(_lightDir, _plane) {
		var _dot = _plane.normal.Dot(_lightDir);
		if (abs(_dot) < 0.000001) return Matrix4x4.Identity;
		var _a = _plane.normal.x, _b = _plane.normal.y, _c = _plane.normal.z, _d = _plane.distance;
		var _x = -_lightDir.x, _y = -_lightDir.y, _z = -_lightDir.z, _w = -_dot;
		return Matrix4x4(
			_w - _a*_x, -_a*_y, -_a*_z, -_a*_w,
			-_b*_x, _w - _b*_y, -_b*_z, -_b*_w,
			-_c*_x, -_c*_y, _w - _c*_z, -_c*_w,
			-_d*_x, -_d*_y, -_d*_z, _w - _d*_w
		);
	};
	#endregion
	
	#region 变换构造器 - 类型转换
	static CreateFromMatrix3x2 = function(_mat) { return Matrix4x4(_mat); };
	#endregion
	
	#region 变换构造器 - 分解与变换
	static Decompose = function(_matrix, _scale, _rotation, _translation) {
		_translation.x = _matrix.m30; _translation.y = _matrix.m31; _translation.z = _matrix.m32;
		var sx = Vector3(_matrix.m00, _matrix.m01, _matrix.m02).Length();
		var sy = Vector3(_matrix.m10, _matrix.m11, _matrix.m12).Length();
		var sz = Vector3(_matrix.m20, _matrix.m21, _matrix.m22).Length();
		_scale.x = sx; _scale.y = sy; _scale.z = sz;
		if (sx < 0.000001 || sy < 0.000001 || sz < 0.000001) {
			_rotation.x = 0; _rotation.y = 0; _rotation.z = 0; _rotation.w = 1;
			return false;
		}
		var invSx = 1/sx, invSy = 1/sy, invSz = 1/sz;
		var rotMat = Matrix4x4(
			_matrix.m00*invSx, _matrix.m01*invSx, _matrix.m02*invSx, 0,
			_matrix.m10*invSy, _matrix.m11*invSy, _matrix.m12*invSy, 0,
			_matrix.m20*invSz, _matrix.m21*invSz, _matrix.m22*invSz, 0,
			0,0,0,1
		);
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
	static Transform = function(_matrix, _quaternion) {
		var rotMat = Matrix4x4.CreateFromQuaternion(_quaternion);
		var sx = Vector3(_matrix.m00, _matrix.m01, _matrix.m02).Length();
		var sy = Vector3(_matrix.m10, _matrix.m11, _matrix.m12).Length();
		var sz = Vector3(_matrix.m20, _matrix.m21, _matrix.m22).Length();
		var tx = _matrix.m30, ty = _matrix.m31, tz = _matrix.m32;
		return Matrix4x4(
			rotMat.m00*sx, rotMat.m01*sx, rotMat.m02*sx, 0,
			rotMat.m10*sy, rotMat.m11*sy, rotMat.m12*sy, 0,
			rotMat.m20*sz, rotMat.m21*sz, rotMat.m22*sz, 0,
			tx, ty, tz, 1
		);
	};
	#endregion
	
	#region 变换构造器 - 几何查询
	static ExtractFrustumPlanes = function(_viewProj) { return _viewProj.ExtractFrustumPlanes(); };
	#endregion
	
	return Matrix4x4Struct;
}