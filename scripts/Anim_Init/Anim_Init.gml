/// @func Anim_Init()
/// @desc 初始化动画系统数据结构
/// @returns {struct} 包含当前动画ID、动画列表和更新函数的结构
function Anim_Init(){
	globalvar AnimType, AnimTween, AnimLoopMode;
	
	AnimType = {
		GLOBAL: "global",
		INDIVIDUAL: "individual"
	}
	AnimLoopMode = {
	    NONE: "None",
	    LOOP: "Loop",
	    YOYO: "Yoyo",
	    FINITELOOP: "FiniteLoop",
	    FINITE_YOYO: "FiniteYoyo"
	};
	AnimTween = {
	    Linear: function(t) { return t; },
    
	    SINE: {
	        IN: function(t) { return 1 - cos(t * pi / 2); },
	        OUT: function(t) { return sin(t * pi / 2); },
	        IN_OUT: function(t) { return -(cos(pi * t) - 1) / 2; }
	    },
    
	    QUAD: {
	        IN: function(t) { return t * t; },
	        OUT: function(t) { return 1 - (1 - t) * (1 - t); },
	        IN_OUT: function(t) {
	            if (t < 0.5) return 2 * t * t;
	            else return 1 - power(-2 * t + 2, 2) / 2;
	        }
	    },
    
	    CUBIC: {
	        IN: function(t) { return t * t * t; },
	        OUT: function(t) { return 1 - power(1 - t, 3); },
	        IN_OUT: function(t) {
	            if (t < 0.5) return 4 * t * t * t;
	            else return 1 - power(-2 * t + 2, 3) / 2;
	        }
	    },
    
	    QUART: {
	        IN: function(t) { return t * t * t * t; },
	        OUT: function(t) { return 1 - power(1 - t, 4); },
	        IN_OUT: function(t) {
	            if (t < 0.5) return 8 * t * t * t * t;
	            else return 1 - power(-2 * t + 2, 4) / 2;
	        }
	    },
    
	    QUINT: {
	        IN: function(t) { return t * t * t * t * t; },
	        OUT: function(t) { return 1 - power(1 - t, 5); },
	        IN_OUT: function(t) {
	            if (t < 0.5) return 16 * t * t * t * t * t;
	            else return 1 - power(-2 * t + 2, 5) / 2;
	        }
	    },
    
	    EXPO: {
	        IN: function(t) { return (t == 0) ? 0 : power(2, 10 * (t - 1)); },
	        OUT: function(t) { return (t == 1) ? 1 : 1 - power(2, -10 * t); },
	        IN_OUT: function(t) {
	            if (t == 0) return 0;
	            if (t == 1) return 1;
	            if (t < 0.5) return power(2, 20 * t - 10) / 2;
	            else return (2 - power(2, -20 * t + 10)) / 2;
	        }
	    },
    
	    CIRC: {
	        IN: function(t) { return 1 - sqrt(1 - t * t); },
	        OUT: function(t) { return sqrt(1 - power(t - 1, 2)); },
	        IN_OUT: function(t) {
	            if (t < 0.5) return (1 - sqrt(1 - 4 * t * t)) / 2;
	            else return (sqrt(1 - power(-2 * t + 2, 2)) + 1) / 2;
	        }
	    },
    
	    BACK: {
	        IN: function(t, s = 1.70158) {
	            return t * t * ((s + 1) * t - s);
	        },
	        OUT: function(t, s = 1.70158) {
	            t -= 1;
	            return t * t * ((s + 1) * t + s) + 1;
	        },
	        IN_OUT: function(t, s = 1.70158) {
	            s *= 1.525;
	            if (t < 0.5) {
	                t *= 2;
	                return (t * t * ((s + 1) * t - s)) / 2;
	            } else {
	                t = t * 2 - 2;
	                return (t * t * ((s + 1) * t + s) + 2) / 2;
	            }
	        }
	    },
    
	    ELASTIC: {
	        IN: function(t, a = 0, p = 0) {
	            if (t == 0) return 0;
	            if (t == 1) return 1;
	            if (p == 0) p = 0.3;
	            var s;
	            if (a < 1) { a = 1; s = p / 4; }
	            else s = p / (2 * pi) * arcsin(1 / a);
	            t -= 1;
	            return -(a * power(2, 10 * t) * sin((t - s) * (2 * pi) / p));
	        },
	        OUT: function(t, a = 0, p = 0) {
	            if (t == 0) return 0;
	            if (t == 1) return 1;
	            if (p == 0) p = 0.3;
	            var s;
	            if (a < 1) { a = 1; s = p / 4; }
	            else s = p / (2 * pi) * arcsin(1 / a);
	            return a * power(2, -10 * t) * sin((t - s) * (2 * pi) / p) + 1;
	        },
	        IN_OUT: function(t, a = 0, p = 0) {
	            if (t == 0) return 0;
	            if (t == 1) return 1;
	            if (p == 0) p = 0.45;
	            var s;
	            if (a < 1) { a = 1; s = p / 4; }
	            else s = p / (2 * pi) * arcsin(1 / a);
	            t -= 0.5;
	            if (t < 0) {
	                return -0.5 * (a * power(2, 20 * t) * sin((2 * t - s) * (2 * pi) / p));
	            } else {
	                return a * power(2, -20 * t) * sin((2 * t - s) * (2 * pi) / p) * 0.5 + 1;
	            }
	        }
	    },
    
	    BOUNCE: {
	        OUT: function(t) {
	            var n1 = 7.5625;
	            var d1 = 2.75;
	            if (t < 1 / d1) {
	                return n1 * t * t;
	            } else if (t < 2 / d1) {
	                t -= 1.5 / d1;
	                return n1 * t * t + 0.75;
	            } else if (t < 2.5 / d1) {
	                t -= 2.25 / d1;
	                return n1 * t * t + 0.9375;
	            } else {
	                t -= 2.625 / d1;
	                return n1 * t * t + 0.984375;
	            }
	        },
	        IN: function(t) { return 1 - AnimTween.BOUNCE.OUT(1 - t); },
	        IN_OUT: function(t) {
	            if (t < 0.5) return (1 - AnimTween.BOUNCE.OUT(1 - 2 * t)) * 0.5;
	            else return (1 + AnimTween.BOUNCE.OUT(2 * t - 1)) * 0.5;
	        }
	    },
    
	    SMOOTHSTEP: function(t) { return t * t * (3 - 2 * t); },
	    SMOTHERSTEP: function(t) { return t * t * t * (t * (t * 6 - 15) + 10); },
	};
	
	return {
		Animation_id: 0,
		AnimationList: [],
		AnimSpeed: 1,
		UpdateStep: Anim_Update
	};
}