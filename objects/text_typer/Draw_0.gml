if (!gui) {
	if (cover) {
		surface_set_target(Battle_GetBoardSurface())
			event_user(0)
		surface_reset_target()
	} else {
		event_user(0)
	}
}