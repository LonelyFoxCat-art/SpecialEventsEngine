/// @func Camera_InvokeFullScreen(Enabled = undefined)
/// @desc 获取或设置相机的无边框全屏模式；在 tvOS 和 Android 上不支持，返回 false
/// @arg {bool} [Enabled] - 若提供，则启用（true）或禁用（false）无边框全屏；若省略，则返回当前状态
/// @returns {bool|real} 若传入 Enabled，操作成功返回 true；若未传入，返回当前 NoBorderFullScreen 的布尔值；在不支持的平台上返回 false

function Camera_InvokeFullScreen(Enabled = undefined){
	var Camera = global.structure.Invoke("Camera");
	if (os_type == os_tvos || os_type == os_android) return false;
	if is_undefined(Enabled) return Camera.NoBorderFullScreen;
	
	if (Enabled) {
		window_set_showborder(false);
		window_set_rectangle(0, 0, display_get_width(), display_get_height());
	} else {
		window_set_showborder(true);
		window_set_size(Camera.Width, Camera.Height);
		window_center();
	}
	
    Camera.NoBorderFullScreen = Enabled;
	return true;
}