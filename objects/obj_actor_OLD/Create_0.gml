lay_id = layer_get_id("ground");
map_id = layer_tilemap_get_id(lay_id);

last_hsp = 1;
last_vsp = 1;

selected_stat = 0; //Which stat in the array
selected_grid = 0; //Which array is being displayed

grid_stats = ds_grid_create(1, 1);
grid_stats = global.debug_list_stats[| selected_grid];

ready_for_input = false;
button_timer = 0;

/*
	This is the order that the animation layering sheets are filled out in
	BODY
	WEAPON
	SHIELD
	HEAD
	WEAPON TRAIL
*/

depth_grids_list = ds_list_create();
/* ADD IN ORDER

global.depth_kick = load_csv("kick.csv");
global.depth_death_1 = load_csv("death_pt1.csv");
global.depth_death_2 = load_csv("death_pt2.csv");
global.depth_death_3 = load_csv("death_pt3.csv");
global.depth_death_finisher = load_csv("death_finisher.csv");
global.knockback_back = load_csv("knockback_back.csv");
global.knockback_front = load_csv("knockback_front.csv");
global.getup_back = load_csv("getup_back.csv");
global.getup_front = load_csv("getup_front.csv");

global.depth_run = load_csv("run.csv");
global.depth_run_stop = load_csv("run_stop.csv");
*/

//Add sprite grids to this actor's depth list
for (var i = 0; i < e_actor_states.last; i ++) ds_list_add(depth_grids_list, global.depth_[i]);
/*
ds_list_add(depth_grids_list, global.depth_idle, global.depth_walk, global.depth_light_attack_1, global.depth_light_attack_2, global.depth_heavy_attack_1, global.depth_heavy_attack_2,
global.depth_block, global.depth_block_break, global.depth_block_impact, global.depth_block_walk, global.depth_hurt_back, global.depth_hurt_front, global.depth_parry, 
global.depth_parry_block, global.depth_parry_counter, global.depth_roll_backward, global.depth_roll_forward, global.depth_roll_up, global.depth_roll_down);
*/
//The state of the actor will determine which of these grids is used

//This grid will store the depth draw order for each of the 5 body parts (BODY / WEAPON / SHIELD ETC)
current_depth_grid = ds_grid_create(1, 1);
//ds_grid_copy(current_depth_grid, depth_grids_list[| state]); 

//This queue draws each sprite in order (the order/priority depends on the values inside current_depth_grid)
draw_queue = ds_priority_create();

//Which actor type is this? e_actors.knight etcw
actor_id = 0;

//Instance grd that will store the sprites for each of the states the actor can be in
anim_grid = global.actor_sprites_list[| actor_id];
state = e_actor_states.idle;
next_action = e_actor_states.idle;
next_action_starting_index = 0;
sound_to_play = -1;
last_frame = sprite_get_number(sprite_index) - 1;

ds_grid_copy(current_depth_grid, depth_grids_list[| state]);