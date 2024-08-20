#region GET INPUT

#region HELD U/D/L/R

if (keyboard_check(ord("W")) || gamepad_axis_value(gamepad_index, gp_axislv) < -global.gp_axislv_sensitivity ) || gamepad_button_check(gamepad_index, gp_padu){
	
	global.HELD_U = true;
	
	if (global.RELEASED_U){
		global.PRESSED_U = true;
		global.RELEASED_U = false;
	}
}else{
	global.HELD_U = false;	
}

if (keyboard_check(ord("S")) || gamepad_axis_value(gamepad_index, gp_axislv) > global.gp_axislv_sensitivity ) || gamepad_button_check(gamepad_index, gp_padd){
	
	global.HELD_D = true;
	
	if (global.RELEASED_D){
		global.PRESSED_D = true;
		global.RELEASED_D = false;
	}
}else{
	global.HELD_D = false;	
}

if (keyboard_check(ord("A")) || gamepad_axis_value(gamepad_index, gp_axislh) < -global.gp_axislv_sensitivity )  || gamepad_button_check(gamepad_index, gp_padl){
	
	global.HELD_L = true;
	
	if (global.RELEASED_L){
		global.PRESSED_L = true;
		global.RELEASED_L = false;
	}
}else{
	global.HELD_L = false;	
}

if (keyboard_check(ord("D")) || gamepad_axis_value(gamepad_index, gp_axislh) > global.gp_axislv_sensitivity )  || gamepad_button_check(gamepad_index, gp_padr){
	
	global.HELD_R = true;
	
	if (global.RELEASED_R){
		global.PRESSED_R = true;
		global.RELEASED_R = false;
	}
}else{
	global.HELD_R = false;	
}

#endregion

#region PRESSED DPAD U/D/L/R

if (keyboard_check_pressed(vk_up) || gamepad_button_check_pressed(gamepad_index, gp_padu)){
	
	global.PRESSED_DPAD_U = true;
}else{
	global.PRESSED_DPAD_U = false;	
}

if (keyboard_check_pressed(vk_down) || gamepad_button_check_pressed(gamepad_index, gp_padd)){
	
	global.PRESSED_DPAD_D = true;
}else{
	global.PRESSED_DPAD_D = false;	
}

if (keyboard_check_pressed(vk_left) || gamepad_button_check_pressed(gamepad_index, gp_padl)){
	
	global.PRESSED_DPAD_L = true;
}else{
	global.PRESSED_DPAD_L = false;	
}

if (keyboard_check_pressed(vk_right) || gamepad_button_check_pressed(gamepad_index, gp_padr)){
	
	global.PRESSED_DPAD_R = true;
}else{
	global.PRESSED_DPAD_R = false;	
}

#endregion

#region A  

if (keyboard_check_pressed(vk_space) || gamepad_button_check_pressed(gamepad_index, gp_face1) ){
		global.PRESSED_A = true;   
}else{
	global.PRESSED_A = false;	
}

if (keyboard_check_released(vk_space) || gamepad_button_check_released(gamepad_index, gp_face1)){
		global.RELEASED_A = true;   
}else{
	global.RELEASED_A = false;	
}

if (keyboard_check(vk_space) || gamepad_button_check(gamepad_index, gp_face1) ){
		global.HELD_A = true;   
}else{
	global.HELD_A = false;	
}

#endregion

#region B

if (keyboard_check_pressed(ord("1")) || gamepad_button_check_pressed(gamepad_index, gp_face2)){
		global.PRESSED_B = true;   
}else{
	global.PRESSED_B = false;	
}

if (keyboard_check_released(ord("1")) || gamepad_button_check_released(gamepad_index, gp_face2)){
		global.RELEASED_B = true;   
}else{
	global.RELEASED_B = false;	
}

if (keyboard_check(ord("1")) || gamepad_button_check(gamepad_index, gp_face2)){
		global.HELD_B = true;   
}else{
	global.HELD_B = false;	
}

#endregion

#region X

if (keyboard_check_pressed(ord("2")) || gamepad_button_check_pressed(gamepad_index, gp_face3)){
		global.PRESSED_X = true;   
}else{
	global.PRESSED_X = false;	
}

if (keyboard_check_released(ord("2")) || gamepad_button_check_released(gamepad_index, gp_face3)){
		global.RELEASED_X = true;   
}else{
	global.RELEASED_X = false;	
}

if (keyboard_check(ord("2")) || gamepad_button_check(gamepad_index, gp_face3)){
		global.HELD_X = true;   
}else{
	global.HELD_X = false;	
}

#endregion

#region Y

if (keyboard_check_pressed(ord("3")) || gamepad_button_check_pressed(gamepad_index, gp_face4)){
		global.PRESSED_Y = true;   
}else{
	global.PRESSED_Y = false;	
}

if (keyboard_check_released(ord("3")) || gamepad_button_check_released(gamepad_index, gp_face4)){
		global.RELEASED_Y= true;   
}else{
	global.RELEASED_Y = false;	
}

if (keyboard_check(ord("3")) || gamepad_button_check(gamepad_index, gp_face4)){
		global.HELD_Y = true;   
}else{
	global.HELD_Y = false;	
}

#endregion

#region START

if (gamepad_button_check_pressed(gamepad_index, gp_start)) ||
   (keyboard_check_pressed(vk_shift)){
	   global.PRESSED_START = true;
}else{
	global.PRESSED_START = false;	
}

#endregion

#region SELECT

if (gamepad_button_check_pressed(gamepad_index, gp_select)) ||
   (keyboard_check_pressed(vk_control)){
	   global.PRESSED_SELECT = true;
}else{
	global.PRESSED_SELECT = false;	
}

#endregion

#region L/R SHOULDER     

if (gamepad_button_check_pressed(gamepad_index, gp_shoulderl) || keyboard_check_pressed(vk_lshift)){
	global.PRESSED_L_SHOULDER = true;
}else{
	global.PRESSED_L_SHOULDER = false;
}

if (gamepad_button_check(gamepad_index, gp_shoulderl) || keyboard_check(vk_lshift)){
	global.HELD_L_SHOULDER = true;
}else{
	global.HELD_L_SHOULDER = false;
}

if (gamepad_button_check_pressed(gamepad_index, gp_shoulderr) || keyboard_check_pressed(ord("?"))){
	global.PRESSED_R_SHOULDER = true;
}else{
	global.PRESSED_R_SHOULDER = false;
}

#endregion

#region L/R TRIGGER
if (mouse_check_button_pressed(mb_left) || gamepad_button_check_pressed(gamepad_index, gp_shoulderrb) ){
		global.PRESSED_R_TRIG = true;   
}else{
	global.PRESSED_R_TRIG = false;	
}

if (mouse_check_button(mb_left) || gamepad_button_check(gamepad_index, gp_shoulderrb) ){
		global.HELD_R_TRIG = true;   
}else{
	global.HELD_R_TRIG = false;	
}

if (mouse_check_button_pressed(mb_right) || gamepad_button_check_pressed(gamepad_index, gp_shoulderlb) ){
		global.PRESSED_L_TRIG = true;   
}else{
	global.PRESSED_L_TRIG = false;	
}

if (mouse_check_button(mb_right) || gamepad_button_check(gamepad_index, gp_shoulderlb) ){
		global.HELD_L_TRIG = true;   
}else{
	global.HELD_L_TRIG = false;	
}
#endregion

#endregion

#region CHECK FOR CONTROLLER PLUGGED IN / UNPLUGGED

if (global.controller_detected == false){

	for (var i = 0; i < 8; i ++){

		if (gamepad_is_connected(i) ){
	
			with obj_notification instance_destroy();
	
			var text = "Gamepad Detected";
			notification = instance_create_depth(0,0,0,obj_notification);
			notification.text = text;
			global.controller_detected = true;
			gamepad_index = i;
			break;
		}

	}

}

if (global.controller_detected == true && !gamepad_is_connected(gamepad_index) ){
	
	with obj_notification instance_destroy();
	
	var text = "Gamepad Not Detected";
	notification = instance_create_depth(0,0,0,obj_notification);
	notification.text = text;
	global.controller_detected = false;
	gamepad_index = -2;
}

#endregion

#region SLOW DOWN/SPEED UP THE GAME

if (keyboard_check_pressed(vk_tab) ){
	slow_down = !slow_down;
	if (slow_down){
		for (var i = 0; i < 63; i ++){
			var current_speed = sprite_get_speed(i);
			sprite_set_speed(i, current_speed / 5, spritespeed_framespersecond);
		}
	}else{
		for (var i = 0; i < 63; i ++){
			var current_speed = sprite_get_speed(i);
			sprite_set_speed(i, current_speed * 5, spritespeed_framespersecond);
		}
	}
}

#endregion