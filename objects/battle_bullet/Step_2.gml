if (follow.enabled) {
	if (!processed) {
		direction = 0;
	    speed = 0;
	    vspeed = 0;
	    hspeed = 0;

	    if (follow.board && instance_exists(battle_board)) {
	        follow.target = battle_board;
	    }

	    if (instance_exists(follow.target)) {
	        center = Vector2(follow.target.x, follow.target.y);
	        follow.pos = Vector2(follow.target.x, follow.target.y);
	        if (variable_instance_exists(follow.target, "angle")) {
	            follow.config.angle = follow.target.angle;
	        } else {
	            follow.config.angle = follow.target.image_angle;
	        }
			NewBoardAngle = follow.config.angle
	    } else {
	        center = follow.pos;
	    }
	    follow.offset = Vector2(x - center.x, y - center.y);
    
	    processed = true;
	}

    follow.pos.x += follow.config.hspeed;
    follow.pos.y += follow.config.vspeed;
    
    if (follow.config.speed != 0) {
        x += lengthdir_x(follow.config.speed, follow.config.direction);
        y += lengthdir_y(follow.config.speed, follow.config.direction);
    }
    
    if (follow.board && instance_exists(battle_board) && follow.target != battle_board) {
        follow.target = battle_board;
	}
    
    var target_exists = instance_exists(follow.target);
    if (target_exists) {
        follow.pos = Vector2(follow.target.x, follow.target.y);
        
        if (variable_instance_exists(follow.target, "angle")) {
            follow.config.angle = follow.target.angle;
        } else {
            follow.config.angle = follow.target.image_angle;
        }
    }
    
    var rotated = RotAndPixelScale(follow.offset, follow.config.angle);

    x = follow.pos.x + rotated.x;
    y = follow.pos.y + rotated.y;
	if (follow.config.angle != NewBoardAngle) {
		image_angle -=  follow.config.angle - NewBoardAngle;
		NewBoardAngle = follow.config.angle;
	}
} else {
    follow.pos = Vector2(x, y);
	follow.angle = image_angle
    follow.config.vspeed = vspeed;
    follow.config.hspeed = hspeed;
    follow.config.speed = speed;
    follow.config.direction = direction;
	
    follow.offset = Vector2(x - center.x, y - center.y);
}