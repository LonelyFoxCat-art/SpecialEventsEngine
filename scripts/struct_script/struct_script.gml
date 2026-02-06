function struct_script(id, Name){
	if (struct_exists(id, Name)) {
		var value = struct_get(id, Name);
		return is_method(value) ? value : false;
	}
	
	return false;
}