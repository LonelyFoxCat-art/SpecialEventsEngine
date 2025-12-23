var Left = RotAndPixelScale(-image_xscale+1, 0, -image_angle, 0);
var Right = RotAndPixelScale(image_xscale-1, 0, -image_angle, 0);

draw_sprite_ext(sprite_index, 0, x, y, image_xscale, 1, image_angle, image_blend, 1)
draw_sprite_ext(sprite_index, 1, x, y, image_xscale, 1, image_angle, c_white, 1)