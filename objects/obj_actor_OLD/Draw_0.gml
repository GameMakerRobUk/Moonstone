//draw_self();
ds_priority_clear(draw_queue);
//Sort the draw order
for (var body_part = 0; body_part < e_anim_layer.last; body_part ++){
	
	//show_debug_message("body_part: " + string(body_part) + " " + string(anim_grid[# body_part, state]));	

	var spr = anim_grid[# body_part, state];
	var priority = current_depth_grid[# body_part, floor(image_index)];

	if (spr != -1) ds_priority_add(draw_queue, spr, priority);
	if (spr == undefined) show_debug_message("SPRITE IS UNDEFINED (inside Sort the draw order)");
}

//draw the sprites
while (ds_priority_size(draw_queue) > 0){
	var spr = ds_priority_delete_min(draw_queue);
	if (spr == undefined) show_debug_message("SPRITE IS UNDEFINED (inside draw the sprites)");
	draw_sprite_ext(spr, image_index, x, y, last_hsp, 1, 0, c_white, 1);
}

draw_set_colour(c_red);
draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);