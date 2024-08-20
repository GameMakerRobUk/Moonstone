//GO TO NEXT ACTION (idle or queued)
if (image_index >= last_frame){
	state = next_action; //e_actor_states.idle;
	scr_update_sprite(state, actor_id, next_action_starting_index);
}