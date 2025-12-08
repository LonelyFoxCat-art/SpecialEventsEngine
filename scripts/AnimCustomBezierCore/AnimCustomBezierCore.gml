/// @struct AnimCustomBezierCore
/// @desc 贝塞尔路径插值核心（无播放状态，无 Timeline 依赖）
/// @description 
/// 用于构建多段贝塞尔曲线，并通过归一化时间 t ∈ [0,1] 获取插值点。
/// 支持弧长参数化（匀速运动），适用于自定义动画系统。
function AnimCustomBezierCore() constructor {
    self.Segments = [];
    self.TotalLength = 0;
    self.UseArcLength = false;
    self.ArcResolution = 20;

    self._array_dup = function(src) {
        if (!is_array(src)) return [];
        var n = array_length(src);
        if (n == 0) return [];
        var dest = array_create(n);
        array_copy(dest, 0, src, 0, n);
        return dest;
    };

    self.addSegment = function(points_array) {
        if (!is_array(points_array) || array_length(points_array) < 2) return;
        var safe_points = self._array_dup(points_array);
        array_push(self.Segments, {
            points: safe_points,
            length: 0,
            arc_samples: []
        });
        self._invalidateArcLength();
    };

    self.clear = function() {
        self.Segments = [];
        self.TotalLength = 0;
    };

    self.setUseArcLength = function(enable, resolution = 20) {
        self.UseArcLength = enable;
        self.ArcResolution = max(5, floor(resolution));
        if (enable && array_length(self.Segments) > 0) {
            self._buildArcLengthTable();
        }
    };

    self._deCasteljau = function(points, t) {
        t = clamp(t, 0, 1);
        var n = array_length(points);
        if (n == 0) return {x: 0, y: 0};
        if (n == 1) return points[0];

        var work = array_create(n);
        for (var i = 0; i < n; i++) {
            work[i] = points[i];
        }

        for (var i = 1; i < n; i++) {
            for (var j = 0; j < n - i; j++) {
                var p0 = work[j];
                var p1 = work[j + 1];
                var _x = lerp(p0.x, p1.x, t);
                var _y = lerp(p0.y, p1.y, t);
                if (variable_struct_exists(p0, "z") && variable_struct_exists(p1, "z")) {
                    var z = lerp(p0.z, p1.z, t);
                    work[j] = {x: _x, y: _y, z: z};
                } else {
                    work[j] = {x: _x, y: _y};
                }
            }
        }
        return work[0];
    };

    self._approximateSegmentLength = function(points) {
        var steps = self.ArcResolution;
        var last = self._deCasteljau(points, 0);
        var total_dist = 0;
        var samples = [];
        array_push(samples, {t: 0, dist: 0, point: last});

        for (var i = 1; i <= steps; i++) {
            var t_val = i / steps;
            var curr = self._deCasteljau(points, t_val);
            var dx = curr.x - last.x;
            var dy = curr.y - last.y;
            var dz = 0;
            if (variable_struct_exists(curr, "z") && variable_struct_exists(last, "z")) {
                dz = curr.z - last.z;
            }
            total_dist += sqrt(dx*dx + dy*dy + dz*dz);
            array_push(samples, {t: t_val, dist: total_dist, point: curr});
            last = curr;
        }
        return {length: total_dist, samples: samples};
    };

    self._buildArcLengthTable = function() {
        self.TotalLength = 0;
        for (var i = 0; i < array_length(self.Segments); i++) {
            var seg = self.Segments[i];
            var result = self._approximateSegmentLength(seg.points);
            seg.length = result.length;
            seg.arc_samples = result.samples;
            self.TotalLength += seg.length;
        }
    };

    self._invalidateArcLength = function() {
        if (self.UseArcLength) {
            self._buildArcLengthTable();
        }
    };

    self._findSegmentByProgress = function(norm_t) {
        norm_t = clamp(norm_t, 0, 1);
        var seg_count = array_length(self.Segments);
        if (seg_count == 0) return {seg: -1, local_t: 0};

        if (!self.UseArcLength) {
            var seg_index = min(floor(norm_t * seg_count), seg_count - 1);
            var local_t = (norm_t * seg_count) - seg_index;
            return {seg: seg_index, local_t: clamp(local_t, 0, 1)};
        } else {
            if (self.TotalLength <= 0) return {seg: 0, local_t: 0};
            var target_dist = norm_t * self.TotalLength;
            var acc = 0;
            for (var i = 0; i < seg_count; i++) {
                var seg = self.Segments[i];
                if (acc + seg.length >= target_dist || i == seg_count - 1) {
                    var local_dist = target_dist - acc;
                    var samples = seg.arc_samples;
                    for (var j = 1; j < array_length(samples); j++) {
                        if (samples[j].dist >= local_dist) {
                            var d0 = samples[j-1].dist;
                            var d1 = samples[j].dist;
                            var alpha = (local_dist - d0) / max(d1 - d0, 0.0000001);
                            var local_t = lerp(samples[j-1].t, samples[j].t, alpha);
                            return {seg: i, local_t: clamp(local_t, 0, 1)};
                        }
                    }
                    return {seg: i, local_t: 1};
                }
                acc += seg.length;
            }
            return {seg: seg_count - 1, local_t: 1};
        }
    };

    self.getPointAt = function(t) {
        var info = self._findSegmentByProgress(t);
        if (info.seg == -1) return {x: 0, y: 0};
        return self._deCasteljau(self.Segments[info.seg].points, info.local_t);
    };
}