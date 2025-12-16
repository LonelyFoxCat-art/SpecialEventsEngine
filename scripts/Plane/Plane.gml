/// @func is_plane(plane)
/// @desc 判断给定变量是否为 Plane 类型实例
/// @arg {any} plane - 待检测的值
/// @returns {bool} 若为 Plane 实例则返回 true，否则返回 false

function is_plane(plane) {
	if (plane == undefined) return false;
    return (is_struct(plane) && plane.type == "Plane");
}

/// @func Plane(x = 0, y = 0, z = 0, d = 0)
/// @desc 创建一个平面（Plane）实例，可用多种方式初始化：分量、Vector3+距离、Vector4
/// @arg {number|Vector3|Vector4} x - 若为 number 表示法线 x 分量；若为 Vector3 表示法线；若为 Vector4 表示平面齐次表示
/// @arg {number} y - 若 x 为 number，此为法线 y 分量；若 x 为 Vector3，此为 distance
/// @arg {number} z - 法线 z 分量（仅当 x 为 number 时有效）
/// @arg {number} d - 平面距离偏移（仅当 x 为 number 时有效）
/// @returns {struct} 返回具有 Plane 接口的结构体，包含 normal（Vector3）和 distance（number）及操作方法

function Plane(x = 0, y = 0, z = 0, d = 0) {
	var PlaneStruct = {
		type: "Plane",
		normal: Vector3(x, y, z),
		distance: d,
		
		#region 实例方法
		Dot: function(vec) {
			return self.normal.x * vec.x + self.normal.y * vec.y + self.normal.z * vec.z + self.distance * vec.w;
		},
		DotCoordinate: function(vec) {
			return self.normal.x * vec.x + self.normal.y * vec.y + self.normal.z * vec.z + self.distance;
		},
		DotNormal: function(vec) {
			return self.normal.x * vec.x + self.normal.y * vec.y + self.normal.z * vec.z;
		},
		Equals: function(_other, _tolerance = 0.000001) {
			return (
				self.normal.Equals(_other.normal, _tolerance) &&
				abs(self.distance - _other.distance) <= _tolerance
			);
		},
		ToString: function() {
			return "Plane(" + self.normal.ToString() + ", " + string(self.distance) + ")";
		},
		Normalize: function() {
			var _len = self.normal.Length();
			if (_len < 0.000001) {
				return Plane(0, 0, 0, self.distance);
			}
			var _inv = 1 / _len;
			return Plane(
				self.normal.x * _inv,
				self.normal.y * _inv,
				self.normal.z * _inv,
				self.distance * _inv
			);
		},
		TransformMatrix4x4: function(_mat) {
			// 变换平面：需用逆 transpose
			var _inv = Matrix4x4.Invert(_mat);
			if (_inv == undefined) return self;
			var _transposed = _inv.Transpose();
			var _v4 = new Vector4(self.normal.x, self.normal.y, self.normal.z, self.distance);
			var _result = _transposed.Multiply(_v4); // 注意：Matrix4x4 需支持 Vector4 乘法
			return Plane(_result.x, _result.y, _result.z, _result.w);
		},
		TransformQuaternion: function(_q) {
			var _rotatedNormal = Vector3.TransformQuaternion(self.normal, _q);
			return Plane(_rotatedNormal, self.distance);
		}
		#endregion
	};

	#region 参数处理
    if (is_vec3(x)) {
		self.normal = x.Copy();
		self.distance = y;
	} else if (is_vec4(x)) {
		self.normal = Vector3(x.x, x.y, x.z);
		self.distance = x.w;
	} else {
		self.normal = Vector3(0, 0, 0);
		self.distance = 0;
	}
	#endregion
	
	#region 静态方法
	static CreateFromVertices = function(_a, _b, _c) {
		var _ab = _b.Subtract(_a);
		var _ac = _c.Subtract(_a);
		var _normal = _ab.Cross(_ac).Normalize();
		var _distance = -_normal.Dot(_a);
		return Plane(_normal, _distance);
	};
	static Dot = function(_plane, _v4) { return _plane.Dot(_v4); };
	static DotCoordinate = function(_plane, vec) { return _plane.DotCoordinate(vec); };
	static DotNormal = function(_plane, vec) { return _plane.DotNormal(vec); };
	static Equals = function(_a, _b, _tolerance = 0.000001) { return _a.Equals(_b, _tolerance); };
	static Normalize = function(_plane) { return _plane.Normalize(); };
	static Transform = function(_plane, _transform) {
		if (_transform.type == "Matrix4x4") {
			return _plane.TransformMatrix4x4(_transform);
		} else if (_transform.type == "Quaternion") {
			return _plane.TransformQuaternion(_transform);
		}
		return _plane;
	};
	static Copy = function(_plane) {
		return Plane(_plane.normal.Copy(), _plane.distance);
	};
	#endregion
}