hsp = ( global.HELD_R - global.HELD_L );
vsp = ( global.HELD_D - global.HELD_U );
	
#region CAN QUEUE ACTIONS
	
//If an action can be queued

can_queue = current_depth_grid[# e_anim_layer.can_queue_action_now, floor(image_index)];
can_cancel = current_depth_grid[# e_anim_layer.can_cancel_animation_now, floor(image_index)];

if (can_queue != "" || can_cancel != "" ){
		
	if (hsp != 0 || vsp != 0){
		
		#region WALK / WALK BLOCK
		
		if (global.HELD_R_TRIG){
			next_action = e_actor_states.block_walk;	
		}else{
			if (global.HELD_B){
				if (vsp < 0) next_action = e_actor_states.roll_up;
				if (vsp > 0) next_action = e_actor_states.roll_down;
				if (hsp < 0) next_action = e_actor_states.roll_backward;
				if (hsp > 0) next_action = e_actor_states.roll_forward;
			}else next_action = e_actor_states.walking;
		}
			
		input_pressed = true;
		
		#endregion
		
	}else{
		if (global.HELD_R_TRIG){
			
			#region BLOCK
			
			next_action = e_actor_states.block;
			next_action_starting_index = 0;
			
			#endregion
			
		}else{
	
			if (global.PRESSED_X || global.PRESSED_Y){
				
				#region ATTACK
				
				if global.PRESSED_X var but = e_attack_stats.next_chained_attack_X;
				if global.PRESSED_Y var but = e_attack_stats.next_chained_attack_Y;
			
				//Set next state to one of the attacks, based on current state
				next_action = global.attacks[# but, state];
				input_pressed = true;
				
				#endregion
				
			}else{
			
				#region IDLE
				
				if (state = e_actor_states.walking){
					next_action = e_actor_states.idle;
					next_action_starting_index = 0;
					input_pressed = true;
				}
				
				#endregion
			
			}
	
		}
	}
	
	#region KICK
	
	if (global.PRESSED_L_TRIG){
		next_action = e_actor_states.kick;
		input_pressed = true;
	}
	
	#endregion
	
	#region IDLE
	
	#endregion
	
	#region SET NEXT_ACTION_STARTING_INDEX / LAST_FRAME
	
	if (input_pressed){
		//Queue/Chain action (will start on the "last" frame of the current action (last might be less than the number of sprites in the image)
		if (can_queue != "" ){
			show_debug_message("ACTION QUEUED")
			next_action_starting_index = global.start_if_queued_from[next_action];
			last_frame = global.last_frame_if_queued[state];
		}
		//Cancel current action and start the next
		if (can_cancel != "" && next_action != state){
			show_debug_message("ACTION CANCELLED AND QUEUED WILL NOW PLAY");
			//UPDATE LAST_HSP so that image_xscale is drawn correctly
			if (state != e_actor_states.block_walk && state != e_actor_states.roll_backward){
				if (hsp != 0) last_hsp = hsp;	
			}
			if (state == e_actor_states.walking && next_action == e_actor_states.block_walk) next_action_starting_index = image_index;
			else next_action_starting_index = 0;
			last_frame = image_index;
		}
	}
	
	#endregion
	
}

#endregion

#region SOUND FX

if (current_depth_grid[# e_anim_layer.play_sound_now, floor(image_index)] == 1){
	
	//show_debug_message("current_depth_grid: " + string(current_depth_grid));
	//show_debug_message("state: " + string(state));
	//show_debug_message("PLAY SOUND NOW");
	var frame_to_play_sound = floor(image_index);
	
	//IF CURRENT SOUND HAS FINISHED PLAYING, PLAY A NEW ONE
	if (frame_last_sound_played_on != frame_to_play_sound ){
		show_debug_message("playing sound on frame " + string(frame_to_play_sound) + " in state " + obj_main.txt[state]);
		var total_possible_sounds = array_length_2d(global.sound_fx, state) - 1;
		var rand_snd = irandom(total_possible_sounds);
		sound_to_play = global.sound_fx[state, rand_snd];
		audio_play_sound(sound_to_play, 1, false);
		frame_last_sound_played_on = frame_to_play_sound;
	}
}

//if (!audio_is_playing(sound_to_play) ) sound_to_play = -1;

#endregion

if (state == e_actor_states.block){
	if (image_index >= (image_number - 1) ){
		image_index = (image_number - 1); 
		//show_debug_message("image_index >= (image_number - 1)");
	}
}
	
#region GO TO NEXT ACTION (idle or queued)
	
if (image_index >= last_frame){																						
	show_debug_message("Changing Actor state to " + obj_main.txt[state]);
	state = next_action; //e_actor_states.idle;
		
	//UPDATE LAST_HSP so that image_xscale is drawn correctly
	//if (state != e_actor_states.block_walk && state != e_actor_states.roll_backward){
	//	if (hsp != 0) last_hsp = hsp;	
	//}
	scr_update_sprite(state, actor_id, next_action_starting_index);
}
	
#endregion

//UPDATE LAST_HSP so that image_xscale is drawn correctly
if (state != e_actor_states.block_walk && state != e_actor_states.roll_backward){
	if (hsp != 0) last_hsp = hsp;	
}

//MOVE
var first_frame_to_move = global.attacks[# e_attack_stats.move_first_frame, state];
var last_frame_to_move = global.attacks[# e_attack_stats.move_last_frame, state];
if (image_index >= first_frame_to_move && image_index <= last_frame_to_move) scr_move_collision(hsp, vsp);

//if (image_index == next_action_starting_index) next_action = e_actor_states.idle;

//DEBUG
if (keyboard_check_pressed(vk_left) ){
	if (change_to_this_state > 0) change_to_this_state --; else change_to_this_state = e_actor_states.last - 1;	
}
if (keyboard_check_pressed(vk_right) ){
	if (change_to_this_state + 1) < e_actor_states.last change_to_this_state ++;
	else change_to_this_state = 0;
}

if (keyboard_check_pressed(vk_enter) ){
	next_action = change_to_this_state;	
}

