#region CAN QUEUE ACTIONS
	
//If an action can be queued
if (current_depth_grid[# floor(image_index), e_anim_layer.can_queue_action_now] == 1) || (current_depth_grid[# floor(image_index), e_anim_layer.can_cancel_animation_now] == 1){
	
	#region ATTACK
	
	if (global.PRESSED_X || global.PRESSED_Y){
		if global.PRESSED_X var but = e_attack_stats.next_chained_attack_X;
		if global.PRESSED_Y var but = e_attack_stats.next_chained_attack_Y;
			
		//Set next state to one of the attacks, based on current state
		next_action = global.attacks[# but, state];
	}
	
	#endregion
	
	#region SET NEXT_ACTION_STARTING_INDEX / LAST_FRAME
	
	if (global.PRESSED_X || global.PRESSED_Y || global.HELD_R_TRIG){
		//Queue/Chain action (will start on the "last" frame of the current action (last might be less than the number of sprites in the image)
		if (current_depth_grid[# floor(image_index), e_anim_layer.can_queue_action_now] == 1){
			next_action_starting_index = global.start_if_queued_from[next_action];
			last_frame = global.last_frame_if_queued[state];
		}
		//Cancel current action and start the next
		if (current_depth_grid[# floor(image_index), e_anim_layer.can_cancel_animation_now] == 1){
			next_action_starting_index = 0;
			last_frame = image_index;
		}
	}
	
	#endregion
	
}

#endregion