timer ++;

if (timer >= room_speed * 8) instance_destroy();

if (global.PRESSED_A || global.PRESSED_B || global.PRESSED_X || global.PRESSED_Y){
	instance_destroy();	
}