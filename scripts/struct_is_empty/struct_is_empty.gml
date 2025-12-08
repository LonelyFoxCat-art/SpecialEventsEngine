function struct_is_empty(struct) {
	return array_length(struct_get_names(struct));
}