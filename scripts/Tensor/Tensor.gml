/// @func Tensor
/// @desc 张量构造器。用于创建和操作 N 阶张量（N 维数组）。
///       所有数据为 real 类型，不支持 dtype/device 等高级特性。
/// @param {array} shape — 张量形状，如 [2,3]；标量传 []
/// @param {real|array} data — 可选初始数据（必须与 shape 一致）
/// @returns {Tensor}
function Tensor(_shape, _data = undefined) constructor {
    // =============== 实例变量 ===============
    /// @field shape — 张量形状（array），标量为 []
    /// @field data — 底层数据（标量或嵌套 array）
    
    if (!is_array(_shape)) {
        show_debug_message("Tensor: shape must be an array. Using [] (scalar).");
        _shape = [];
    }
    self.shape = _shape;
    
    if (_data == undefined) {
        self.data = self._create_data_from_shape(_shape, 0);
    } else {
        self.data = _data;
    }

    // =============== 实例方法 ===============
    /// @func self.rank
    /// @desc 返回张量阶数（0=标量, 1=向量...）
    /// @returns {real}
    self.rank = function() {
        return array_length(self.shape);
    };

    /// @func self.dim
    /// @desc 同 rank()
    /// @returns {real}
    self.dim = self.rank;

    /// @func self.numel
    /// @desc 返回元素总数
    /// @returns {real}
    self.numel = function() {
        return self._product(self.shape);
    };

    /// @func self.shape_str
    /// @desc 返回形状字符串（调试用）
    /// @returns {string}
    self.shape_str = function() {
        return string(self.shape);
    };

    /// @func self.get
    /// @desc 安全获取元素
    /// @param {array} indices
    /// @returns {real|undefined}
    self.get = function(_indices) {
        if (array_length(_indices) != self.rank()) return undefined;
        for (var _i = 0; _i < array_length(_indices); _i++) {
            if (_indices[_i] < 0 || _indices[_i] >= self.shape[_i]) {
                return undefined;
            }
        }
        return self._get_recursive(self.data, _indices);
    };

    /// @func self.set
    /// @desc 安全设置元素（原地修改）
    /// @param {array} indices
    /// @param {real} value
    /// @returns {bool}
        self.set = function(_indices, _value) {
        if (array_length(_indices) != self.rank()) return false;
        for (var _i = 0; _i < array_length(_indices); _i++) {
            if (_indices[_i] < 0 || _indices[_i] >= self.shape[_i]) {
                return false;
            }
        }
        // Directly modify self.data
        if (self.rank() == 1) {
            self.data[_indices[0]] = _value;
        } else if (self.rank() == 2) {
            self.data[_indices[0]][_indices[1]] = _value;
        } else if (self.rank() == 3) {
            self.data[_indices[0]][_indices[1]][_indices[2]] = _value;
        } else {
            // For higher dimensions, use recursive navigation on self.data
            var _current = self.data;
            for (var _i = 0; _i < array_length(_indices) - 1; _i++) {
                _current = _current[_indices[_i]];
            }
            _current[_indices[| array_length(_indices) - 1]] = _value;
        }
        return true;
    };

    /// @func self.flatten
    /// @desc 返回一维数组（深拷贝）
    /// @returns {array}
    self.flatten = function() {
        return self._flatten_recursive(self.data);
    };

    /// @func self.reshape
    /// @desc 返回新张量（不修改原张量）
    /// @param {array} new_shape
    /// @returns {Tensor|undefined}
    self.reshape = function(_new_shape) {
        if (!is_array(_new_shape)) return undefined;
        var _total_old = Tensor._product(self.shape);
        var _total_new = Tensor._product(_new_shape);
        if (_total_old != _total_new) return undefined;
        var _flat = self.flatten();
        var _new_data = self._build_from_flat(_flat, _new_shape);
        return new Tensor(_new_shape, _new_data);
    };

    /// @func self.add_scalar
    /// @param {real} scalar
    /// @returns {Tensor}
    self.add_scalar = function(_scalar) {
        var _flat = self.flatten();
        for (var _i = 0; _i < array_length(_flat); _i++) {
            _flat[_i] += _scalar;
        }
        var _new_data = self._build_from_flat(_flat, self.shape);
        return new Tensor(self.shape, _new_data);
    };

    /// @func self.multiply_scalar
    /// @param {real} scalar
    /// @returns {Tensor}
    self.multiply_scalar = function(_scalar) {
        var _flat = self.flatten();
        for (var _i = 0; _i < array_length(_flat); _i++) {
            _flat[_i] *= _scalar;
        }
        var _new_data = self._build_from_flat(_flat, self.shape);
        return new Tensor(self.shape, _new_data);
    };

    /// @func self.sum
    /// @desc 所有元素求和
    /// @returns {real}
    self.sum = function() {
        var _s = 0;
        var _flat = self.flatten();
        for (var _i = 0; _i < array_length(_flat); _i++) {
            _s += _flat[_i];
        }
        return _s;
    };

    /// @func self.mean
    /// @desc 所有元素均值
    /// @returns {real}
    self.mean = function() {
        var _n = self.numel();
        return (_n > 0) ? self.sum() / _n : 0;
    };

    /// @func self.max
    /// @desc 返回最大值
    /// @returns {real}
    self.max = function() {
        var _flat = self.flatten();
        if (array_length(_flat) == 0) return undefined;
        var _m = _flat[0];
        for (var _i = 1; _i < array_length(_flat); _i++) {
            if (_flat[_i] > _m) _m = _flat[_i];
        }
        return _m;
    };

    /// @func self.min
    /// @desc 返回最小值
    /// @returns {real}
    self.min = function() {
        var _flat = self.flatten();
        if (array_length(_flat) == 0) return undefined;
        var _m = _flat[0];
        for (var _i = 1; _i < array_length(_flat); _i++) {
            if (_flat[_i] < _m) _m = _flat[_i];
        }
        return _m;
    };

    /// @func self.argmax
    /// @desc 返回最大值的线性索引（全局）
    /// @returns {real}
    self.argmax = function() {
        var _flat = self.flatten();
        if (array_length(_flat) == 0) return -1;
        var _idx = 0;
        var _max_val = _flat[0];
        for (var _i = 1; _i < array_length(_flat); _i++) {
            if (_flat[_i] > _max_val) {
                _max_val = _flat[_i];
                _idx = _i;
            }
        }
        return _idx;
    };

    /// @func self.transpose
    /// @desc 仅支持 2D 矩阵转置
    /// @returns {Tensor|undefined}
    self.transpose = function() {
        if (self.rank() != 2) return undefined;
        var _rows = self.shape[0];
        var _cols = self.shape[1];
        var _new_data = [];
        for (var _j = 0; _j < _cols; _j++) {
            _new_data[ _j] = [];
            for (var _i = 0; _i < _rows; _i++) {
                _new_data[_j][ _i] = self.get([_i, _j]);
            }
        }
        return new Tensor([_cols, _rows], _new_data);
    };

    /// @func self.unsqueeze
    /// @desc 在指定维度插入大小为1的维度
    /// @param {real} dim
    /// @returns {Tensor}
    self.unsqueeze = function(_dim) {
        if (_dim < 0) _dim += self.rank() + 1;
        if (_dim < 0 || _dim > self.rank()) return undefined;
        var _new_shape = [];
        for (var _i = 0; _i < _dim; _i++) {
            _new_shape[_i] = self.shape[_i];
        }
        _new_shape[_dim] = 1;
        for (var _i = _dim; _i < self.rank(); _i++) {
            _new_shape[_i + 1] = self.shape[_i];
        }
        var _flat = self.flatten();
        var _new_data = self._build_from_flat(_flat, _new_shape);
        return new Tensor(_new_shape, _new_data);
    };

    /// @func self.squeeze
    /// @desc 移除大小为1的维度（不指定 dim 时移除所有）
    /// @param {real} dim — 可选
    /// @returns {Tensor}
    self.squeeze = function(_dim = -1) {
        var _new_shape = [];
        if (_dim == -1) {
            for (var _i = 0; _i < array_length(self.shape); _i++) {
                if (self.shape[_i] != 1) {
                    _new_shape[array_length(_new_shape)] = self.shape[_i];
                }
            }
        } else {
            if (_dim < 0) _dim += self.rank();
            if (_dim < 0 || _dim >= self.rank() || self.shape[_dim] != 1) {
                _new_shape = self.shape;
            } else {
                for (var _i = 0; _i < array_length(self.shape); _i++) {
                    if (_i != _dim) {
                        _new_shape[array_length(_new_shape)] = self.shape[_i];
                    }
                }
            }
        }
        var _flat = self.flatten();
        var _new_data = self._build_from_flat(_flat, _new_shape);
        return new Tensor(_new_shape, _new_data);
    };

    // =============== 静态常量 ===============
    // （无）

    // =============== 静态方法 ===============
    /// @func Tensor.create
    /// @param {array} shape
    /// @param {real} fill_value
    /// @returns {Tensor}
    static create = function(_shape, _fill_value) {
        var _data = self._create_data_from_shape(_shape, _fill_value);
        return new Tensor(_shape, _data);
    };

    /// @func Tensor.zeros
    /// @param {array} shape
    /// @returns {Tensor}
    static zeros = function(_shape) {
        return self.create(_shape, 0);
    };

    /// @func Tensor.ones
    /// @param {array} shape
    /// @returns {Tensor}
    static ones = function(_shape) {
        return self.create(_shape, 1);
    };

    /// @func Tensor.arange
    /// @param {real} start
    /// @param {real} end
    /// @param {real} step
    /// @returns {Tensor}
    static arange = function(_start, _end, _step = 1) {
        if (_step == 0) _step = 1;
        var _data = [];
        var _val = _start;
        if (_step > 0) {
            while (_val < _end) {
                _data[array_length(_data)] = _val;
                _val += _step;
            }
        } else {
            while (_val > _end) {
                _data[array_length(_data)] = _val;
                _val += _step;
            }
        }
        return new Tensor([array_length(_data)], _data);
    };

    /// @func Tensor.eye
    /// @param {real} n
    /// @returns {Tensor}
    static eye = function(_n) {
        var _data = [];
        for (var _i = 0; _i < _n; _i++) {
            _data[_i] = [];
            for (var _j = 0; _j < _n; _j++) {
                _data[_i][_j] = (_i == _j) ? 1 : 0;
            }
        }
        return new Tensor([_n, _n], _data);
    };

    /// @func Tensor.rand
    /// @param {array} shape
    /// @returns {Tensor}
    static rand = function(_shape) {
        var _total = Tensor._product(_shape);
        var _flat = [];
        for (var _i = 0; _i < _total; _i++) {
            _flat[_i] = random(1); // [0,1)
        }
        var _data = self._build_from_flat(_flat, _shape);
        return new Tensor(_shape, _data);
    };

    /// @func Tensor.randn
    /// @param {array} shape
    /// @returns {Tensor}
    static randn = function(_shape) {
        var _total = self._product(_shape);
        var _flat = [];
        var _use_cached = false;
        var _cached = 0;
        for (var _i = 0; _i < _total; _i++) {
            if (_use_cached) {
                _flat[_i] = _cached;
                _use_cached = false;
            } else {
                var _u1 = random(1);
                var _u2 = random(1);
                if (_u1 <= 0.000000001) _u1 = 0.000000001;
                var _z0 = sqrt(-2 * ln(_u1)) * cos(2 * pi * _u2);
                var _z1 = sqrt(-2 * ln(_u1)) * sin(2 * pi * _u2);
                _flat[_i] = _z0;
                _cached = _z1;
                _use_cached = true;
            }
        }
        var _data = self._build_from_flat(_flat, _shape);
        return new Tensor(_shape, _data);
    };

    /// @func Tensor.cat
    /// @desc 沿维度连接（仅支持 2D，dim=0 或 1）
    /// @param {array} tensors
    /// @param {real} dim
    /// @returns {Tensor|undefined}
    static cat = function(_tensors, _dim = 0) {
        if (array_length(_tensors) == 0) return undefined;
        var _first = _tensors[0];
        if (_first.rank() != 2) return undefined;
        if (_dim != 0 && _dim != 1) return undefined;

        var _rows = _first.shape[0];
        var _cols = _first.shape[1];
        var _total_rows = _rows;
        var _total_cols = _cols;

        if (_dim == 0) {
            for (var _i = 1; _i < array_length(_tensors); _i++) {
                if (_tensors[_i].shape[1] != _cols) return undefined;
                _total_rows += _tensors[_i].shape[0];
            }
        } else {
            for (var _i = 1; _i < array_length(_tensors); _i++) {
                if (_tensors[_i].shape[0] != _rows) return undefined;
                _total_cols += _tensors[_i].shape[1];
            }
        }

        var _new_data = [];
        if (_dim == 0) {
            for (var _i = 0; _i < array_length(_tensors); _i++) {
                var _t_data = _tensors[_i].data;
                for (var _r = 0; _r < array_length(_t_data); _r++) {
                    _new_data[array_length(_new_data)] = _t_data[_r];
                }
            }
        } else {
            for (var _r = 0; _r < _rows; _r++) {
                _new_data[ _r] = [];
                for (var _i = 0; _i < array_length(_tensors); _i++) {
                    var _src_row = _tensors[_i].data[_r];
                    for (var _c = 0; _c < array_length(_src_row); _c++) {
                        _new_data[_r][array_length(_new_data[_r])] = _src_row[_c];
                    }
                }
            }
        }
        return new Tensor([_total_rows, _total_cols], _new_data);
    };

    // --- 内部静态工具（私有）---
    static _product = function(_arr) {
        if (!is_array(_arr)) return 1;
        var _p = 1;
        for (var _i = 0; _i < array_length(_arr); _i++) {
            _p *= _arr[_i];
        }
        return _p;
    };

    static _create_data_from_shape = function(_shape, _fill) {
        // 标量张量（0阶）
        if (array_length(_shape) == 0) {
            return _fill;
        }

        var _ndim = array_length(_shape);

        // 1D：向量
        if (_ndim == 1) {
            var _size = _shape[0];
            var _arr = [];
            for (var _i = 0; _i < _size; _i++) {
                _arr[@ _i] = _fill;
            }
            return _arr;
        }

        // 2D：矩阵
        if (_ndim == 2) {
            var _rows = _shape[0];
            var _cols = _shape[1];
            var _matrix = [];
            for (var _i = 0; _i < _rows; _i++) {
                _matrix[@ _i] = [];
                for (var _j = 0; _j < _cols; _j++) {
                    _matrix[_i][@ _j] = _fill;
                }
            }
            return _matrix;
        }

        // 3D：体数据（如动画帧×关节×坐标）
        if (_ndim == 3) {
            var _d0 = _shape[0];
            var _d1 = _shape[1];
            var _d2 = _shape[2];
            var _volume = [];
            for (var _i = 0; _i < _d0; _i++) {
                _volume[@ _i] = [];
                for (var _j = 0; _j < _d1; _j++) {
                    _volume[_i][@ _j] = [];
                    for (var _k = 0; _k < _d2; _k++) {
                        _volume[_i][_j][@ _k] = _fill;
                    }
                }
            }
            return _volume;
        }

        // 4D 及以上：递归构建
        var _first_dim = _shape[0];
        var _rest_shape = array_slice(_shape, 1, _ndim - 1);
        var _result = [];
        for (var _i = 0; _i < _first_dim; _i++) {
            _result[@ _i] = self._create_data_from_shape(_rest_shape, _fill);
        }
        return _result;
    };

    static _flatten_recursive = function(_x) {
        if (!is_array(_x)) {
            return [_x];
        }
        var _result = [];
        for (var _i = 0; _i < array_length(_x); _i++) {
            var _element = _x[_i];
            // If element is undefined, skip or treat as 0
            if (_element == undefined) {
                _element = 0;
            }
            if (is_array(_element)) {
                var _sub = self._flatten_recursive(_element);
                for (var _j = 0; _j < array_length(_sub); _j++) {
                    _result[array_length(_result)] = _sub[_j];
                }
            } else {
                _result[array_length(_result)] = _element;
            }
        }
        return _result;
    };
	
    static _build_from_flat = function(_flat, _shape) {
		show_debug_message("_build_from_flat: flat=" + string(_flat) + ", shape=" + string(_shape));
        if (array_length(_flat) == 0) {
            return self._create_data_from_shape(_shape, 0);
        }
        if (array_length(_shape) == 0) {
            return _flat[0];
        }
        if (array_length(_shape) == 1) {
            return array_slice(_flat, 0, _shape[0]);
        }
                if (array_length(_shape) == 2) {
            var _rows = _shape[0];
            var _cols = _shape[1];
            var _result = [];
            for (var _i = 0; _i < _rows; _i++) {
                _result[_i] = [];
                for (var _j = 0; _j < _cols; _j++) {
                    var _index = _i * _cols + _j;
                    _result[_i][_j] = (_index < array_length(_flat)) ? _flat[_index] : 0;
                }
            }
            return _result;
        }
		
        // 3D+
        var _dim = _shape[0];
        var _rest = array_slice(_shape, 1, array_length(_shape) - 1);
        var _size_rest = self._product(_rest);
        var _result = [];
        for (var _i = 0; _i < _dim; _i++) {
            var _start = _i * _size_rest;
            var _sub_flat = array_slice(_flat, _start, _size_rest);
            _result[_i] = self._build_from_flat(_sub_flat, _rest);
        }
        return _result;
    };

    static _get_recursive = function(_data, _indices) {
        var _current = _data;
        for (var _i = 0; _i < array_length(_indices); _i++) {
            if (!is_array(_current)) {
                return undefined;
            }
            var _idx = _indices[_i];
            if (_idx < 0 || _idx >= array_length(_current)) {
                return undefined;
            }
            _current = _current[_idx];
        }
        return _current;
    };

    static _set_recursive = function(_data, _indices, _value) {
        var _current = _data;
        for (var _i = 0; _i < array_length(_indices) - 1; _i++) {
            if (!is_array(_current)) return false;
            var _idx = _indices[_i];
            if (_idx < 0 || _idx >= array_length(_current)) return false;
            _current = _current[_idx];
        }
        if (!is_array(_current)) return false;
        var _last_idx = _indices[array_length(_indices) - 1];
        if (_last_idx < 0 || _last_idx >= array_length(_current)) return false;
        _current[_last_idx] = _value;
        return true;
    };
}