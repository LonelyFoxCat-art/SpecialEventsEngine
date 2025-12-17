/// @func Camera_InvokeBorder(Enabled = undefined)
/// @desc 切换或查询窗口边框模式（有边框 vs 无边框窗口尺寸）。在非 TVOS 和 Android 平台上生效。
/// @arg {bool} [Enabled] - 若提供，则启用（true）边框模式（窗口设为 960x540）或禁用（false）；若省略或非布尔值，则返回当前边框模式状态
/// @returns {bool} 若查询状态（Enabled 非布尔），返回当前 Border.Enabled；若执行设置，成功后返回 true；TVOS/Android 平台直接返回 false

function Camera_InvokeBorder(Enabled = undefined){
	var Camera = StorageData.Invoke("Camera");
	var NoBorderFull = Camera.NoBorderFull;
	var Border = Camera.Border;
	var Width = Camera.Width, Height = Camera.Height;
	
	if (os_type == os_tvos || os_type == os_android) return false;
	if (!is_bool(Enabled)) return Border.Enabled;
	if (Enabled) { Width = 960; Height = 540; }
	if (!NoBorderFull.Enabled) window_set_size(Width, Height);

	NoBorderFull.Width = Width;
	NoBorderFull.Height = Height;
	Border.Enabled = Enabled;
	return true;
}