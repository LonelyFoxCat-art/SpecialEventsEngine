function Increase(base = 0, Type = "+") {
    return {
        base_value: base,
        type: Type,
        modifiers: struct_create(),
        
        Set: function(_key, _value) {
            self.modifiers[$ string(_key)] = _value;
        },
        
        Remove: function(_key) {
            _key = string(_key);
            if (struct_exists(self.modifiers, _key)) {
                struct_remove(self.modifiers, _key);
                return true;
            }
            return false;
        },
        
        Get: function() {
            var _type = self.type;
            if (_type == undefined || _type == "") _type = "+";
            
            var keys = struct_get_names(self.modifiers);
            if (array_length(keys) == 0) {
                return self.base_value;
            }
            
            var result = 0;
            
            for (var i = 0; i < array_length(keys); i++) {
                var val = self.modifiers[$ keys[i]];
                if (!is_real(val)) continue;
                
                switch (_type) {
                    case "+": result += val; break;
                    case "-": result -= val; break;
                    case "*": result *= val; break;
                    case "/": 
                        if (val != 0) result /= val; 
                        else show_debug_message("Divide by zero in Increase.Get()"); 
                        break;
                    case "max": result = max(result, val); break;
                    case "min": result = min(result, val); break;
                }
            }
            
            if (_type == "*" || _type == "/") {
                return self.base_value * result;
            } else {
                return self.base_value + result;
            }
        },
        
        GetBonus: function(Name = "") {
            var original_type = self.type;
            var temp = Increase(0);
            temp.type = original_type;
            temp.modifiers = self.modifiers;
            return temp.Get();
        }
    };
}