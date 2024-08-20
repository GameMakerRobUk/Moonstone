/*
	[x] - Light attack
	[y] - Hvy attack
	[RB] - Parry
	[RT] - Block
	[b] - Roll
	[LT] - Kick
	[RB] - Consumable
*/

if (state == e_actor_states.idle){
	
	#region IDLE

	next_action = e_actor_states.idle;
	next_action_starting_index = 0;
	
	hsp = ( global.HELD_R - global.HELD_L );
	vsp = ( global.HELD_D - global.HELD_U );
	
	scr_set_state_to_roll();
	
	if (hsp != 0) last_hsp = sign(hsp);
	if (vsp != 0) last_vsp = sign(vsp);
	
	//State may now have been set to rolling
	if (state == e_actor_states.idle){
	
		if (hsp != 0 || vsp != 0){
			state = e_actor_states.walking;
			scr_update_sprite(state, actor_id, 0);
		}
	
		#region SWING / BLOCK FROM IDLE
	
		if (global.PRESSED_X ){
			state = global.attacks[# e_attack_stats.next_chained_attack_X, state];
			scr_update_sprite(state, actor_id, 0);
		}else{
			if (global.PRESSED_Y){
				state = global.attacks[# e_attack_stats.next_chained_attack_Y, state];
				scr_update_sprite(state, actor_id, 0);
			}else{
				if (global.HELD_R_TRIG){
					state = e_actor_states.block;
					scr_update_sprite(state, e_actors.knight1, 0);
				}
			}
		}
	
		#endregion
	
	}
	
	#endregion

}

if (state == e_actor_states.walking){
	
	#region WALKING
	
	next_action = e_actor_states.idle;
	next_action_starting_index = 0;
	
	hsp = ( global.HELD_R - global.HELD_L );
	vsp = ( global.HELD_D - global.HELD_U );
	
	scr_set_state_to_roll();
	scr_set_state_to_walk_block();
	
	if (hsp != 0) last_hsp = sign(hsp);
	if (vsp != 0) last_vsp = sign(vsp);
	
	//State may now be rolling
	if (state == e_actor_states.walking){
	
		if (hsp != 0 || vsp != 0){
			
			scr_move_collision(hsp, vsp);	
			
		}else{
			state = e_actor_states.idle;
			scr_update_sprite(state, actor_id, 0);
		}
	
		#region PLAY SFX
	
		if (image_index == 1 || image_index == 6) audio_play_sound(global.sound_fx[irandom(9), e_sfx.walk_dirt], 1, false);
	
		#endregion
		
		scr_queue_cancel_actions();
		
		scr_go_to_next_action();
	
		/*
		#region SWING / BLOCK FROM WALKING
	
		if (global.PRESSED_X ){
			state = e_actor_states.strike_light_1;
			scr_update_sprite(state, actor_id, 0);
		}else{
			if (global.PRESSED_Y){
				state = e_actor_states.strike_heavy_1;
				scr_update_sprite(state, actor_id, 0);
			}else{	
				if (global.HELD_R_TRIG){
					state = e_actor_states.block_walk;
					scr_update_sprite(state, e_actors.knight1, image_index);
				}
			}
		}
	
		#endregion
		*/
	}
	
	#endregion
	
}

#region ATTACKS / STRIKES

if (state == e_actor_states.strike_light_1 || state == e_actor_states.strike_light_2 || state == e_actor_states.strike_heavy_1 || state == e_actor_states.strike_heavy_2){
	//var start_frame_queued = global.start_if_queued_from[state];
	var start_frame_move = global.attacks[# e_attack_stats.move_first_frame, state];
	var last_frame_move = global.attacks[# e_attack_stats.move_last_frame, state];
	var strike_move_per_step = global.attacks[# e_attack_stats.movement_per_step, state];
	
	//MOVE
	if (image_index >= start_frame_move && image_index <= last_frame_move) scr_move_collision(last_hsp * strike_move_per_step, 0);	
	
	//SOUND
	if (current_depth_grid[# floor(image_index), e_anim_layer.play_sound_now] == 1){
		if (sound_to_play != -1 || !audio_is_playing(sound_to_play = -1) ){
			var random_swoosh = irandom(19);
			sound_to_play = global.sound_fx[random_swoosh, e_sfx.swoosh]
			audio_play_sound(sound_to_play, 1, false);
		}
	}
	
	scr_queue_cancel_actions();
	
	scr_go_to_next_action();
}

#endregion

/*
if (state == e_actor_states.strike_light_1){
	#region LIGHT 1
	var start_frame  = global.attacks[# e_attack_stats.first_frame, e_attacks.light_slash_1];
	var last_frame = global.attacks[# e_attack_stats.last_frame, e_attacks.light_slash_1];
	var strike_move_per_step = global.attacks[# e_attack_stats.movement_per_step, e_attacks.light_slash_1];
	
	if (image_index >= start_frame && image_index <= last_frame){
		if (image_index = start_frame){
			var random_swoosh = irandom(19);
			audio_play_sound(global.sound_fx[random_swoosh, e_sfx.swoosh] , 1, false);
		}
		scr_move_collision(last_hsp * strike_move_per_step , 0);
		//show_debug_message("actor should be moving");
		//Check for next action
		if (global.PRESSED_X){
			next_action = e_actor_states.strike_light_2;
			//next_action_starting_index = 0;
			next_action_starting_index = scr_frame_to_start_if_queued(next_action);
		}
		if (global.PRESSED_Y){
			next_action = e_actor_states.strike_heavy_2;
			//next_action_starting_index = 5;
			next_action_starting_index = scr_frame_to_start_if_queued(next_action);
		}
	}

	if (image_index >= image_number - 1){
		state = next_action; //e_actor_states.idle;
		scr_update_sprite(state, actor_id, next_action_starting_index);
	}

	#endregion
}

if (state == e_actor_states.strike_light_2){
	#region LIGHT 2
	var start_frame  = global.attacks[# e_attack_stats.first_frame, e_attacks.light_slash_2];
	var last_frame = global.attacks[# e_attack_stats.last_frame, e_attacks.light_slash_2];
	var strike_move_per_step = global.attacks[# e_attack_stats.movement_per_step, e_attacks.light_slash_2];
	
	if (image_index >= start_frame && image_index <= last_frame){
		if (image_index == 3){
			var random_swoosh = irandom(19);
			audio_play_sound(global.sound_fx[random_swoosh, e_sfx.swoosh] , 1, false);
		}
		scr_move_collision(last_hsp * strike_move_per_step , 0);
		
		//Check for next action
		if (global.PRESSED_X){
			next_action = e_actor_states.strike_light_1;
			//next_action_starting_index = 2;
			next_action_starting_index = scr_frame_to_start_if_queued(next_action);
		}
		if (global.PRESSED_Y){
			next_action = e_actor_states.strike_heavy_1;
			//next_action_starting_index = 7;
			next_action_starting_index = scr_frame_to_start_if_queued(next_action);
		}
		//show_debug_message("actor should be moving");
	}

	if (image_index >= image_number - 1){
		state = next_action; //e_actor_states.idle;
		scr_update_sprite(state, actor_id, next_action_starting_index);
	}

	#endregion
}

if (state == e_actor_states.strike_heavy_1){
	#region HEAVY 1
	var start_frame  = global.attacks[# e_attack_stats.first_frame, e_attacks.heavy_slash_1];
	var last_frame = global.attacks[# e_attack_stats.last_frame, e_attacks.heavy_slash_1];
	var strike_move_per_step = global.attacks[# e_attack_stats.movement_per_step, e_attacks.heavy_slash_1];
	
	if (image_index >= start_frame && image_index <= last_frame){
		if (image_index == 7){
			var random_swoosh = irandom(19);
			audio_play_sound(global.sound_fx[random_swoosh, e_sfx.swoosh] , 1, false);
		}
		scr_move_collision(last_hsp * strike_move_per_step , 0);
		//show_debug_message("actor should be moving");
		
		//Check for next action
		if (global.PRESSED_X){
			next_action = e_actor_states.strike_light_2;
			//next_action_starting_index = 3;
			next_action_starting_index = scr_frame_to_start_if_queued(next_action);
		}
		if (global.PRESSED_Y){
			next_action = e_actor_states.strike_heavy_2;
			//next_action_starting_index = 5;
			next_action_starting_index = scr_frame_to_start_if_queued(next_action);
		}
	}

	if (image_index >= image_number - 1){
		state = next_action; //e_actor_states.idle;
		scr_update_sprite(state, actor_id, next_action_starting_index);
	}

	#endregion
}

if (state == e_actor_states.strike_heavy_2){
	#region HEAVY 2
	var start_frame  = global.attacks[# e_attack_stats.first_frame, e_attacks.heavy_slash_2];
	var last_frame = global.attacks[# e_attack_stats.last_frame, e_attacks.heavy_slash_2];
	var strike_move_per_step = global.attacks[# e_attack_stats.movement_per_step, e_attacks.heavy_slash_2];
	
	if (image_index >= start_frame && image_index <= last_frame){
		if (image_index == 5){
			var random_swoosh = irandom(19);
			audio_play_sound(global.sound_fx[random_swoosh, e_sfx.swoosh] , 1, false);
		}
		scr_move_collision(last_hsp * strike_move_per_step , 0);
		//show_debug_message("actor should be moving");
		
		//Check for next action
		if (global.PRESSED_X){
			next_action = e_actor_states.strike_light_1;
			//next_action_starting_index = 2;
			next_action_starting_index = scr_frame_to_start_if_queued(next_action);
		}
		if (global.PRESSED_Y){
			next_action = e_actor_states.strike_heavy_1;
			//next_action_starting_index = 6;
			next_action_starting_index = scr_frame_to_start_if_queued(next_action);
		}
	}

	if (image_index >= image_number - 1){
		state = next_action; //e_actor_states.idle;
		scr_update_sprite(state, actor_id, next_action_starting_index);
	}

	#endregion
}
*/
if (state == e_actor_states.roll_backward || state == e_actor_states.roll_forward){
	
	#region ROLL BACKWARDS/FORWARDS 
	
	if (image_index >= image_number - 1){
		if (state == e_actor_states.roll_backward){
			show_debug_message("b4 hsp: " + string(hsp));
			show_debug_message("b4 last_hsp: " + string(last_hsp));
			hsp = -hsp;
			//if (hsp != 0) last_hsp = hsp;
			last_hsp = -last_hsp;
			show_debug_message("After hsp: " + string(hsp));
			show_debug_message("After last_hsp: " + string(last_hsp));
		}
		//show_debug_message("Setting next action from roll_backward / roll_forward");
		//state = next_action; //e_actor_states.idle;
		state = e_actor_states.idle;
		scr_update_sprite(state, actor_id, 0);
		//scr_update_sprite(state, actor_id, next_action_starting_index);
	}else scr_move_collision(last_hsp * 3, 0);
	
	#endregion
	
}

if (state == e_actor_states.roll_up || state == e_actor_states.roll_down){
	#region ROLL UP/DOWN 
	
	if (image_index >= image_number - 1){
		//show_debug_message("up/down animation finished");
		state = next_action; //e_actor_states.idle;
		scr_update_sprite(state, actor_id, next_action_starting_index);
	}else scr_move_collision(0, last_vsp * 1.5);
	
	#endregion
}

if (state == e_actor_states.block_walk){
	
	if (hsp == 0 && vsp == 0){
		#region SWITCH TO IDLE/BLOCK IF NOT MOVING
		
		if (!global.HELD_R_TRIG){
			if (image_index > 0) image_index -= sprite_get_speed(sprite_index);
			if (image_index < 0) image_index = 0;
			if (image_index == 0) state = e_actor_states.idle;
			next_action_starting_index = 0;
		}else{
			state = e_actor_states.block;
			var spr = anim_grid[# e_anim_layer.body, state];
			next_action_starting_index = sprite_get_number(spr) - 1;
		}
		image_speed = 1;
		scr_update_sprite(state, e_actors.knight1, next_action_starting_index);
		
		#endregion
	}else{
		
		//If Walk + blocking, move normally
		hsp = global.HELD_R - global.HELD_L;
		vsp = global.HELD_D - global.HELD_U;
		scr_move_collision(hsp, vsp);
		
		if (last_hsp != hsp) image_speed = -0.5;
		else image_speed = 0.5;
		
		//Released block so go back to walk (but still move this step)
		if (!global.HELD_R_TRIG){
			image_speed = 1;
			//Moving whilst not holding R Trigger = go straight into walk animation
			state = e_actor_states.walking;
			scr_update_sprite(state, e_actors.knight1, 0);
		}
	}
}

if (state == e_actor_states.block){

	if (global.PRESSED_X ){
		state = e_actor_states.strike_light_1;
		scr_update_sprite(state, actor_id, 0);
	}else{
		if (global.PRESSED_Y){
			state = e_actor_states.strike_heavy_1;
			scr_update_sprite(state, actor_id, 0);
		}else{
	
			if (global.HELD_R_TRIG){
				//Pause on last image
				if (image_index >= (image_number - 1) ) image_index = (image_number - 1);
		
				#region CHECK FOR MOVEMENT
		
				hsp = global.HELD_R - global.HELD_L;
				vsp = global.HELD_D - global.HELD_U;
		
				if (hsp != 0 || vsp != 0){
					state = e_actor_states.block_walk;
					scr_update_sprite(state, e_actors.knight1, 0);
				}
		
				#endregion
		
			}else{
		
				#region RELEASING BLOCK
		
				//Drop down to first image
				if (image_index > 0) image_speed = -1; 
				else image_speed = 1;

				if (image_index <= 0 || global.HELD_A || global.HELD_B || global.HELD_D || global.HELD_L || global.HELD_L_SHOULDER || global.HELD_L_TRIG || global.HELD_R || global.HELD_R_TRIG || global.HELD_U || global.HELD_X || global.HELD_Y){
					show_debug_message("switching to idle");
					state = e_actor_states.idle;
					scr_update_sprite(state, e_actors.knight1, 0);
					image_speed = 1;
				}
		
				#endregion
		
			}
		
		}
	
	}
	
}

#region DEBUG

if (!ready_for_input){
	if (keyboard_check(vk_down) || keyboard_check(vk_up) || keyboard_check(vk_left) || keyboard_check(vk_right) ){
		button_timer ++;
		if (button_timer >= 5) ready_for_input = true;
	}
	if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(vk_up) || keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_right) ){
		button_timer = 0;
		ready_for_input = true;
	}
	if (keyboard_check_released(vk_down) || keyboard_check_released(vk_up) || keyboard_check_released(vk_left) || keyboard_check_released(vk_right) ){
		button_timer = 0;
	}
}

if (ready_for_input){

	if (keyboard_check_pressed(vk_up) ) global.gp_axislv_sensitivity -= 0.05;
	if (keyboard_check_pressed(vk_down) ) global.gp_axislv_sensitivity += 0.05;
	/*
	var a_to_display_text = global.debug_list_text[| selected_grid];

	if (!keyboard_check(vk_shift) ){

		if (keyboard_check(vk_up) ) selected_stat --;
		if (keyboard_check(vk_down) ) selected_stat ++;
		selected_stat = clamp (selected_stat , 0, array_length_1d(a_to_display_text) - 1);

		if (keyboard_check(vk_right) ){
			//a_to_display[selected_stat, 0] += 0.1;
			grid_stats[# selected_stat, 0] += 0.1;
			//show_debug_message("Increasing Stat: " + string(a_to_display[selected_stat, 0]));
		}
		if (keyboard_check(vk_left) ){
			grid_stats[# selected_stat, 0] -= 0.1;
			//show_debug_message("Decreasing Stat: " + string(a_to_display[selected_stat, 0]));
		}
		//show_debug_message("a_to_display[selected_stat, 0]: " + string(a_to_display[selected_stat, 0]));
		grid_stats[# selected_stat, 0] = clamp(grid_stats[# selected_stat, 0], 0, 100);
	}else{
		if (keyboard_check(vk_down) ){
			if (selected_grid + 1) < ds_list_size(global.debug_list_stats) selected_grid ++;
			else selected_grid = 0;
		}
		if (keyboard_check(vk_up) ){
			if (selected_grid > 0) selected_grid --;
			else selected_grid = ds_list_size(global.debug_list_stats) - 1;
		}
		if (keyboard_check(vk_down) || keyboard_check(vk_up)){
			grid_stats = global.debug_list_stats[| selected_grid];
			var a_to_display_text = global.debug_list_text[| selected_grid];
			selected_stat = 0;
		}
	}
	
	if (keyboard_check(vk_down) || keyboard_check(vk_up) || keyboard_check(vk_left) || keyboard_check(vk_right) ){
		ready_for_input = false;
		button_timer = 0;
	}
	
	*/

}

#endregion
