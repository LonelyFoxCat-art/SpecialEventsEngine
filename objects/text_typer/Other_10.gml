var _x = x, _y = y, _color = c_white, _angle = image_angle, _alpha = image_alpha, _font = 0,
_scale_x = 2, _scale_y = 2, _space_x = 1, _space_y = 1
var _image_index = 0, _image_speed = 0;
var font = 0;

if (is_method(OnUpdate)) OnUpdate(id, index, number)

// 绘制部分
for(var i = 1; i < number + 1; i ++) {
	var char = string_char_at(text[index], i)
	
	// 指令部分
	if (char == "{") {
        var command = "";
        i++;
        
        while (i <= string_length(text[index]) && string_char_at(text[index], i) != "}") {
            command += string_char_at(text[index], i);
            i++;
        }
        
        if (i > string_length(text[index])) continue;
        
        var cmd = string_split(command, " ");
        switch (cmd[0]) {
            case "color":
                if (array_length(cmd) >= 2) {
                    _color = make_color_rgb(cmd[1], cmd[2], cmd[3]);
                }
                break;
            
			case "cover":
				if (array_length(cmd) >= 2) {
					cover = bool(cmd[1])
				}
				break;
			
			case "alpha": 
				if (array_length(cmd) >= 2) {
					_alpha = real(clamp(cmd[1], 0, 1))
				}
				break;
			
            case "scale":
                if (array_length(cmd) >= 2) {
                    _scale_x = real(cmd[1]);
                    _scale_y = _scale_x;
                }
                if (array_length(cmd) >= 3) {
                    _scale_y = real(cmd[2]);
                }
                break;
                
            case "font":
                if (array_length(cmd) >= 2) {
                    if (is_real(cmd[1])) {
                        _font = real(cmd[1])
					}
                }
                break;
				
			case "sprite":
                if (array_length(cmd) >= 2) {
                    var spr = asset_get_index(cmd[1]);
                    if (sprite_exists(spr)) {
                        _image_index = (array_length(cmd) >= 3) ? clamp(real(cmd[2]), 0, sprite_get_number(spr)-1) : 0;
                        
                        var img_scale = (array_length(cmd) >= 4) ? real(cmd[3]) : 1;
                        var xoffset = (array_length(cmd) >= 5) ? real(cmd[4]) : 0;
                        var yoffset = (array_length(cmd) >= 6) ? real(cmd[5]) : 0;
                        var y_correction = -sprite_get_yoffset(spr) + string_height("A") * 0.8;
                        
                        draw_sprite_ext(spr, _image_index, _x + xoffset, _y + yoffset + y_correction, img_scale * _scale_x, img_scale * _scale_y, _angle, _color, _alpha);
                        _x += sprite_get_width(spr) * img_scale + 2;
                    }
                }
                break;
                
            case "anim": 
                if (array_length(cmd) >= 2) {
                    var spr = asset_get_index(cmd[1]);
                    if (sprite_exists(spr)) {
                        _image_speed = (array_length(cmd) >= 3) ? real(cmd[2]) : 1;
                        _image_index += _image_speed * current_time / 1000000;
                        _image_index = _image_index mod sprite_get_number(spr);
                        
                        var img_scale = (array_length(cmd) >= 4) ? real(cmd[3]) : 1;
                        var xoffset = (array_length(cmd) >= 5) ? real(cmd[4]) : 0;
                        var yoffset = (array_length(cmd) >= 6) ? real(cmd[5]) : 0;
                        var y_correction = -sprite_get_yoffset(spr) + string_height("A") * 0.8;
						
                        draw_sprite_ext(spr, floor(_image_index), _x + xoffset, _y + yoffset + y_correction, img_scale * _scale_x, img_scale * _scale_y, _angle, _color, _alpha);
                        _x += sprite_get_width(spr) * img_scale + 2;
                    }
                }
                break;
                
        }
        continue;
    }

	font = (ord(char) < 127 ? 0 : 1)
	draw_set_font(group_font[_font,0]);
	var H1=string_height(" ");
	draw_set_font(group_font[_font,font]);
	var H2=string_height(" ");
	var OFFSET=(H1-H2)/2*_scale_y;
	
	// 换行
	if (char == "&") {
		_x = x
		_y += ((string_height(" ")+group_font_space_y[_font]+_space_y)*group_font_scale_y[_font,0]*_scale_y);
		continue
	}

	draw_set_valign(fa_top)
	draw_set_halign(fa_left)
	draw_text_transformed_color(_x, _y + OFFSET, char, _scale_x, _scale_y, _angle, _color, _color, _color, _color, _alpha)
	_x += (string_width(char) + group_font_space_x[_font, font] + _space_x) * group_font_scale_x[_font,font] * _scale_x - 2;
}