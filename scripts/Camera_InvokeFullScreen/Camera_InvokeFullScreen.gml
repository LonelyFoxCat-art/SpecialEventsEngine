/// @func Camera_InvokeFullScreen(Enabled)
/// @desc 切换或查询无边框全屏模式状态。在非 TVOS 和 Android 平台上生效。
/// @arg {bool} [Enabled] - 若提供，则启用（true）或禁用（false）无边框全屏；若省略，则返回当前是否处于该模式
/// @returns {bool} 若查询模式（Enabled 为 undefined），返回当前 Enabled 状态；若执行切换操作，成功设置后返回 true，TVOS/Android 平台直接返回 false

function Camera_InvokeFullScreen(Enabled = undefined){
	var Camera = StorageData.Invoke("Camera");
	var NoBorderFull = Camera.NoBorderFull;
	var ResetWindow = function(Width, Height) {
		window_set_size(Width, Height);
		window_set_showborder(true);
		window_center();
	}
	
	if (os_type == os_tvos || os_type == os_android) return false;
	if (is_undefined(Enabled)) return NoBorderFull.Enabled;
	if (window_get_fullscreen()) {
		ResetWindow(NoBorderFull.Width, NoBorderFull.Height);
		return false;
	}
	
	if (Enabled) {
		NoBorderFull.Width = window_get_width();
		NoBorderFull.Height = window_get_height();
		window_set_showborder(false);
		window_set_rectangle(0, 0, display_get_width(), display_get_height());
	} else {
		ResetWindow(NoBorderFull.Width, NoBorderFull.Height);
	}
	
    NoBorderFull.Enabled = Enabled;
	return true;
}