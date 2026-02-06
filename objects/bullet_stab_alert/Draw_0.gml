draw_set_color(color)
if (cover) {
	surface_set_target(Battle_GetBoardSurface())
		draw_rectangle(x1, y1, x2, y2, false)
	surface_reset_target()
} else {
	draw_rectangle(x1, y1, x2, y2, false)
}
