draw_set_halign(fa_left);
draw_set_valign(fa_top);
//draw_text(0, 0, "sensitivity: " + string(global.gp_axislv_sensitivity) );

draw_text(0, 0, "state / next_action: " + string(state) + " / " + string(next_action) );
draw_text(0, 20, "hsp / vsp: " + string(hsp) + " / " + string(vsp));
draw_text(0, 40, "last_hsp / last_vsp: " + string(last_hsp) + " / " + string(last_vsp) );
draw_text(0, 60, "move_first_frame: " + string(global.attacks[# e_attack_stats.move_first_frame, state]) );
draw_text(0, 80, "move_last_frame: " + string(global.attacks[# e_attack_stats.move_last_frame, state]) );
draw_text(0, 100, "image_index: " + string(image_index) );
/*
draw_text(0, 60, "sprite_index: " + string(sprite_index) );
draw_text(0, 80, "image_index: " + string(image_index) );
draw_text(0, 100, "last_frame / image_number: " + string(last_frame) + " / " + string(image_number) );
draw_text(0, 120, "image_speed: " + string(image_speed) );
draw_text(0, 140, "current_depth_grid: " + string(current_depth_grid) );
*/
//draw_text(0, 140, "move_first_frame: " + string(global.attacks[# e_attack_stats.move_first_frame, state]) );
//draw_text(0, 160, "move_last_frame: " + string(global.attacks[# e_attack_stats.move_last_frame, state]) );


draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_text(display_get_gui_width(), 0, "FPS / REAL: " + string(fps) + " / " + string(fps_real) );


//draw_text(0, 20, "image_index: " + string(image_index) );
/*
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var a_to_display_text = global.debug_list_text[| selected_grid];

for (var i = 0; i < array_length_1d(a_to_display_text); i ++){
	var draw_x = 0;
	var draw_y = (i * 20);
	
	var text = a_to_display_text[i];
	
	if (i == selected_stat) draw_set_colour(c_red) else draw_set_color(c_black);
	draw_text(draw_x, draw_y, text + ": " + string(grid_stats[# i, 0] ) );
}


*/

//DRAW "CAN CANCEL ANIMATION NOW"

for (var i = 0; i < ds_grid_height(current_depth_grid); i ++){
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	
	var draw_x = display_get_gui_width() / 2;
	var draw_y = (i * 20);
	var text = current_depth_grid[# e_anim_layer.play_sound_now, i];
	if (floor(image_index) == i) draw_set_colour(c_red) else draw_set_colour(c_black);
	draw_text(draw_x, draw_y, text);
}

draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_colour(c_white);
draw_text(display_get_gui_width() / 2, display_get_gui_height(), "Change state to [" + obj_main.txt[change_to_this_state] + "]");