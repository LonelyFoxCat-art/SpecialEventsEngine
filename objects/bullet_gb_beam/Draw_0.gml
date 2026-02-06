var deviate = RotAndPixelScale(-sprite_get_width(sprite_index), 0, -image_angle)
draw_sprite_ext(sprite_index, 0, x + deviate.x, y + deviate.y, 1, image_yscale, image_angle, image_blend, image_alpha)
draw_self()