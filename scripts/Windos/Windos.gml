function Windos(focus, title, w, h, _x, _y){
	return {
		type: "Windos",
		focus: focus,
		visible: true,
		
		elements: [],
		
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