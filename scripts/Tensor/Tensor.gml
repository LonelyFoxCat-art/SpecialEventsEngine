/// @func is_tensor(tensor)
/// @desc 判断给定变量是否为 Tensor 类型实例
/// @arg {any} tensor - 待检测的值
/// @returns {bool} 若为 Tensor 实例则返回 true，否则返回 false

function is_tensor(tensor) {
	if (tensor == undefined) return false;
    return (is_struct(tensor) && tensor.type == "Tensor");
}

/// @func Tensor(shape, data)
/// @desc 创建一个 Tensor（张量）实例，支持多维数组结构与基本张量运算
/// @arg {array} shape - 张量的形状（维度大小列表），默认为空数组（标量）
/// @arg {any} data - 初始化数据，若未提供则按 shape 生成全 0 数据
/// @returns {struct} 返回具有 Tensor 接口的结构体，包含 shape、data 及一系列操作方法

function Tensor(shape = [], data = undefined) {
    var TensorStruct = {
		type: "Tensor",
        shape: shape,
        data: data,

        #region 实例内部方法
        _product: function(_arr) {
            if (!is_array(_arr)) return 1;
            var _p = 1;
            for (var _i = 0; _i < array_length(_arr); _i++) {
                _p *= _arr[_i];
            }
            return _p;
        },
        _create_data_from_shape: function(_shape, _fill) {
            if (array_length(_shape) == 0) return _fill;
            var _ndim = array_length(_shape);
            if (_ndim == 1) {
                var _arr = [];
                for (var _i = 0; _i < _shape[0]; _i++) _arr[@ _i] = _fill;
                return _arr;
            }
            if (_ndim == 2) {
                var _matrix = [];
                for (var _i = 0; _i < _shape[0]; _i++) {
                    _matrix[@ _i] = [];
                    for (var _j = 0; _j < _shape[1]; _j++) _matrix[_i][@ _j] = _fill;
                }
                return _matrix;
            }
            if (_ndim == 3) {
                var _volume = [];
                for (var _i = 0; _i < _shape[0]; _i++) {
                    _volume[@ _i] = [];
                    for (var _j = 0; _j < _shape[1]; _j++) {
                        _volume[_i][@ _j] = [];
                        for (var _k = 0; _k < _shape[2]; _k++) _volume[_i][_j][@ _k] = _fill;
                    }
                }
                return _volume;
            }
            var _first = _shape[0];
            var _rest = array_slice(_shape, 1, _ndim - 1);
            var _result = [];
            for (var _i = 0; _i < _first; _i++) {
                _result[@ _i] = self._create_data_from_shape(_rest, _fill);
            }
            return _result;
        },
        _flatten_recursive: function(_x) {
            if (!is_array(_x)) return [_x];
            var _result = [];
            for (var _i = 0; _i < array_length(_x); _i++) {
                var _elem = (_x[_i] == undefined) ? 0 : _x[_i];
                if (is_array(_elem)) {
                    var _sub = self._flatten_recursive(_elem);
                    for (var _j = 0; _j < array_length(_sub); _j++) {
                        _result[@ array_length(_result)] = _sub[_j];
                    }
                } else {
                    _result[@ array_length(_result)] = _elem;
                }
            }
            return _result;
        },
        _build_from_flat: function(_flat, _shape) {
            if (array_length(_flat) == 0) return self._create_data_from_shape(_shape, 0);
            if (array_length(_shape) == 0) return _flat[0];
            if (array_length(_shape) == 1) return array_slice(_flat, 0, _shape[0]);
            if (array_length(_shape) == 2) {
                var _rows = _shape[0], _cols = _shape[1];
                var _out = [];
                for (var _i = 0; _i < _rows; _i++) {
                    _out[@ _i] = [];
                    for (var _j = 0; _j < _cols; _j++) {
                        var _idx = _i * _cols + _j;
                        _out[_i][@ _j] = (_idx < array_length(_flat)) ? _flat[_idx] : 0;
                    }
                }
                return _out;
            }
            var _dim = _shape[0];
            var _rest = array_slice(_shape, 1, array_length(_shape) - 1);
            var _rest_size = self._product(_rest);
            var _result = [];
            for (var _i = 0; _i < _dim; _i++) {
                var _start = _i * _rest_size;
                var _sub_flat = array_slice(_flat, _start, _rest_size);
                _result[@ _i] = self._build_from_flat(_sub_flat, _rest);
            }
            return _result;
        },
        _get_recursive: function(_data, _indices) {
            var _cur = _data;
            for (var _i = 0; _i < array_length(_indices); _i++) {
                if (!is_array(_cur)) return undefined;
                var _idx = _indices[_i];
                if (_idx < 0 || _idx >= array_length(_cur)) return undefined;
                _cur = _cur[_idx];
            }
            return _cur;
        },
        _set_recursive: function(_data, _indices, _value) {
            var _cur = _data;
            for (var _i = 0; _i < array_length(_indices) - 1; _i++) {
                if (!is_array(_cur)) return false;
                var _idx = _indices[_i];
                if (_idx < 0 || _idx >= array_length(_cur)) return false;
                _cur = _cur[_idx];
            }
            if (!is_array(_cur)) return false;
            var _last = _indices[array_length(_indices) - 1];
            if (_last < 0 || _last >= array_length(_cur)) return false;
            _cur[@ _last] = _value;
            return true;
        },
        #endregion

        #region 实例公共方法
        Rank: function() {
            return array_length(self.shape);
        },
        Numel: function() {
            return self._product(self.shape);
        },
        ShapeStr: function() {
            return string(self.shape);
        },
        Get: function(_indices) {
            if (array_length(_indices) != self.Rank()) return undefined;
            for (var _i = 0; _i < array_length(_indices); _i++) {
                if (_indices[_i] < 0 || _indices[_i] >= self.shape[_i]) return undefined;
            }
            return self._get_recursive(self.data, _indices);
        },
        Set: function(_indices, _value) {
            if (array_length(_indices) != self.Rank()) return false;
            for (var _i = 0; _i < array_length(_indices); _i++) {
                if (_indices[_i] < 0 || _indices[_i] >= self.shape[_i]) return false;
            }
            return self._set_recursive(self.data, _indices, _value);
        },
        Flatten: function() {
            return self._flatten_recursive(self.data);
        },
        Reshape: function(_new_shape) {
            if (!is_array(_new_shape)) return undefined;
            var _old = self._product(self.shape);
            var _new = self._product(_new_shape);
            if (_old != _new) return undefined;
            var _flat = self.Flatten();
            var _data = self._build_from_flat(_flat, _new_shape);
            return Tensor(_new_shape, _data);
        },
        AddScalar: function(_scalar) {
            var _flat = self.Flatten();
            for (var _i = 0; _i < array_length(_flat); _i++) _flat[@ _i] += _scalar;
            var _data = self._build_from_flat(_flat, self.shape);
            return Tensor(self.shape, _data);
        },
        MultiplyScalar: function(_scalar) {
            var _flat = self.Flatten();
            for (var _i = 0; _i < array_length(_flat); _i++) _flat[@ _i] *= _scalar;
            var _data = self._build_from_flat(_flat, self.shape);
            return Tensor(self.shape, _data);
        },
        Sum: function() {
            var _s = 0;
            var _flat = self.Flatten();
            for (var _i = 0; _i < array_length(_flat); _i++) _s += _flat[_i];
            return _s;
        },
        Mean: function() {
            var _n = self.Numel();
            return (_n > 0) ? self.Sum() / _n : 0;
        },
        Max: function() {
            var _flat = self.Flatten();
            if (array_length(_flat) == 0) return undefined;
            var _m = _flat[0];
            for (var _i = 1; _i < array_length(_flat); _i++) {
                if (_flat[_i] > _m) _m = _flat[_i];
            }
            return _m;
        },
        Min: function() {
            var _flat = self.Flatten();
            if (array_length(_flat) == 0) return undefined;
            var _m = _flat[0];
            for (var _i = 1; _i < array_length(_flat); _i++) {
                if (_flat[_i] < _m) _m = _flat[_i];
            }
            return _m;
        },
        Argmax: function() {
            var _flat = self.Flatten();
            if (array_length(_flat) == 0) return -1;
            var _idx = 0, _max = _flat[0];
            for (var _i = 1; _i < array_length(_flat); _i++) {
                if (_flat[_i] > _max) { _max = _flat[_i]; _idx = _i; }
            }
            return _idx;
        },
        Transpose: function() {
            if (self.Rank() != 2) return undefined;
            var _r = self.shape[0], _c = self.shape[1];
            var _out = [];
            for (var _j = 0; _j < _c; _j++) {
                _out[@ _j] = [];
                for (var _i = 0; _i < _r; _i++) {
                    _out[_j][@ _i] = self.Get([_i, _j]);
                }
            }
            return Tensor([_c, _r], _out);
        },
        UnSqueeze: function(_dim) {
            if (_dim < 0) _dim += self.Rank() + 1;
            if (_dim < 0 || _dim > self.Rank()) return undefined;
            var _new_shape = [];
            for (var _i = 0; _i < _dim; _i++) _new_shape[@ _i] = self.shape[_i];
            _new_shape[@ _dim] = 1;
            for (var _i = _dim; _i < self.Rank(); _i++) _new_shape[@ _i + 1] = self.shape[_i];
            var _flat = self.Flatten();
            var _data = self._build_from_flat(_flat, _new_shape);
            return Tensor(_new_shape, _data);
        },
        Squeeze: function(_dim = -1) {
            var _new_shape = [];
            if (_dim == -1) {
                for (var _i = 0; _i < array_length(self.shape); _i++) {
                    if (self.shape[_i] != 1) _new_shape[@ array_length(_new_shape)] = self.shape[_i];
                }
            } else {
                if (_dim < 0) _dim += self.Rank();
                if (_dim < 0 || _dim >= self.Rank() || self.shape[_dim] != 1) {
                    _new_shape = self.shape;
                } else {
                    for (var _i = 0; _i < array_length(self.shape); _i++) {
                        if (_i != _dim) _new_shape[@ array_length(_new_shape)] = self.shape[_i];
                    }
                }
            }
            var _flat = self.Flatten();
            var _data = self._build_from_flat(_flat, _new_shape);
            return Tensor(_new_shape, _data);
        }
        #endregion
    };

    #region 参数处理
    if (data == undefined) {
        TensorStruct.data = TensorStruct._create_data_from_shape(shape, 0);
    }
	#endregion
	
	#region 静态方法
	static Create = function(_shape, _fill_value) {
	    var _data = (Tensor(_shape, []))._create_data_from_shape(_shape, _fill_value);
	    return Tensor(_shape, _data);
	};
	static Zeros = function(_shape) { return Tensor.Create(_shape, 0); };
	static Ones = function(_shape) { return Tensor.Create(_shape, 1); };
	static Arange = function(_start, _end, _step = 1) {
	    if (_step == 0) _step = 1;
	    var _data = [];
	    var _val = _start;
	    if (_step > 0) {
	        while (_val < _end) { _data[@ array_length(_data)] = _val; _val += _step; }
	    } else {
	        while (_val > _end) { _data[@ array_length(_data)] = _val; _val += _step; }
	    }
	    return Tensor([array_length(_data)], _data);
	};
	static Eye = function(_n) {
	    var _data = [];
	    for (var _i = 0; _i < _n; _i++) {
	        _data[@ _i] = [];
	        for (var _j = 0; _j < _n; _j++) _data[_i][@ _j] = (_i == _j) ? 1 : 0;
	    }
	    return Tensor([_n, _n], _data);
	};
	static Rand = function(_shape) {
	    var _total = (Tensor(_shape))._product(_shape);
	    var _flat = [];
	    for (var _i = 0; _i < _total; _i++) _flat[@ _i] = random(1);
	    var _data = (Tensor(_shape))._build_from_flat(_flat, _shape);
	    return Tensor(_shape, _data);
	};
	static Randn = function(_shape) {
	    var _total = (Tensor(_shape))._product(_shape);
	    var _flat = [], _use_cached = false, _cached = 0;
	    for (var _i = 0; _i < _total; _i++) {
	        if (_use_cached) {
	            _flat[@ _i] = _cached;
	            _use_cached = false;
	        } else {
	            var _u1 = random(1), _u2 = random(1);
	            if (_u1 <= 0.000000001) _u1 = 0.000000001;
	            var _z0 = sqrt(-2 * ln(_u1)) * cos(2 * pi * _u2);
	            var _z1 = sqrt(-2 * ln(_u1)) * sin(2 * pi * _u2);
	            _flat[@ _i] = _z0;
	            _cached = _z1;
	            _use_cached = true;
	        }
	    }
	    var _data = (Tensor(_shape))._build_from_flat(_flat, _shape);
	    return Tensor(_shape, _data);
	};
	static Cat = function(_tensors, _dim = 0) {
	    if (array_length(_tensors) == 0) return undefined;
	    var _first = _tensors[0];
	    if (_first.Rank() != 2 || (_dim != 0 && _dim != 1)) return undefined;
	    var _rows = _first.shape[0], _cols = _first.shape[1];
	    var _tr = _rows, _tc = _cols;
	    if (_dim == 0) {
	        for (var _i = 1; _i < array_length(_tensors); _i++) {
	            if (_tensors[_i].shape[1] != _cols) return undefined;
	            _tr += _tensors[_i].shape[0];
	        }
	    } else {
	        for (var _i = 1; _i < array_length(_tensors); _i++) {
	            if (_tensors[_i].shape[0] != _rows) return undefined;
	            _tc += _tensors[_i].shape[1];
	        }
	    }
	    var _new_data = [];
	    if (_dim == 0) {
	        for (var _i = 0; _i < array_length(_tensors); _i++) {
	            var _td = _tensors[_i].data;
	            for (var _r = 0; _r < array_length(_td); _r++) {
	                _new_data[@ array_length(_new_data)] = _td[_r];
	            }
	        }
	    } else {
	        for (var _r = 0; _r < _rows; _r++) {
	            _new_data[@ _r] = [];
	            for (var _i = 0; _i < array_length(_tensors); _i++) {
	                var _src = _tensors[_i].data[_r];
	                for (var _c = 0; _c < array_length(_src); _c++) {
	                    _new_data[_r][@ array_length(_new_data[_r])] = _src[_c];
	                }
	            }
	        }
	    }
	    return Tensor([_tr, _tc], _new_data);
	};
	#endregion

    return TensorStruct;
}