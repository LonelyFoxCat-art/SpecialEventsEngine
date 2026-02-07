switch(template){
	case 0:
		dir=0;
		show_spike=true;
		wide_spike=true;
		up=20;
		down=65;
		left=0;
		right=190;
		break;
		
	case 1:
		dir=2;
		show_spike=true;
		wide_spike=true;
		up=20;
		down=65;
		left=190;
		right=0;
		break;
		
	case 2:
		dir=0;
		show_spike=true;
		wide_spike=false;
		up=42;
		down=42;
		left=0;
		right=65;
		break;
		
	case 3:
		dir=2;
		show_spike=true;
		wide_spike=false;
		up=42;
		down=42;
		left=65;
		right=0;
		break;
		
	case 4:
		dir=0;
		show_spike=false;
		wide_spike=false;
		up=2;
		down=2;
		left=24;
		right=24;
		text_offset_y=-6;
		break;
}

visible=true;
_inst.text[0]="{shadow 0}{color 0 0 0}{scale 1}{speed 2}{font 1}{depth -1100}"+text+"{paused}{end}";