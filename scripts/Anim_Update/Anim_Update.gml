/// @func Anim_Update(AnimSystem)
/// @desc 更新动画系统中的所有动画，根据循环模式、缓动函数和贝塞尔控制器计算当前值并应用到目标对象
/// @arg {struct} AnimSystem - 包含动画列表（AnimationList）、全局速度（AnimSpeed）等信息的动画系统结构体

function Anim_Update(AnimSystem) {
    var dt = 1;
    var global_speed = AnimSystem.AnimSpeed;
    var list = AnimSystem.AnimationList;
    var len = array_length(list);
    
    for (var i = len - 1; i >= 0; i--) {
        var anim = list[i];
        
		if (anim.Delay > 0) { anim.Delay --; continue; }
        if (anim.Pause) continue;
        
        if (variable_struct_exists(anim, "IsBezier") && anim.IsBezier) {
            var time_delta = dt * global_speed * anim.Speed;
            anim.Time += time_delta;
            
            if (anim.Time < 0) continue;
            
            var dur = anim.Duration;
            var t_raw = anim.Time / dur;
            var t_final = 0;
            var should_remove = false;
            
            switch (anim.LoopMode) {
                case AnimLoopMode.NONE:
                    if (anim.Time >= dur) {
                        t_final = 1;
                        should_remove = true;
                    } else if (anim.Time <= 0) {
                        t_final = 0;
                    } else {
                        t_final = t_raw;
                    }
                    break;
                    
                case AnimLoopMode.LOOP:
                    t_final = t_raw - floor(t_raw);
                    if (t_final < 0) t_final += 1;
                    break;
                    
                case AnimLoopMode.YOYO:
                    var cycle = floor(t_raw);
                    var local_t = t_raw - cycle;
                    t_final = (cycle % 2 == 0) ? local_t : (1 - local_t);
                    break;
                    
                case AnimLoopMode.FINITELOOP:
                    var loops = (t_raw >= 0) ? floor(t_raw) : ceil(t_raw);
                    if (anim.MaxCount > 0 && abs(loops) >= anim.MaxCount) {
                        t_final = (t_raw >= 0) ? 1 : 0;
                        anim.Time = (t_raw >= 0) ? dur * anim.MaxCount : -dur * anim.MaxCount;
                        should_remove = true;
                    } else {
                        t_final = t_raw - loops;
                        if (t_final < 0) t_final += 1;
                        anim.Count = abs(loops);
                    }
                    break;
                    
                case AnimLoopMode.FINITE_YOYO:
                    var yoyo_dur = dur * 2;
                    var yoyo_raw = anim.Time / yoyo_dur;
                    var yoyo_cycle = (anim.Time >= 0) ? floor(yoyo_raw) : ceil(yoyo_raw);
                    
                    if (anim.MaxCount > 0 && abs(yoyo_cycle) >= anim.MaxCount) {
                        t_final = 0;
                        anim.Time = yoyo_cycle * yoyo_dur;
                        should_remove = true;
                    } else {
                        var local_yoyo = yoyo_raw - yoyo_cycle;
                        if (local_yoyo < 0) local_yoyo += 1;
                        t_final = (local_yoyo <= 0.5) ? (local_yoyo * 2) : ((1 - local_yoyo) * 2);
                        anim.Count = abs(yoyo_cycle);
                    }
                    break;
                    
                default:
                    t_final = clamp(t_raw, 0, 1);
                    break;
            }
            
            var pt = anim.BezierController.getPointAt(t_final);
            
            var vars = anim.VarNames;
            for (var v = 0; v < array_length(vars); v++) {
                var var_name = vars[v];
                var value = 0;
                
                if (var_name == "x") value = pt.x;
                else if (var_name == "y") value = pt.y;
                else if (var_name == "z" && variable_struct_exists(pt, "z")) value = pt.z;
                else value = (variable_struct_exists(pt, "y")) ? pt.y : pt.x;
                
                if (variable_exists(anim.Target, var_name)) variable_set(anim.Target, var_name, value);
            }
            
            if (should_remove) array_delete(list, i, 1);
            
            continue;
        }

        var time_delta = dt * global_speed * anim.Speed;
        anim.Time += time_delta;
        
        if (anim.Time < 0) continue;
        
        var dur = anim.Duration;
        var t_raw = anim.Time / dur;
        var t_final = 0;
        var should_remove = false;
		
		if (!variable_exists(anim.Target, anim.VarName)) should_remove = true;
        
        switch (anim.LoopMode) {
            case AnimLoopMode.NONE:
                if (anim.Time >= dur) {
                    t_final = 1;
                    should_remove = true;
                } else if (anim.Time <= 0) {
                    t_final = 0;
                } else {
                    t_final = t_raw;
                }
                break;
                
            case AnimLoopMode.LOOP:
                t_final = t_raw - floor(t_raw);
                if (t_final < 0) t_final += 1;
                break;
                
            case AnimLoopMode.YOYO:
                var cycle = floor(t_raw);
                var local_t = t_raw - cycle;
                t_final = (cycle % 2 == 0) ? local_t : (1 - local_t);
                break;
                
            case AnimLoopMode.FINITELOOP:
                var loops = (t_raw >= 0) ? floor(t_raw) : ceil(t_raw);
                if (anim.MaxCount > 0 && abs(loops) >= anim.MaxCount) {
                    t_final = (t_raw >= 0) ? 1 : 0;
                    anim.Time = (t_raw >= 0) ? dur * anim.MaxCount : -dur * anim.MaxCount;
                    should_remove = true;
                } else {
                    t_final = t_raw - loops;
                    if (t_final < 0) t_final += 1;
                    anim.Count = abs(loops);
                }
                break;
                
            case AnimLoopMode.FINITE_YOYO:
                var yoyo_dur = dur * 2;
                var yoyo_raw = anim.Time / yoyo_dur;
                var yoyo_cycle = (anim.Time >= 0) ? floor(yoyo_raw) : ceil(yoyo_raw);
                
                if (anim.MaxCount > 0 && abs(yoyo_cycle) >= anim.MaxCount) {
                    t_final = 0;
                    anim.Time = yoyo_cycle * yoyo_dur;
                    should_remove = true;
                } else {
                    var local_yoyo = yoyo_raw - yoyo_cycle;
                    if (local_yoyo < 0) local_yoyo += 1;
                    t_final = (local_yoyo <= 0.5) ? (local_yoyo * 2) : ((1 - local_yoyo) * 2);
                    anim.Count = abs(yoyo_cycle);
                }
                break;
                
            default:
                t_final = clamp(t_raw, 0, 1);
                break;
        }
        
        var tweened = t_final;
        if (is_method(anim.Tween)) tweened = anim.Tween(t_final);
		
		var currentValue = anim.StartValue + anim.FinishValue * tweened
        
        if (variable_exists(anim.Target, anim.VarName)) variable_set(anim.Target, anim.VarName, currentValue);
        if (should_remove) array_delete(list, i, 1);
    }
}