/// @function scr_move_collision(hsp, vsp)
/// @description Move the actor
/// @param {real} hsp horizontal speed (-1, 0, 1)
/// @param {real} vsp vertical speed (-1, 0, 1)
var hsp = argument0;
var vsp = argument1;

//show_debug_message("");
//show_debug_message("scr_move_collision is running");
//show_debug_message("");
	
#region HORIZONTAL

if (global.attacks[# e_attack_stats.hor_ver_both, state] != e_hor_ver_both.ver_only ){

	if (hsp > 0) bbox_side = bbox_right;
	else bbox_side = bbox_left;

	//move_amount_x = (hsp * move_speed);
	move_amount_x = (hsp * global.attacks[# e_attack_stats.movement_per_step, state]);
	
	#region LAYERS
	
	var ground_data_top = tilemap_get_at_pixel(map_id, bbox_side + move_amount_x, bbox_top);
	var ground_data_bottom = tilemap_get_at_pixel(map_id, bbox_side + move_amount_x, bbox_bottom);
	
	#endregion

	ground_collision = (ground_data_bottom + ground_data_top);
	//show_debug_message("horizontal ground_collision: " + string(ground_collision));
	
	if (ground_collision > 0){
		x += move_amount_x;
	}else{
		
		repeat abs(move_amount_x){
			var ground_data_top = tilemap_get_at_pixel(map_id, bbox_side + sign(move_amount_x), bbox_top);
			var ground_data_bottom = tilemap_get_at_pixel(map_id, bbox_side + sign(move_amount_x), bbox_bottom);
		
			if (ground_collision > 0) x += sign(hsp); else hsp = 0;
		}
	}
	
}

#endregion

#region VERTICAL
	
if (global.attacks[# e_attack_stats.hor_ver_both, state] != e_hor_ver_both.hor_only ){
	
	if  (vsp > 0) bbox_side = bbox_bottom;
	else bbox_side = bbox_top;

	//move_amount_y = (vsp * move_speed);
	move_amount_y = (vsp * ( global.attacks[# e_attack_stats.movement_per_step, state] / 2));
	
	#region LAYERS
	
	var ground_data_left = tilemap_get_at_pixel(map_id, bbox_left, bbox_side + vsp);
	var ground_data_right = tilemap_get_at_pixel(map_id, bbox_right, bbox_side + vsp);
	
	#endregion

	ground_collision = (ground_data_left + ground_data_right);
	//show_debug_message("vertical ground_collision: " + string(ground_collision));
	
	if (ground_collision > 0){
		y += move_amount_y;
	}else{
		
		repeat abs(move_amount_y){
			var ground_data_left = tilemap_get_at_pixel(map_id, bbox_left, bbox_side + sign(vsp));
			var ground_data_right = tilemap_get_at_pixel(map_id, bbox_right, bbox_side + sign(vsp));
		
			if (ground_collision > 0) y += sign(vsp); else vsp = 0;
		}
	}

}

#endregion

/*
var hsp = argument0;
var vsp = argument1;
	
#region HORIZONTAL
	
if  (hsp > 0) bbox_side = bbox_right;
else bbox_side = bbox_left;

//move_amount_x = (hsp * move_speed);
move_amount_x = (hsp * global.actor_vars[# e_actor_vars.h_speed, e_actors.knight1]) * global.speed_mod[state];
	
#region LAYERS
	
var ground_data_top = tilemap_get_at_pixel(map_id, bbox_side + move_amount_x, bbox_top);
var ground_data_bottom = tilemap_get_at_pixel(map_id, bbox_side + move_amount_x, bbox_bottom);
	
#endregion

ground_collision = (ground_data_bottom + ground_data_top);
//show_debug_message("horizontal ground_collision: " + string(ground_collision));
	
if (ground_collision > 0){
	x += move_amount_x;
}else{
		
	repeat abs(move_amount_x){
		var ground_data_top = tilemap_get_at_pixel(map_id, bbox_side + sign(move_amount_x), bbox_top);
		var ground_data_bottom = tilemap_get_at_pixel(map_id, bbox_side + sign(move_amount_x), bbox_bottom);
		
		if (ground_collision > 0) x += sign(hsp); else hsp = 0;
	}
}

#endregion

#region VERTICAL
	
if  (vsp > 0) bbox_side = bbox_bottom;
else bbox_side = bbox_top;

//move_amount_y = (vsp * move_speed);
move_amount_y = (vsp * global.actor_vars[# e_actor_vars.v_speed, e_actors.knight1]);
	
#region LAYERS
	
var ground_data_left = tilemap_get_at_pixel(map_id, bbox_left, bbox_side + vsp);
var ground_data_right = tilemap_get_at_pixel(map_id, bbox_right, bbox_side + vsp);
	
#endregion

ground_collision = (ground_data_left + ground_data_right);
//show_debug_message("vertical ground_collision: " + string(ground_collision));
	
if (ground_collision > 0){
	y += move_amount_y;
}else{
		
	repeat abs(move_amount_y){
		var ground_data_left = tilemap_get_at_pixel(map_id, bbox_left, bbox_side + sign(vsp));
		var ground_data_right = tilemap_get_at_pixel(map_id, bbox_right, bbox_side + sign(vsp));
		
		if (ground_collision > 0) y += sign(vsp); else vsp = 0;
	}
}

#endregion