#region ROLLING
			
if (global.HELD_B){
	if (hsp != 0 && global.HELD_L || global.HELD_R){
		if (last_hsp == hsp){
			//state = e_actor_states.roll_forward;
			next_action = e_actor_states.roll_forward;
		}else{
			//state = e_actor_states.roll_backward;
			next_action = e_actor_states.roll_backward;
		}
		//scr_update_sprite(state, actor_id, 0);
	}
	if (vsp != 0) && (global.HELD_U || global.HELD_D){
		//if (global.HELD_U) state = e_actor_states.roll_up;
		//if (global.HELD_D) state = e_actor_states.roll_down;
		//scr_update_sprite(state, actor_id, 0);
		if (global.HELD_U) next_action = e_actor_states.roll_up;
		if (global.HELD_D) next_action = e_actor_states.roll_down;
	}
	next_action_starting_index = 0;
	//next_action = e_actor_states.idle;
}
			
#endregion