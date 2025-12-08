function array_delete_at(arr, index){
	if (index < 0 || index >= array_length(arr)) return arr;
	var new_arr = [];
	for (var i = 0; i < array_length(arr); i++) {
		if (i != index) array_push(new_arr, arr[i]);
	}
	return new_arr;
}