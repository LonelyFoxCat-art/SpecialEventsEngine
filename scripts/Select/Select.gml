function Select(focus, title, option, w, h, _x, _y){
	return {
		type: "Select",
		mode: "Radio",			// Multi\Radio
		focus: focus,
		visible: true,
		
		sprite: noone,
		window_title: title,
		width: w,
		height: h,
		x: _x,
		y: _y,
		
		defined_draw: undefined,
		
		handle_keyboard: function() {},
		handle_mouse: function() {},
		draw: function(_x, _y) {
			if (is_method(self.defined_draw)) {
				self.defined_draw(self.sprite, self.window_title, self.x, self.y, self.width, self.height)
			}
		}
	}
}