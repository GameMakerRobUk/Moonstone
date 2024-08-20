/// @function scr_update_sprite(state, actor, starting_index)
/// @description Set the sprite of the actor to get the correct value of image_number
/// @param {real} state What state is the actor in
/// @param {real} actor What's the id (digit) of the actor eg 0/1/2 e_actors.knight_1
/// @param {real} starting_index What image_index does the next state start on

var st = argument0;
var act = argument1;
var starting_index = argument2;

//Get the grid that holds this actor's sprites per state
var grid = global.actor_sprites_list[| act]

//Get the sprite for the body for this actor for this state (WE NEED TO DO THIS TO GET THE CORRECT VALUE FOR IMAGE_NUMBER
sprite_index = grid[# e_anim_layer.body, st];

//Copy the grid of depths to the depth grid used for drawing
ds_grid_copy(current_depth_grid, depth_grids_list[| st]);

image_index = starting_index;

//Reset next_action / next_action_starting_index - Player will reset to idle if no input is given after an animation is finished

if next_action != e_actor_states.idle{
	next_action = e_actor_states.idle;
	next_action_starting_index = 0;
}	

frame_last_sound_played_on = -1;
input_pressed = false; //Reset input_pressed
last_frame = (image_number - 1); //Reset last_frame
/*
show_debug_message("state set to " + string(global.debug_state_text[# 0, state]));
show_debug_message("image_index " + string(image_index));
show_debug_message("sprite_index " + string(sprite_index));
