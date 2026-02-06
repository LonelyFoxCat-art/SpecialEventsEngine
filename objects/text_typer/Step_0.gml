if (keyboard_check_pressed(ord("Z"))) {
	if (paused) { paused = false }
	if (Auto) {
		if (number >= string_length(text[index])) {
			if (index >= array_length(text) - 1) {
				instance_destroy()
			} else {
				index ++
				number = 1
			}
		}
	}
}

if (keyboard_check_pressed(ord("X"))) {
	skipping = true;
	sleep = 0;
	frame = 0;
}