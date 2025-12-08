/// @func Camera_Init()
/// @desc 初始化并创建一个相机实例，配置视图并禁用默认的 application_surface 绘制
/// @returns {struct} 返回初始化后的相机结构体，包含位置、尺寸、目标、边界、淡入淡出效果及更新回调函数

function Camera_Init(){
	var CameraStruct = {
		X: 0,
		Y: 0,
		Width: 640,
		Height: 480,
		Target: noone,
		Xscale: 1,
		Yscale: 1,
		Angle: 0,
		
		NoBorderFullScreen: false,
		
		Border: {
			Enabled: false,
			Sprite: noone
		},
		Fader: {
			Color: c_white,
			Alpha: 0,
		},
		
		UpdateStep: Camera_Update,
		UpdateDrawGUI: Camera_DrawGUI,
		UpdateDrawPost: Camera_DrawPost
	}
	
	CameraStruct.Camera = camera_create_view(CameraStruct.X, CameraStruct.Y, CameraStruct.Width, CameraStruct.Height, CameraStruct.Angle, CameraStruct.Target, 1, 1);
	
	application_surface_draw_enable(false);
	
	return CameraStruct;
}