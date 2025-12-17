/// @func Camera_Update(Camera)
/// @desc 更新指定相机的视图参数，包括目标对象、位置、尺寸、边框和旋转角度
/// @arg {struct} Camera - 相机配置结构体，包含 Target、X、Y、Width、Height、Xscale、Yscale、Angle 等字段

function Camera_Update(Camera){
	var CameraID = Camera_GetID()
	var Width = Camera.Width/Camera.Xscale;
	var Height = Camera.Height/Camera.Yscale;
	
	if(!instance_exists(Camera.Target)){
		camera_set_view_target(CameraID, noone);
		camera_set_view_pos(CameraID, Camera.X, Camera.Y);
	}else{
		camera_set_view_target(CameraID, Camera.Target);
		camera_set_view_border(CameraID, Width/2, Height/2);
		Camera.X = camera_get_view_x(CameraID);
		Camera.Y = camera_get_view_y(CameraID);
	}
	
	camera_set_view_size(CameraID, Width, Height);
	camera_set_view_angle(CameraID, Camera.Angle);
}