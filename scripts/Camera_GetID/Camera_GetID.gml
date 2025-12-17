function Camera_GetID(){
	var CameraDate = StorageData.Invoke("Camera");
	return CameraDate.Camera;
}