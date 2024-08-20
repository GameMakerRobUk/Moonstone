draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(0, 0, "sensitivity: " + string(global.gp_axislv_sensitivity) );
/*
draw_text(0, 0, "state: " + string(state) );
draw_text(0, 20, "hsp: " + string(hsp) );
draw_text(0, 40, "last_hsp: " + string(last_hsp) );
draw_text(0, 60, "sprite_index: " + string(sprite_index) );
draw_text(0, 80, "image_index: " + string(image_index) );
draw_text(0, 100, "image_number: " + string(image_number) );
draw_text(0, 120, "image_speed: " + string(image_speed) );
*/
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
