// 计算部分
if (index < array_length(text) && number < string_length(text[index])) {
    if (!paused) {
		if (sleep > 0) {
		    sleep --;
		} else {
			if (frame > 0) {
			    frame --;
			} else {
				do{
					while((string_char_at(text[index], number) == "{" || string_char_at(text[index], number) == "}" || string_char_at(text[index], number) == "&") && ((sleep == 0 || skipping || instant) && !paused)) {
						while(string_char_at(text[index], number) == "{") {
							number ++
							var command = "";
        
					        while (number <= string_length(text[index]) && string_char_at(text[index], number) != "}") {
								command += string_char_at(text[index], number);
								number ++;
					        }
        
					        var cmd = string_split(command, " ");
					        switch (cmd[0]) {
								case "end":
				                    instance_destroy();
				                    break;
								
								case "sleep":
				                    if (!skipping && !instant) {
				                        sleep = real(cmd[1]);
				                    }
				                    break;
            
				                case "speed":
				                    velocity = real(cmd[1]);
				                    break;
				                case "next":
				                    index ++;
				                    number = 1;
				                    break;
                                
				                case "paused":
				                    paused = true;
				                    skipping = false;
				                    sleep = 0;
				                    frame = 0;
				                    break;
                            
				                case "instant":
				                    instant = bool(cmd[1]);
				                    break;
                            
				                case "skipping":
				                    skipping = bool(cmd[1]);
				                    break;
                            
				                case "skippable":
				                    skippable = bool(cmd[1]);
				                    break;
								case "depth":
									depth = real(cmd[1])
									break;
								case "sound":
					                sound = real(cmd[1])
									break
							}
						}
						number ++
					}
					if((sleep == 0 || skipping || instant) && !paused && number < string_length(text[index])) {
						frame = velocity
						number ++
						event_user(1)
					}
				}until(number > string_length(text[index]) - 1 || paused || (!skipping && !instant));
			}
		}
	}
}