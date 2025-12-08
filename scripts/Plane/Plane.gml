/// @func Plane(x, y, z, d)
/// @desc 平面构造器；支持 (x,y,z,d)、(Vector3,d)、(Vector4) 三种形式。
/// @param {Real | Vector3 | Vector4} [x=0] 法线X 或 Vector3/Vector4
/// @param {Real} [y=0] 法线Y（若x为Real）
/// @param {Real} [z=0] 法线Z（若x为Real）
/// @param {Real} [d=0] 距离（若x为Real或Vector3）
/// @returns {Plane}
function Plane(_x = 0, _y = 0, _z = 0, _d = 0) constructor {
	self.type = "Plane";

	if (is_struct(_x)) {
		if (_x.type == "Vector3") {
			self.normal = _x.Copy();
			self.distance = _y;
		} else if (_x.type == "Vector4") {
			self.normal = new Vector3(_x.x, _x.y, _x.z);
			self.distance = _x.w;
		} else {
			self.normal = new Vector3(0, 0, 0);
			self.distance = 0;
		}
	} else {
		self.normal = new Vector3(_x, _y, _z);
		self.distance = _d;
	}

	// =============== 实例方法 ===============
	
	self.Dot = function(_v4) {
		return self.normal.x * _v4.x + self.normal.y * _v4.y + self.normal.z * _v4.z + self.distance * _v4.w;
	};
	self.DotCoordinate = function(_v3) {
		return self.normal.x * _v3.x + self.normal.y * _v3.y + self.normal.z * _v3.z + self.distance;
	};
	self.DotNormal = function(_v3) {
		return self.normal.x * _v3.x + self.normal.y * _v3.y + self.normal.z * _v3.z;
	};
	self.Equals = function(_other, _tolerance = 0.000001) {
		return (
			self.normal.Equals(_other.normal, _tolerance) &&
			abs(self.distance - _other.distance) <= _tolerance
		);
	};
	self.ToString = function() {
		return "Plane(" + self.normal.ToString() + ", " + string(self.distance) + ")";
	};
	self.Normalize = function() {
		var _len = self.normal.Length();
		if (_len < 0.000001) {
			return new Plane(0, 0, 0, self.distance);
		}
		var _inv = 1 / _len;
		return new Plane(
			self.normal.x * _inv,
			self.normal.y * _inv,
			self.normal.z * _inv,
			self.distance * _inv
		);
	};
	self.TransformMatrix4x4 = function(_mat) {
		// 变换平面：需用逆 transpose
		var _inv = Matrix4x4.Invert(_mat);
		if (_inv == undefined) return self;
		var _transposed = _inv.Transpose();
		var _v4 = new Vector4(self.normal.x, self.normal.y, self.normal.z, self.distance);
		var _result = _transposed.Multiply(_v4); // 注意：Matrix4x4 需支持 Vector4 乘法
		return new Plane(_result.x, _result.y, _result.z, _result.w);
	};
	self.TransformQuaternion = function(_q) {
		var _rotatedNormal = Vector3.TransformQuaternion(self.normal, _q);
		return new Plane(_rotatedNormal, self.distance);
	};

	// =============== 静态方法（完整补全） ===============
	
	/// @func Plane.CreateFromVertices(a, b, c)
	/// @desc 创建包含三个点的平面；a,b,c 为 Vector3。
	/// @param {Vector3} a 第一个点
	/// @param {Vector3} b 第二个点
	/// @param {Vector3} c 第三个点
	/// @returns {Plane}
	static CreateFromVertices = function(_a, _b, _c) {
		var _ab = _b.Subtract(_a);
		var _ac = _c.Subtract(_a);
		var _normal = _ab.Cross(_ac).Normalize();
		var _distance = -_normal.Dot(_a);
		return new Plane(_normal, _distance);
	};

	/// @func Plane.Dot(plane, v4)
	/// @desc 计算平面与四维向量的点积（plane.normal · v4.xyz + plane.distance * v4.w）。
	/// @param {Plane} plane 平面
	/// @param {Vector4} v4 四维向量
	/// @returns {Real}
	static Dot = function(_plane, _v4) { return _plane.Dot(_v4); };

	/// @func Plane.DotCoordinate(plane, v3)
	/// @desc 计算三维点到平面的有符号距离（未归一化）：normal · point + distance。
	/// @param {Plane} plane 平面
	/// @param {Vector3} v3 三维点
	/// @returns {Real}
	static DotCoordinate = function(_plane, _v3) { return _plane.DotCoordinate(_v3); };

	/// @func Plane.DotNormal(plane, v3)
	/// @desc 计算向量与平面法线的点积（忽略 distance）。
	/// @param {Plane} plane 平面
	/// @param {Vector3} v3 三维向量
	/// @returns {Real}
	static DotNormal = function(_plane, _v3) { return _plane.DotNormal(_v3); };

	/// @func Plane.Equals(a, b, tolerance)
	/// @desc 判断两个平面是否在容差范围内相等。
	/// @param {Plane} a 第一个平面
	/// @param {Plane} b 第二个平面
	/// @param {Real} [tolerance=0.000001] 比较容差
	/// @returns {Bool}
	static Equals = function(_a, _b, _tolerance = 0.000001) { return _a.Equals(_b, _tolerance); };

	/// @func Plane.Normalize(plane)
	/// @desc 返回法线归一化后的平面（distance 同步缩放）。
	/// @param {Plane} plane 输入平面
	/// @returns {Plane}
	static Normalize = function(_plane) { return _plane.Normalize(); };

	/// @func Plane.Transform(plane, transform)
	/// @desc 根据 transform 类型自动选择变换方式：
	/// @desc - 若为 Matrix4x4：使用逆 transpose 变换整个平面；
	/// @desc - 若为 Quaternion：仅旋转法线，保留 distance。
	/// @param {Plane} plane 输入平面
	/// @param {Matrix4x4 | Quaternion} transform 变换对象
	/// @returns {Plane}
	static Transform = function(_plane, _transform) {
		if (_transform.type == "Matrix4x4") {
			return _plane.TransformMatrix4x4(_transform);
		} else if (_transform.type == "Quaternion") {
			return _plane.TransformQuaternion(_transform);
		}
		return _plane;
	};

	/// @func Plane.Copy(plane)
	/// @desc 创建并返回输入平面的一个副本（新实例）。
	/// @param {Plane} plane 要复制的平面
	/// @returns {Plane}
	static Copy = function(_plane) {
		return new Plane(_plane.normal.Copy(), _plane.distance);
	};
}