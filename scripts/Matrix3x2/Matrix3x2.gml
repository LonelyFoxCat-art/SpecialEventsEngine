/// @func Matrix3x2(m11, m12, m21, m22, m31, m32)
/// @desc 构造一个 3x2 仿射变换矩阵（用于 2D 变换），支持标量或分量初始化；若仅传入一个参数，则所有分量设为该值
/// @arg {real} [m11] - 矩阵元素 m11（主对角线左上），若仅传入此参数则用于初始化所有元素
/// @arg {real} [m12] - 矩阵元素 m12
/// @arg {real} [m21] - 矩阵元素 m21
/// @arg {real} [m22] - 矩阵元素 m22
/// @arg {real} [m31] - 平移分量 x（第三行第一列）
/// @arg {real} [m32] - 平移分量 y（第三行第二列）
/// @returns {struct} 包含矩阵数据和方法的结构体，类型标识为 "Matrix3x2"
Matrix3x2()
function Matrix3x2(m11 = 0, m12 = 0, m21 = 0, m22 = 0, m31 = 0, m32 = 0) {
	var Matrix3x2Struct = {
        type: "Matrix3x2",
		m11: m11, m12: m12,
		m21: m21, m22: m22,
		m31: m31, m32: m32,
        
		#region 实例方法
        Add: function(matrix) {
			if (is_real(matrix))  return Matrix3x2(
				self.m11 + matrix, self.m12 + matrix,
				self.m21 + matrix, self.m22 + matrix,
				self.m31 + matrix, self.m32 + matrix
			);
			
			return Matrix3x2(
				self.m11 + matrix.m11, self.m12 + matrix.m12,
				self.m21 + matrix.m21, self.m22 + matrix.m22,
				self.m31 + matrix.m31, self.m32 + matrix.m32
			);
        },
		Subtract: function(matrix) {
			if (is_real(matrix))  return Matrix3x2(
				self.m11 - matrix, self.m12 - matrix,
				self.m21 - matrix, self.m22 - matrix,
				self.m31 - matrix, self.m32 - matrix
			);
			
            return Matrix3x2(
				self.m11 - matrix.m11, self.m12 - matrix.m12,
				self.m21 - matrix.m21, self.m22 - matrix.m22,
				self.m31 - matrix.m31, self.m32 - matrix.m32
			);
        },
        Multiply: function(matrix) {
            if (is_real(matrix)) return Matrix3x2(
				self.m11 * matrix, self.m12 * matrix,
				self.m21 * matrix, self.m22 * matrix,
				self.m31 * matrix, self.m32 * matrix
			);

			return Matrix3x2(
				self.m11 * matrix.m11 + self.m12 * matrix.m21,
				self.m11 * matrix.m12 + self.m12 * matrix.m22,
				self.m21 * matrix.m11 + self.m22 * matrix.m21,
				self.m21 * matrix.m12 + self.m22 * matrix.m22,
				self.m31 * matrix.m11 + self.m32 * matrix.m21 + matrix.m31,
				self.m31 * matrix.m12 + self.m32 * matrix.m22 + matrix.m32
			);
        },
        Negate: function() {
            return Matrix3x2(
                -self.m11, -self.m12,
                -self.m21, -self.m22,
                -self.m31, -self.m32
            );
        },
        Equals: function(matrix, _tolerance = 0.000001) {
            return (
                abs(self.m11 - matrix.m11) <= _tolerance &&
                abs(self.m12 - matrix.m12) <= _tolerance &&
                abs(self.m21 - matrix.m21) <= _tolerance &&
                abs(self.m22 - matrix.m22) <= _tolerance &&
                abs(self.m31 - matrix.m31) <= _tolerance &&
                abs(self.m32 - matrix.m32) <= _tolerance
            );
        },
        ToString: function() {
            return "Matrix3x2(" +
                string(self.m11) + ", " + string(self.m12) + ", " +
                string(self.m21) + ", " + string(self.m22) + ", " +
                string(self.m31) + ", " + string(self.m32) + ")";
        },
        GetDeterminant: function() {
            return self.m11 * self.m22 - self.m12 * self.m21;
        },
        Invert: function() {
            var _det = self.GetDeterminant();
            if (abs(_det) < 0.000001) {
                return undefined;
            }
            var _inv_det = 1 / _det;
            return Matrix3x2(
                self.m22 * _inv_det,
                -self.m12 * _inv_det,
                -self.m21 * _inv_det,
                self.m11 * _inv_det,
                (self.m21 * self.m32 - self.m22 * self.m31) * _inv_det,
                (self.m12 * self.m31 - self.m11 * self.m32) * _inv_det
            );
        },
        Lerp: function(matrix, _t) {
            var t = clamp(_t, 0, 1);
            return Matrix3x2(
                self.m11 + t * (matrix.m11 - self.m11),
                self.m12 + t * (matrix.m12 - self.m12),
                self.m21 + t * (matrix.m21 - self.m21),
                self.m22 + t * (matrix.m22 - self.m22),
                self.m31 + t * (matrix.m31 - self.m31),
                self.m32 + t * (matrix.m32 - self.m32)
            );
        }
		#endregion
    };
	
	#region 参数处理
	if (argument_count == 1) {
		Matrix3x2Struct.m11 = m11;
		Matrix3x2Struct.m12 = m11;
		Matrix3x2Struct.m21 = m11;
		Matrix3x2Struct.m22 = m11;
		Matrix3x2Struct.m31 = m11;
		Matrix3x2Struct.m32 = m11;
	}
    #endregion
	
    #region 静态常量
	static Identity = Matrix3x2(1, 0, 0, 1, 0, 0);
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
    #endregion
	
	#region 变换构造器 - 旋转
    static CreateRotation = function(_radians) {
        var _cos = cos(_radians);
        var _sin = sin(_radians);
        return Matrix3x2(
            _cos, _sin,
            -_sin, _cos,
            0, 0
        );
    };
    static CreateRotationCenter = function(_radians, _center) {
        var _cos = cos(_radians);
        var _sin = sin(_radians);
        var _x = _center.x;
        var _y = _center.y;
        var _m31 = _x - _x * _cos + _y * _sin;
        var _m32 = _y - _x * _sin - _y * _cos;
        return Matrix3x2(
            _cos, _sin,
            -_sin, _cos,
            _m31, _m32
        );
    };
    #endregion
	
	#region 变换构造器 - 缩放
    static CreateScaleUniform = function(_scale) { 
        return Matrix3x2(_scale, 0, 0, _scale, 0, 0); 
    };
    static CreateScaleXY = function(_x, _y) { 
        return Matrix3x2(_x, 0, 0, _y, 0, 0); 
    };
    static CreateScaleVector = function(_v) { 
        return Matrix3x2(_v.x, 0, 0, _v.y, 0, 0); 
    };
    static CreateScaleUniformCenter = function(_scale, _center) {
        var _x = _center.x;
        var _y = _center.y;
        var _m31 = _x - _x * _scale;
        var _m32 = _y - _y * _scale;
        return Matrix3x2(_scale, 0, 0, _scale, _m31, _m32);
    };
    static CreateScaleXYCenter = function(_x, _y, _center) {
        var _cx = _center.x;
        var _cy = _center.y;
        var _m31 = _cx - _cx * _x;
        var _m32 = _cy - _cy * _y;
        return Matrix3x2(_x, 0, 0, _y, _m31, _m32);
    };
    static CreateScaleVectorCenter = function(_v, _center) {
        var _sx = _v.x;
        var _sy = _v.y;
        var _cx = _center.x;
        var _cy = _center.y;
        var _m31 = _cx - _cx * _sx;
        var _m32 = _cy - _cy * _sy;
        return Matrix3x2(_sx, 0, 0, _sy, _m31, _m32);
    };
    #endregion
    
    #region 变换构造器 - 斜切
    static CreateSkew = function(_xAngle, _yAngle) {
        return Matrix3x2(
            1, tan(_yAngle),
            tan(_xAngle), 1,
            0, 0
        );
    };
    static CreateSkewCenter = function(_xAngle, _yAngle, _center) {
        var _skew = Matrix3x2.CreateSkew(_xAngle, _yAngle);
        var _cx = _center.x;
        var _cy = _center.y;
        var _m31 = _skew.m11 * _cx + _skew.m12 * _cy - _cx;
        var _m32 = _skew.m21 * _cx + _skew.m22 * _cy - _cy;
        return Matrix3x2(
            _skew.m11, _skew.m12,
            _skew.m21, _skew.m22,
            -_m31, -_m32
        );
    };
    #endregion
    
    #region 变换构造器 - 平移
    static CreateTranslationXY = function(_x, _y) { 
        return Matrix3x2(1, 0, 0, 1, _x, _y); 
    };
    static CreateTranslationVector = function(_v) { 
        return Matrix3x2(1, 0, 0, 1, _v.x, _v.y); 
    };
    #endregion
    
    #region 工具方法
    static CreateFromMatrix4x4 = function(_mat) {
        return Matrix3x2(
            _mat.m00, _mat.m01,
            _mat.m10, _mat.m11,
            _mat.m30, _mat.m31
        );
    };
    #endregion
	
	return Matrix3x2Struct
}