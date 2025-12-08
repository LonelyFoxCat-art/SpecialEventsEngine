// === SimplexNoise.constructor ===
function SimplexNoise() constructor {
    static _base_p = [
        151,160,137,91,90,15,131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
        190,6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,88,237,149,56,87,174,20,
        125,136,171,168,68,175,74,165,71,134,139,48,27,166,77,146,158,231,83,111,229,122,60,211,133,230,220,
        105,92,41,55,46,245,40,244,102,143,54,65,25,63,161,1,216,80,73,209,76,132,187,208,89,18,169,200,196,
        135,130,116,188,159,86,164,100,109,198,173,186,3,64,52,217,226,250,124,123,5,202,38,147,118,126,255,
        82,85,212,207,206,59,227,47,16,58,17,180,179,45,199,243,145,9,154,110,172,181,162,107,138,183,228,
        13,167,104,235,113,121,141,115,27,101,241,222,193,185,42,81,204,108,215,192,184,97,66,14,178,232,
        248,152,2,44,155,106,61,50,163,114,93,19,224,72,170,157,84,210,127,218,153,205,98,168,189,109,31,
        144,239,142,15,236,246,242,128,182,191,238,203,156,94,250,129,162,65,104,217,88,235,78,183,112,243,
        147,97,157,193,73,108,127,199,210,171,168,139,67,184,201,214,116,15,14,8,12,188,207,102,245,185,66,
        91,236,139,190,121,164,123,186,252,140,62,127,126,13,191,98,95,219,225,196,187,132,37,52,166,238,53,
        111,237,179,110,183,92,161,218,149,233,158,144,46,174,113,20,81,19,231,227,78,18,182,180,175,44,97,
        35,209,138,69,101,240,169,32,10,143,104,65,7,87,198,189,27,12,99,206,85,100,116,141,195,29,119,36,
        194,129,83,105,79,109,167,96,178,158,145,16,9,152,190,114,173,180,122,237,171,230,33,149,242,215,78,
        16,112,111,99,221,184,213,110,23,140,100,186,134,133,235,247,162,61,22,200,219,228,243,177,232,49,231,
        12,154,244,236,199,148,150,136,170,54,241,205,95,8,177,196,230,157,181,131,192,135,211,182,45,107,38,
        223,169,99,241,133,114,194,45,120,200,164,148,108,185,210,210,131,83,19,41,95,103,217,128,226,143,120,
        11,24,90,182,177,199,245,149,181,21,84,154,51,167,183,205,62,87,39,24,110,197,35,128,139,185,245,162,
        117,156,165,248,17,107,28,248,23,218,245,156,61,230,164,105,151,18,143,251,120,108,97,90,227,126,131,
        60,92,172,141,150,163,231,154,85,210,128,37,32,178,79,188,93,116,228,125,252,110,190,99,145,68,131,32,
        178,79,188,93,116,228,125,252,110,190,99,145,68,131,32,178,79,188,93,116,228,125,252,110,190,99,145,
        68,131,32,178,79,188,93,116,228,125,252,110,190,99,145,68
    ];

    static _grad1 = [1, -1];
    static _grad2 = [
        [ 1, 1], [-1, 1], [ 1,-1], [-1,-1],
        [ 1, 0], [-1, 0], [ 0, 1], [ 0,-1]
    ];
    static _grad3 = [
        [ 1, 1, 0], [-1, 1, 0], [ 1,-1, 0], [-1,-1, 0],
        [ 1, 0, 1], [-1, 0, 1], [ 1, 0,-1], [-1, 0,-1],
        [ 0, 1, 1], [ 0,-1, 1], [ 0, 1,-1], [ 0,-1,-1]
    ];
    static _grad4 = [
        [ 1, 1, 1, 1], [-1, 1, 1, 1], [ 1,-1, 1, 1], [-1,-1, 1, 1],
        [ 1, 1,-1, 1], [-1, 1,-1, 1], [ 1,-1,-1, 1], [-1,-1,-1, 1],
        [ 1, 1, 1,-1], [-1, 1, 1,-1], [ 1,-1, 1,-1], [-1,-1, 1,-1],
        [ 1, 1,-1,-1], [-1, 1,-1,-1], [ 1,-1,-1,-1], [-1,-1,-1,-1]
    ];

    // 当前使用的排列表（可被 seed 修改）
    static _perm = undefined;

    // 初始化默认排列表
    static _init_default_perm = function() {
        if (is_undefined(_perm)) {
            var _len = array_length(_base_p);
            _perm = array_create(_len * 2, 0);
            for (var _i = 0; _i < _len; _i++) {
                _perm[_i] = _base_p[_i];
                _perm[_i + _len] = _base_p[_i];
            }
        }
    };

    // Fisher-Yates 打乱（用于 seed）
    static _shuffle = function(_arr, _seed) {
        // 简易线性同余伪随机（GML 无内置 PRNG 状态隔离）
        var _state = _seed;
        var _lcg = function() {
            _state = (_state * 1664525 + 1013904223) & 0x7FFFFFFF;
            return _state / 2147483648.0;
        };

        var _n = array_length(_arr);
        for (var _i = _n - 1; _i > 0; _i--) {
            var _j = floor(_lcg() * (_i + 1));
            var _tmp = _arr[_i];
            _arr[_i] = _arr[_j];
            _arr[_j] = _tmp;
        }
    };

    // === 公共 API ===

    // 设置种子（影响后续所有 noise 调用）
    static seed = function(_s) {
        var _p_copy = array_create(array_length(_base_p), 0);
        for (var _i = 0; _i < array_length(_base_p); _i++) {
            _p_copy[_i] = _base_p[_i];
        }
        _shuffle(_p_copy, _s);
        _perm = array_create(array_length(_p_copy) * 2, 0);
        var _len = array_length(_p_copy);
        for (var _i = 0; _i < _len; _i++) {
            _perm[_i] = _p_copy[_i];
            _perm[_i + _len] = _p_copy[_i];
        }
    };

    // 恢复默认（无种子）噪声
    static reset_seed = function() {
        _perm = undefined;
        _init_default_perm();
    };

    // --- 1D ---
    static noise1 = function(_x) {
        _init_default_perm();
        var _i = floor(_x);
        var _t0 = _x - _i;
        var _t1 = _t0 - 1.0;
        var _ii = _i & 255;

        var _n0 = 0, _n1 = 0;
        var _t = 1.0 - _t0 * _t0;
        if (_t > 0) {
            _t *= _t;
            var _gi = _perm[_ii] % 2;
            _n0 = _t * _t * (_grad1[_gi] * _t0);
        }
        _t = 1.0 - _t1 * _t1;
        if (_t > 0) {
            _t *= _t;
            var _gi = _perm[_ii + 1] % 2;
            _n1 = _t * _t * (_grad1[_gi] * _t1);
        }
        return 256.0 * (_n0 + _n1);
    };

    // --- 2D（略作优化，保留原逻辑）---
    static noise2 = function(_x, _y) {
        _init_default_perm();
        var _F2 = 0.5 * (sqrt(3.0) - 1.0);
        var _s = (_x + _y) * _F2;
        var _i = floor(_x + _s);
        var _j = floor(_y + _s);
        var _G2 = (3.0 - sqrt(3.0)) / 6.0;
        var _t = (_i + _j) * _G2;
        var _x0 = _x - (_i - _t);
        var _y0 = _y - (_j - _t);

        var _i1 = (_x0 > _y0) ? 1 : 0;
        var _j1 = 1 - _i1;

        var _x1 = _x0 - _i1 + _G2;
        var _y1 = _y0 - _j1 + _G2;
        var _x2 = _x0 - 1.0 + 2.0 * _G2;
        var _y2 = _y0 - 1.0 + 2.0 * _G2;

        var _ii = _i & 255;
        var _jj = _j & 255;

        var _n0 = 0, _n1 = 0, _n2 = 0;

        var _t0 = 0.5 - _x0*_x0 - _y0*_y0;
        if (_t0 > 0) {
            _t0 *= _t0;
            var _gi = _perm[_ii + _perm[_jj]] % 8;
            var _g = _grad2[_gi];
            _n0 = _t0 * _t0 * (_g[0]*_x0 + _g[1]*_y0);
        }

        var _t1 = 0.5 - _x1*_x1 - _y1*_y1;
        if (_t1 > 0) {
            _t1 *= _t1;
            var _gi = _perm[_ii + _i1 + _perm[_jj + _j1]] % 8;
            var _g = _grad2[_gi];
            _n1 = _t1 * _t1 * (_g[0]*_x1 + _g[1]*_y1);
        }

        var _t2 = 0.5 - _x2*_x2 - _y2*_y2;
        if (_t2 > 0) {
            _t2 *= _t2;
            var _gi = _perm[_ii + 1 + _perm[_jj + 1]] % 8;
            var _g = _grad2[_gi];
            _n2 = _t2 * _t2 * (_g[0]*_x2 + _g[1]*_y2);
        }

        return 70.0 * (_n0 + _n1 + _n2);
    };

    // --- 3D（同上）---
    static noise3 = function(_x, _y, _z) {
        _init_default_perm();
        var _F3 = 1.0 / 3.0;
        var _s = (_x + _y + _z) * _F3;
        var _i = floor(_x + _s);
        var _j = floor(_y + _s);
        var _k = floor(_z + _s);
        var _G3 = 1.0 / 6.0;
        var _t = (_i + _j + _k) * _G3;
        var _x0 = _x - (_i - _t);
        var _y0 = _y - (_j - _t);
        var _z0 = _z - (_k - _t);

        var _i1, _j1, _k1, _i2, _j2, _k2;
        if (_x0 >= _y0) {
            if (_y0 >= _z0)      { _i1=1; _j1=0; _k1=0; _i2=1; _j2=1; _k2=0; }
            else if (_x0 >= _z0) { _i1=1; _j1=0; _k1=0; _i2=1; _j2=0; _k2=1; }
            else                 { _i1=0; _j1=0; _k1=1; _i2=1; _j2=0; _k2=1; }
        } else {
            if (_y0 < _z0)       { _i1=0; _j1=0; _k1=1; _i2=0; _j2=1; _k2=1; }
            else if (_x0 < _z0)  { _i1=0; _j1=1; _k1=0; _i2=0; _j2=1; _k2=1; }
            else                 { _i1=0; _j1=1; _k1=0; _i2=1; _j2=1; _k2=0; }
        }

        var _x1 = _x0 - _i1 + _G3;
        var _y1 = _y0 - _j1 + _G3;
        var _z1 = _z0 - _k1 + _G3;
        var _x2 = _x0 - _i2 + 2.0 * _G3;
        var _y2 = _y0 - _j2 + 2.0 * _G3;
        var _z2 = _z0 - _k2 + 2.0 * _G3;
        var _x3 = _x0 - 1.0 + 3.0 * _G3;
        var _y3 = _y0 - 1.0 + 3.0 * _G3;
        var _z3 = _z0 - 1.0 + 3.0 * _G3;

        var _ii = _i & 255;
        var _jj = _j & 255;
        var _kk = _k & 255;

        var _n0 = 0, _n1 = 0, _n2 = 0, _n3 = 0;

        var _t0 = 0.6 - _x0*_x0 - _y0*_y0 - _z0*_z0;
        if (_t0 > 0) {
            _t0 *= _t0;
            var _gi = _perm[_ii + _perm[_jj + _perm[_kk]]] % 12;
            var _g = _grad3[_gi];
            _n0 = _t0 * _t0 * (_g[0]*_x0 + _g[1]*_y0 + _g[2]*_z0);
        }

        var _t1 = 0.6 - _x1*_x1 - _y1*_y1 - _z1*_z1;
        if (_t1 > 0) {
            _t1 *= _t1;
            var _gi = _perm[_ii+_i1 + _perm[_jj+_j1 + _perm[_kk+_k1]]] % 12;
            var _g = _grad3[_gi];
            _n1 = _t1 * _t1 * (_g[0]*_x1 + _g[1]*_y1 + _g[2]*_z1);
        }

        var _t2 = 0.6 - _x2*_x2 - _y2*_y2 - _z2*_z2;
        if (_t2 > 0) {
            _t2 *= _t2;
            var _gi = _perm[_ii+_i2 + _perm[_jj+_j2 + _perm[_kk+_k2]]] % 12;
            var _g = _grad3[_gi];
            _n2 = _t2 * _t2 * (_g[0]*_x2 + _g[1]*_y2 + _g[2]*_z2);
        }

        var _t3 = 0.6 - _x3*_x3 - _y3*_y3 - _z3*_z3;
        if (_t3 > 0) {
            _t3 *= _t3;
            var _gi = _perm[_ii+1 + _perm[_jj+1 + _perm[_kk+1]]] % 12;
            var _g = _grad3[_gi];
            _n3 = _t3 * _t3 * (_g[0]*_x3 + _g[1]*_y3 + _g[2]*_z3);
        }

        return 32.0 * (_n0 + _n1 + _n2 + _n3);
    };

    // --- 4D ---
    static noise4 = function(_x, _y, _z, _w) {
        _init_default_perm();
        var _F4 = (sqrt(5.0) - 1.0) / 4.0;
        var _s = (_x + _y + _z + _w) * _F4;
        var _i = floor(_x + _s);
        var _j = floor(_y + _s);
        var _k = floor(_z + _s);
        var _l = floor(_w + _s);
        var _G4 = (5.0 - sqrt(5.0)) / 20.0;
        var _t = (_i + _j + _k + _l) * _G4;
        var _x0 = _x - (_i - _t);
        var _y0 = _y - (_j - _t);
        var _z0 = _z - (_k - _t);
        var _w0 = _w - (_l - _t);

        // 排序以确定单纯形（简化版：使用固定偏移）
        // 实际 4D simplex 有 24 个顶点，此处采用标准实现
        var _rankx = 0, _ranky = 0, _rankz = 0, _rankw = 0;
        if (_x0 > _y0) _rankx++; else _ranky++;
        if (_x0 > _z0) _rankx++; else _rankz++;
        if (_x0 > _w0) _rankx++; else _rankw++;
        if (_y0 > _z0) _ranky++; else _rankz++;
        if (_y0 > _w0) _ranky++; else _rankw++;
        if (_z0 > _w0) _rankz++; else _rankw++;

        var _i1 = (_rankx >= 3) ? 1 : 0;
        var _j1 = (_ranky >= 3) ? 1 : 0;
        var _k1 = (_rankz >= 3) ? 1 : 0;
        var _l1 = (_rankw >= 3) ? 1 : 0;

        var _i2 = (_rankx >= 2) ? 1 : 0;
        var _j2 = (_ranky >= 2) ? 1 : 0;
        var _k2 = (_rankz >= 2) ? 1 : 0;
        var _l2 = (_rankw >= 2) ? 1 : 0;

        var _i3 = (_rankx >= 1) ? 1 : 0;
        var _j3 = (_ranky >= 1) ? 1 : 0;
        var _k3 = (_rankz >= 1) ? 1 : 0;
        var _l3 = (_rankw >= 1) ? 1 : 0;

        var _x1 = _x0 - _i1 + _G4;
        var _y1 = _y0 - _j1 + _G4;
        var _z1 = _z0 - _k1 + _G4;
        var _w1 = _w0 - _l1 + _G4;

        var _x2 = _x0 - _i2 + 2.0 * _G4;
        var _y2 = _y0 - _j2 + 2.0 * _G4;
        var _z2 = _z0 - _k2 + 2.0 * _G4;
        var _w2 = _w0 - _l2 + 2.0 * _G4;

        var _x3 = _x0 - _i3 + 3.0 * _G4;
        var _y3 = _y0 - _j3 + 3.0 * _G4;
        var _z3 = _z0 - _k3 + 3.0 * _G4;
        var _w3 = _w0 - _l3 + 3.0 * _G4;

        var _x4 = _x0 - 1.0 + 4.0 * _G4;
        var _y4 = _y0 - 1.0 + 4.0 * _G4;
        var _z4 = _z0 - 1.0 + 4.0 * _G4;
        var _w4 = _w0 - 1.0 + 4.0 * _G4;

        var _ii = _i & 255;
        var _jj = _j & 255;
        var _kk = _k & 255;
        var _ll = _l & 255;

        var _n0 = 0, _n1 = 0, _n2 = 0, _n3 = 0, _n4 = 0;

        var _t0 = 0.6 - _x0*_x0 - _y0*_y0 - _z0*_z0 - _w0*_w0;
        if (_t0 > 0) {
            _t0 *= _t0;
            var _gi = _perm[_ii + _perm[_jj + _perm[_kk + _perm[_ll]]]] % 16;
            var _g = _grad4[_gi];
            _n0 = _t0 * _t0 * (_g[0]*_x0 + _g[1]*_y0 + _g[2]*_z0 + _g[3]*_w0);
        }

        var _t1 = 0.6 - _x1*_x1 - _y1*_y1 - _z1*_z1 - _w1*_w1;
        if (_t1 > 0) {
            _t1 *= _t1;
            var _gi = _perm[_ii+_i1 + _perm[_jj+_j1 + _perm[_kk+_k1 + _perm[_ll+_l1]]]] % 16;
            var _g = _grad4[_gi];
            _n1 = _t1 * _t1 * (_g[0]*_x1 + _g[1]*_y1 + _g[2]*_z1 + _g[3]*_w1);
        }

        var _t2 = 0.6 - _x2*_x2 - _y2*_y2 - _z2*_z2 - _w2*_w2;
        if (_t2 > 0) {
            _t2 *= _t2;
            var _gi = _perm[_ii+_i2 + _perm[_jj+_j2 + _perm[_kk+_k2 + _perm[_ll+_l2]]]] % 16;
            var _g = _grad4[_gi];
            _n2 = _t2 * _t2 * (_g[0]*_x2 + _g[1]*_y2 + _g[2]*_z2 + _g[3]*_w2);
        }

        var _t3 = 0.6 - _x3*_x3 - _y3*_y3 - _z3*_z3 - _w3*_w3;
        if (_t3 > 0) {
            _t3 *= _t3;
            var _gi = _perm[_ii+_i3 + _perm[_jj+_j3 + _perm[_kk+_k3 + _perm[_ll+_l3]]]] % 16;
            var _g = _grad4[_gi];
            _n3 = _t3 * _t3 * (_g[0]*_x3 + _g[1]*_y3 + _g[2]*_z3 + _g[3]*_w3);
        }

        var _t4 = 0.6 - _x4*_x4 - _y4*_y4 - _z4*_z4 - _w4*_w4;
        if (_t4 > 0) {
            _t4 *= _t4;
            var _gi = _perm[_ii+1 + _perm[_jj+1 + _perm[_kk+1 + _perm[_ll+1]]]] % 16;
            var _g = _grad4[_gi];
            _n4 = _t4 * _t4 * (_g[0]*_x4 + _g[1]*_y4 + _g[2]*_z4 + _g[3]*_w4);
        }

        return 27.0 * (_n0 + _n1 + _n2 + _n3 + _n4);
    };

    // --- 分形噪声（FBM）---
    static fractal = function(_x, _y, _octaves = 4, _persistence = 0.5, _lacunarity = 2.0) {
        var _total = 0.0;
        var _frequency = 1.0;
        var _amplitude = 1.0;
        var _max_amp = 0.0;

        for (var _i = 0; _i < _octaves; _i++) {
            _total += SimplexNoise.noise2(_x * _frequency, _y * _frequency) * _amplitude;
            _max_amp += _amplitude;
            _amplitude *= _persistence;
            _frequency *= _lacunarity;
        }

        // 归一化到 [-1, 1]
        return _total / _max_amp;
    };
};