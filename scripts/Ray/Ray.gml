/// @func Ray(origin, direction)
/// @desc 射线构造器：origin + t * direction (t >= 0)
/// @param {Vector3} origin 射线起点
/// @param {Vector3} direction 射线方向（建议单位化）
/// @returns {Ray}
function Ray(_origin, _direction) constructor {
	self.type = "Ray";
	self.origin = _origin.Copy();
	self.direction = _direction.Normalize();

	/// @func Ray.IntersectsPlane(plane)
	/// @desc 计算射线与平面的交点参数 t（若无交点返回 undefined）
	/// @param {Plane} plane 目标平面
	/// @returns {Real | undefined} t 值（t >= 0 表示射线正向相交）
	self.IntersectsPlane = function(_plane) {
		var denom = _plane.normal.Dot(self.direction);
		if (abs(denom) < 0.000001) return undefined; // 平行
		var t = -(_plane.normal.Dot(self.origin) + _plane.distance) / denom;
		return t >= 0 ? t : undefined;
	};

	/// @func Ray.IntersectsSphere(center, radius)
	/// @desc 计算射线与球体的交点参数 [t0, t1]（t0 <= t1），若无交点返回 undefined
	/// @param {Vector3} center 球心
	/// @param {Real} radius 半径
	/// @returns {Array | undefined} [t0, t1] 或 undefined
	self.IntersectsSphere = function(_center, _radius) {
		var oc = self.origin.Subtract(_center);
		var a = self.direction.Dot(self.direction);
		var b = 2 * oc.Dot(self.direction);
		var c = oc.Dot(oc) - _radius * _radius;
		var disc = b * b - 4 * a * c;
		if (disc < 0) return undefined;
		var sqrtDisc = sqrt(disc);
		var t0 = (-b - sqrtDisc) / (2 * a);
		var t1 = (-b + sqrtDisc) / (2 * a);
		if (t1 < 0) return undefined;
		if (t0 < 0) t0 = 0;
		return [t0, t1];
	};

	self.ToString = function() {
		return "Ray(origin=" + self.origin.ToString() + ", direction=" + self.direction.ToString() + ")";
	};
}