function MakeBone(x, y, length, vspeed, hspeed, mode, cover, angle, bottom, destroy = -1){
	var Bone = instance_create(x, y, bullet_bone);
	Bone.length = length;
	Bone.vspeed = vspeed;
	Bone.hspeed = hspeed
	Bone.mode = mode;
	Bone.cover = cover;
	Bone.image_angle = angle;
	Bone.duration = destroy;
	Bone.image_index = bottom;
	return Bone;
}