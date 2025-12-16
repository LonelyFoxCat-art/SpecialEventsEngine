function GetType(Value){
	var Type = typeof(Value);
	
	if (is_struct(Value) && struct_exists(Value, "type")) return Value.type;
	
	return Type;
}