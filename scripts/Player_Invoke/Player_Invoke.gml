function Player_Invoke(Variable, Variable2, Variable3){
	var PlayerData = global.structure.Invoke("Player");
	var PlayerId = 0, Key, Value, IsGet = true;
	
	if (is_string(Variable)) {;
        Key = Variable;
        if (argument_count >= 2 && !is_undefined(Variable2)) {
            Value = Variable2;
            IsGet = false;
        }
    } else {
        PlayerId = Variable;
        Key = Variable2;
        if (argument_count >= 3 && !is_undefined(Variable3)) {
            Value = Variable3;
            IsGet = false;
        } else if (argument_count < 2 || is_undefined(Variable2)) {
            return undefined;
        }
    }
	
	var Player = PlayerData.PlayerList[PlayerId];
	
	if (IsGet) {
        if (struct_exists(Player, Key))  return struct_get(Player, Key);
		return Player;
    }
	
	struct_set(Player, Key, Value);
	
	return true;
}