show_debug_message(" NEW GAME STARTING ");
show_debug_message("");
game_set_speed(60, gamespeed_fps);

enum e_actor_states{
	idle,
	walking,
	strike_light_1,
	strike_light_2,
	strike_heavy_1,
	strike_heavy_2,
	block,
	block_break,
	block_impact,
	block_walk,
	hurt_back,
	hurt_front,
	parry,
	parry_block,
	parry_counter,
	roll_backward,
	roll_forward,
	roll_up,
	roll_down,
	run,
	run_stop,
	kick,
	death_pt1,
	death_pt2,
	death_pt3,
	death_finisher_1,
	getup_front,
	getup_back,
	knockback_front,
	knockback_back,
	last,
}
#region DEBUG TEXT
txt[0] = "idle";
txt[1] = "walk";
txt[2] = "light1";
txt[3] = "light2";
txt[4] = "heavy1";
txt[5] = "heavy2";
txt[6] = "block";
txt[7] = "block_break";
txt[8] = "block_impact";
txt[9] = "block_walk";
txt[10] = "hurt_back";
txt[11] = "hurt_front";
txt[12] = "parry";
txt[13] = "parry_block";
txt[14] = "parry_counter";
txt[15] = "roll_back";
txt[16] = "roll_forward";
txt[17] = "roll_up";
txt[18] = "roll_down";
txt[19] = "run";
txt[20] = "run_stop";
txt[21] = "kick";
txt[22] = "death_pt1";
txt[23] = "death_pt2";
txt[24] = "death_pt3";
txt[25] = "death_finisher_1";
txt[26] = "getup_front";
txt[27] = "getup_back";
txt[28] = "knockback_front";
txt[29] = "knockback_back";
#endregion

//Array will change speed to half for horizontal movement for Block + Walk
for (var i = 0; i < e_actor_states.last; i ++) global.speed_mod[i] = 1;
global.speed_mod[e_actor_states.block_walk] = 0.5;

enum e_actor_vars{
	h_speed,
	v_speed,
	last,
}

enum e_actors{ //Knights/Creatures etc
	knight1,
	last,
}

global.actor_vars = ds_grid_create(e_actor_vars.last, e_actors.last);

global.actor_vars[# e_actor_vars.h_speed, e_actors.knight1] = 1.5;
global.actor_vars[# e_actor_vars.v_speed, e_actors.knight1] = 0.7;

global.actor_vars_text[0] = "Hor Speed";
global.actor_vars_text[1] = "Ver Speed";

#region SPRITES

/*
	This is the order that the animation layering sheets are filled out in
	BODY
	WEAPON
	SHIELD
	HEAD
	WEAPON TRAIL
*/

enum e_anim_layer{
	start_if_queued,
	play_sound_now,
	last_frame_if_queued,
	can_queue_action_now,
	can_cancel_animation_now,
	body,
	weapon,
	shield,
	head,
	trail,
	last,
}

#region LOAD DEPTH FILES

global.depth_[e_actor_states.idle] = load_csv("idle_1.csv");
global.depth_[e_actor_states.walking] = load_csv("walk_1.csv");
global.depth_[e_actor_states.strike_light_1] = load_csv("light_attack_1.csv");
global.depth_[e_actor_states.strike_light_2] = load_csv("light_attack_2.csv");
global.depth_[e_actor_states.strike_heavy_1] = load_csv("heavy_attack_1.csv");
global.depth_[e_actor_states.strike_heavy_2] = load_csv("heavy_attack_2.csv");
global.depth_[e_actor_states.block] = load_csv("block.csv");
global.depth_[e_actor_states.block_break] = load_csv("block_break.csv");
global.depth_[e_actor_states.block_impact] = load_csv("block_impact.csv");
global.depth_[e_actor_states.block_walk] = load_csv("block_walk.csv");
global.depth_[e_actor_states.kick] = load_csv("kick.csv");
global.depth_[e_actor_states.death_pt1] = load_csv("death_pt1.csv");
global.depth_[e_actor_states.death_pt2] = load_csv("death_pt2.csv");
global.depth_[e_actor_states.death_pt3] = load_csv("death_pt3.csv");
global.depth_[e_actor_states.death_finisher_1] = load_csv("death_finisher_1.csv");
global.depth_[e_actor_states.hurt_back] = load_csv("hurt_back.csv");
global.depth_[e_actor_states.hurt_front] = load_csv("hurt_front.csv");
global.depth_[e_actor_states.knockback_back] = load_csv("knockback_back.csv");
global.depth_[e_actor_states.knockback_front] = load_csv("knockback_front.csv");
global.depth_[e_actor_states.getup_back] = load_csv("getup_back.csv");
global.depth_[e_actor_states.getup_front] = load_csv("getup_front.csv");
global.depth_[e_actor_states.parry] = load_csv("parry.csv");
global.depth_[e_actor_states.parry_block] = load_csv("parry_block.csv");
global.depth_[e_actor_states.parry_counter] = load_csv("parry_counter.csv");
global.depth_[e_actor_states.roll_backward] = load_csv("roll_backward.csv");
global.depth_[e_actor_states.roll_down] = load_csv("roll_down.csv");
global.depth_[e_actor_states.roll_forward] = load_csv("roll_forward.csv");
global.depth_[e_actor_states.roll_up] = load_csv("roll_up.csv");
global.depth_[e_actor_states.run] = load_csv("run.csv");
global.depth_[e_actor_states.run_stop] = load_csv("run_stop.csv");

//DEBUG
for (var i = 0; i < array_length_1d(global.depth_); i ++){
	var grid = global.depth_[i];
	show_debug_message("[" + string(i) + "] width: " + string(ds_grid_width(grid)) );
	show_debug_message("[" + string(i) + "] height: " + string(ds_grid_height(grid)) );
	show_debug_message("");
}

#endregion

#region SETUP START_IF_QUEUED_FROM / LAST FRAME IF QUEUED

for (var i = 0; i < e_actor_states.last; i ++){
	global.start_if_queued_from[i] = 0;
	global.last_frame_if_queued[i] = ds_grid_height(global.depth_[i]) - 1;
	
	//Check the "start_if_queued_layer" for a "1"
	var grid_to_check = global.depth_[i];
	
	for (var j = 0; j < ds_grid_height(grid_to_check); j ++){
		//Store the frame that the action should start from as a queued/chained action
		if (grid_to_check[# e_anim_layer.start_if_queued, j] == 1) global.start_if_queued_from[i] = j;
		
		//Store the frame that is to be the last if another action has been queued
		if (grid_to_check[# e_anim_layer.last_frame_if_queued, j] == 1) global.last_frame_if_queued[i] = j;
	}
}

#endregion

anim_grid_knight_1 = ds_grid_create(e_anim_layer.last, e_actor_states.last);

//Clear array that holds sprites - the order that the sprites are in determines draw order
for (var st = 0; st < e_actor_states.last; st ++){
	for (var part = 0; part < e_anim_layer.last; part ++){
		anim_grid_knight_1[# part, st] = -1;
	}
}

#region SET ANIMATION GRIDS

//draw_sprite(global.a_anim[body, state], image_index, x, y);
anim_grid_knight_1[# e_anim_layer.body, e_actor_states.idle] = spr_idle_kn_1;
anim_grid_knight_1[# e_anim_layer.weapon, e_actor_states.idle] = spr_idle_kn_1_sword;

anim_grid_knight_1[# e_anim_layer.body, e_actor_states.walking] = spr_walk_kn_1;
anim_grid_knight_1[# e_anim_layer.weapon, e_actor_states.walking] = spr_walk_kn_1_sword;

anim_grid_knight_1[# e_anim_layer.body, e_actor_states.strike_light_1] = spr_strike_1_kn_1;
anim_grid_knight_1[# e_anim_layer.weapon, e_actor_states.strike_light_1] = spr_strike_1_kn_1_sword;
anim_grid_knight_1[# e_anim_layer.trail, e_actor_states.strike_light_1] = spr_strike_1_kn_1_trail;

anim_grid_knight_1[# e_anim_layer.body, e_actor_states.strike_light_2] = spr_strike_2_kn_1;
anim_grid_knight_1[# e_anim_layer.weapon, e_actor_states.strike_light_2] = spr_strike_2_kn_1_sword;
anim_grid_knight_1[# e_anim_layer.trail, e_actor_states.strike_light_2] = spr_strike_2_kn_1_trail;

anim_grid_knight_1[# e_anim_layer.body, e_actor_states.strike_heavy_1] = spr_strike_hvy_1_kn_1;
anim_grid_knight_1[# e_anim_layer.weapon, e_actor_states.strike_heavy_1] = spr_strike_hvy_1_kn_1_sword;
anim_grid_knight_1[# e_anim_layer.trail, e_actor_states.strike_heavy_1] = spr_strike_hvy_1_kn_1_trail;

anim_grid_knight_1[# e_anim_layer.body, e_actor_states.strike_heavy_2] = spr_strike_hvy_2_kn_1;
anim_grid_knight_1[# e_anim_layer.weapon, e_actor_states.strike_heavy_2] = spr_strike_hvy_2_kn_1_sword;
anim_grid_knight_1[# e_anim_layer.trail, e_actor_states.strike_heavy_2] = spr_strike_hvy_2_kn_1_trail;

anim_grid_knight_1[# e_anim_layer.body, e_actor_states.block] = spr_block_1_kn_1;
anim_grid_knight_1[# e_anim_layer.weapon, e_actor_states.block] = spr_block_1_kn_1_sword;

anim_grid_knight_1[# e_anim_layer.body, e_actor_states.block_walk] = spr_walk_block_1_kn_1;
anim_grid_knight_1[# e_anim_layer.weapon, e_actor_states.block_walk] = spr_walk_block_1_kn_1_sword;

anim_grid_knight_1[# e_anim_layer.body, e_actor_states.block_break] = spr_block_break_1_kn_1;
anim_grid_knight_1[# e_anim_layer.weapon, e_actor_states.block_break] = spr_block_break_1_kn_1_sword;

anim_grid_knight_1[# e_anim_layer.body, e_actor_states.block_impact] = spr_block_impact_1_kn_1;
anim_grid_knight_1[# e_anim_layer.weapon, e_actor_states.block_impact] = spr_block_impact_1_kn_1_sword;

anim_grid_knight_1[# e_anim_layer.body, e_actor_states.roll_backward] = spr_roll_back_1_kn_1;
anim_grid_knight_1[# e_anim_layer.weapon, e_actor_states.roll_backward] = spr_roll_back_1_kn_1_sword;

anim_grid_knight_1[# e_anim_layer.body, e_actor_states.roll_forward] = spr_roll_front_1_kn_1;
anim_grid_knight_1[# e_anim_layer.weapon, e_actor_states.roll_forward] = spr_roll_front_1_kn_1_sword;

anim_grid_knight_1[# e_anim_layer.body, e_actor_states.roll_up] = spr_roll_up_1_kn_1;
anim_grid_knight_1[# e_anim_layer.weapon, e_actor_states.roll_up] = spr_roll_up_1_kn_1_sword;

anim_grid_knight_1[# e_anim_layer.body, e_actor_states.roll_down] = spr_roll_down_1_kn_1;
anim_grid_knight_1[# e_anim_layer.weapon, e_actor_states.roll_down] = spr_roll_down_1_kn_1_sword;

anim_grid_knight_1[# e_anim_layer.body, e_actor_states.parry] = spr_parry_1_kn_1;
anim_grid_knight_1[# e_anim_layer.weapon, e_actor_states.parry] = spr_parry_1_kn_1_sword;

anim_grid_knight_1[# e_anim_layer.body, e_actor_states.parry_block] = spr_parry_block_1_kn_1;
anim_grid_knight_1[# e_anim_layer.weapon, e_actor_states.parry_block] = spr_parry_block_1_kn_1_sword;

anim_grid_knight_1[# e_anim_layer.body, e_actor_states.parry_counter] = spr_parry_counter_1_kn_1;
anim_grid_knight_1[# e_anim_layer.weapon, e_actor_states.parry_counter] = spr_parry_counter_1_kn_1_sword;
anim_grid_knight_1[# e_anim_layer.trail, e_actor_states.parry_counter] = spr_parry_counter_1_kn_1_trail;

anim_grid_knight_1[# e_anim_layer.body, e_actor_states.death_pt1] = spr_death_pt1_kn1;
anim_grid_knight_1[# e_anim_layer.weapon, e_actor_states.death_pt1] = spr_death_pt1_kn1_sword;

anim_grid_knight_1[# e_anim_layer.body, e_actor_states.death_pt2] = spr_death_pt2_kn1;
anim_grid_knight_1[# e_anim_layer.weapon, e_actor_states.death_pt2] = spr_death_pt2_kn1_sword;

anim_grid_knight_1[# e_anim_layer.body, e_actor_states.death_pt3] = spr_death_pt3_kn1;
anim_grid_knight_1[# e_anim_layer.weapon, e_actor_states.death_pt3] = spr_death_pt3_kn1_sword;

anim_grid_knight_1[# e_anim_layer.body, e_actor_states.death_finisher_1] = spr_finisher_kn1;
anim_grid_knight_1[# e_anim_layer.weapon, e_actor_states.death_finisher_1] = spr_finisher_kn1_sword;

anim_grid_knight_1[# e_anim_layer.body, e_actor_states.run] = spr_run_kn1;
anim_grid_knight_1[# e_anim_layer.weapon, e_actor_states.run] = spr_run_kn1_sword;

anim_grid_knight_1[# e_anim_layer.body, e_actor_states.run_stop] = spr_run_stop_kn1;
anim_grid_knight_1[# e_anim_layer.weapon, e_actor_states.run_stop] = spr_run_stop_kn1_sword;

anim_grid_knight_1[# e_anim_layer.body, e_actor_states.hurt_back] = spr_hurt_back_1_kn1;
anim_grid_knight_1[# e_anim_layer.weapon, e_actor_states.hurt_back] = spr_hurt_back_1_kn1_sword;

anim_grid_knight_1[# e_anim_layer.body, e_actor_states.hurt_front] = spr_hurt_front_1_kn1;
anim_grid_knight_1[# e_anim_layer.weapon, e_actor_states.hurt_front] = spr_hurt_front_1_kn1_sword;

anim_grid_knight_1[# e_anim_layer.body, e_actor_states.kick] = spr_kick_kn1;
anim_grid_knight_1[# e_anim_layer.weapon, e_actor_states.kick] = spr_kick_kn1_sword;

anim_grid_knight_1[# e_anim_layer.body, e_actor_states.getup_back] = spr_getup_back_kn1;
anim_grid_knight_1[# e_anim_layer.weapon, e_actor_states.getup_back] = spr_getup_back_kn1_sword;

anim_grid_knight_1[# e_anim_layer.body, e_actor_states.getup_front] = spr_getup_front_kn1;
anim_grid_knight_1[# e_anim_layer.weapon, e_actor_states.getup_front] = spr_getup_front_kn1_sword;

anim_grid_knight_1[# e_anim_layer.body, e_actor_states.knockback_back] = spr_knockback_back_kn1;
anim_grid_knight_1[# e_anim_layer.weapon, e_actor_states.knockback_back] = spr_knockback_back_kn1_sword;

anim_grid_knight_1[# e_anim_layer.body, e_actor_states.knockback_front] = spr_knockback_front_kn1;
anim_grid_knight_1[# e_anim_layer.weapon, e_actor_states.knockback_front] = spr_knockback_front_kn1_sword;

#endregion

global.actor_sprites_list = ds_list_create();

ds_list_add(global.actor_sprites_list, anim_grid_knight_1);

#endregion

#region ATTACKS

enum e_attack_stats{
	move_first_frame,
	move_last_frame,
	movement_per_step,
	hor_ver_both,
	animation_speed, //Speed of the animation (usually 1, 0.5 for block-walk etc)
	next_chained_attack_X,
	next_chained_attack_Y,
	last,
}
global.attacks = ds_grid_create(e_attack_stats.last, e_actor_states.last);

enum e_hor_ver_both{
	hor_only,
	ver_only,
	both,
}

//SET ALL STATES TO HAVE LIGHT 1 / HEAVY 1 ON THE X/Y BUTTONS AND MOVEMENT SPEED OF 0
for (var i = 0; i < e_actor_states.last; i ++){
	global.attacks[# e_attack_stats.move_first_frame, i] = 0;
	global.attacks[# e_attack_stats.move_last_frame, i] = sprite_get_number(anim_grid_knight_1[# e_anim_layer.body, i]) - 1;
	global.attacks[# e_attack_stats.movement_per_step, i] = 0;	
	global.attacks[# e_attack_stats.hor_ver_both, i] = e_hor_ver_both.both;
	global.attacks[# e_attack_stats.animation_speed, i] = 1;	
	global.attacks[# e_attack_stats.next_chained_attack_X, i] = e_actor_states.strike_light_1;
	global.attacks[# e_attack_stats.next_chained_attack_Y, i] = e_actor_states.strike_heavy_1;
}

global.attacks[# e_attack_stats.movement_per_step, e_actor_states.walking] = 1.5;
global.attacks[# e_attack_stats.movement_per_step, e_actor_states.block_walk] = 1;
global.attacks[# e_attack_stats.movement_per_step, e_actor_states.roll_backward] = 3;	
global.attacks[# e_attack_stats.movement_per_step, e_actor_states.roll_forward] = 3;
global.attacks[# e_attack_stats.movement_per_step, e_actor_states.roll_up] = 3;
global.attacks[# e_attack_stats.movement_per_step, e_actor_states.roll_down] = 3;
global.attacks[# e_attack_stats.hor_ver_both, e_actor_states.roll_backward] = e_hor_ver_both.hor_only;	
global.attacks[# e_attack_stats.hor_ver_both, e_actor_states.roll_forward] = e_hor_ver_both.hor_only;
global.attacks[# e_attack_stats.hor_ver_both, e_actor_states.roll_up] = e_hor_ver_both.ver_only;
global.attacks[# e_attack_stats.hor_ver_both, e_actor_states.roll_down] = e_hor_ver_both.ver_only;

global.attacks[# e_attack_stats.move_first_frame, e_actor_states.strike_light_1] = 5;
global.attacks[# e_attack_stats.move_last_frame, e_actor_states.strike_light_1] = 9;
global.attacks[# e_attack_stats.movement_per_step, e_actor_states.strike_light_1] = 0.3;
global.attacks[# e_attack_stats.next_chained_attack_X, e_actor_states.strike_light_1] = e_actor_states.strike_light_2;
global.attacks[# e_attack_stats.next_chained_attack_Y, e_actor_states.strike_light_1] = e_actor_states.strike_heavy_2;

global.attacks[# e_attack_stats.move_first_frame, e_actor_states.strike_light_2] = 0;
global.attacks[# e_attack_stats.move_last_frame, e_actor_states.strike_light_2] = 4;
global.attacks[# e_attack_stats.movement_per_step, e_actor_states.strike_light_2] = 0.3;
global.attacks[# e_attack_stats.next_chained_attack_X, e_actor_states.strike_light_2] = e_actor_states.strike_light_1;
global.attacks[# e_attack_stats.next_chained_attack_Y, e_actor_states.strike_light_2] = e_actor_states.strike_heavy_1;

global.attacks[# e_attack_stats.move_first_frame, e_actor_states.strike_heavy_1] = 7;
global.attacks[# e_attack_stats.move_last_frame, e_actor_states.strike_heavy_1] = 15;
global.attacks[# e_attack_stats.movement_per_step, e_actor_states.strike_heavy_1] = 1;
global.attacks[# e_attack_stats.next_chained_attack_X, e_actor_states.strike_heavy_1] = e_actor_states.strike_light_2;
global.attacks[# e_attack_stats.next_chained_attack_Y, e_actor_states.strike_heavy_1] = e_actor_states.strike_heavy_2;

global.attacks[# e_attack_stats.move_first_frame, e_actor_states.strike_heavy_2] = 0;
global.attacks[# e_attack_stats.move_last_frame, e_actor_states.strike_heavy_2] = 4;
global.attacks[# e_attack_stats.movement_per_step, e_actor_states.strike_heavy_2] = 1;
global.attacks[# e_attack_stats.next_chained_attack_X, e_actor_states.strike_heavy_2] = e_actor_states.strike_light_1;
global.attacks[# e_attack_stats.next_chained_attack_Y, e_actor_states.strike_heavy_2] = e_actor_states.strike_heavy_1;


global.attacks_text[e_attack_stats.move_first_frame] = "First Frame of Move";
global.attacks_text[e_attack_stats.move_last_frame] = "Last Frame of Move";
global.attacks_text[e_attack_stats.movement_per_step] = "Move per Step";

#endregion

#region MUSIC && SOUND

music = choose(mus_forest_1, mus_forest_2, mus_forest_3);

audio_play_sound(music, 1, true);

enum e_sfx{
	walk_dirt,
	swoosh,
}

#region STATES WITH NO SOUND

for (var i = 0; i < e_actor_states.last; i ++){
	global.sound_fx[i, 0] = -1;
}

#endregion

#region WALK SOUNDS
global.sound_fx[e_actor_states.walking, 0] = snd_walk_dirt_1;
global.sound_fx[e_actor_states.walking, 1] = snd_walk_dirt_2;
global.sound_fx[e_actor_states.walking, 2] = snd_walk_dirt_3;
global.sound_fx[e_actor_states.walking, 3] = snd_walk_dirt_4;
global.sound_fx[e_actor_states.walking, 4] = snd_walk_dirt_5;
global.sound_fx[e_actor_states.walking, 5] = snd_walk_dirt_6;
global.sound_fx[e_actor_states.walking, 6] = snd_walk_dirt_7;
global.sound_fx[e_actor_states.walking, 7] = snd_walk_dirt_8;
global.sound_fx[e_actor_states.walking, 8] = snd_walk_dirt_9;
global.sound_fx[e_actor_states.walking, 9] = snd_walk_dirt_10;
#endregion

#region ATTACK SOUNDS
for (var i = e_actor_states.strike_light_1; i <= e_actor_states.strike_heavy_2; i ++){
	global.sound_fx[i, 0] = snd_swoosh_1;
	global.sound_fx[i, 1] = snd_swoosh_2;
	global.sound_fx[i, 2] = snd_swoosh_3;
	global.sound_fx[i, 3] = snd_swoosh_4;
	global.sound_fx[i, 4] = snd_swoosh_5;
	global.sound_fx[i, 5] = snd_swoosh_6;
	global.sound_fx[i, 6] = snd_swoosh_7;
	global.sound_fx[i, 7] = snd_swoosh_8;
	global.sound_fx[i, 8] = snd_swoosh_9;
	global.sound_fx[i, 9] = snd_swoosh_10;
	global.sound_fx[i, 10] = snd_swoosh_11;
	global.sound_fx[i, 11] = snd_swoosh_12;
	global.sound_fx[i, 12] = snd_swoosh_13;
	global.sound_fx[i, 13] = snd_swoosh_14;
	global.sound_fx[i, 14] = snd_swoosh_15;
	global.sound_fx[i, 15] = snd_swoosh_16;
	global.sound_fx[i, 16] = snd_swoosh_17;
	global.sound_fx[i, 17] = snd_swoosh_18;
	global.sound_fx[i, 18] = snd_swoosh_19;
	global.sound_fx[i, 19] = snd_swoosh_20;
}
#endregion

#region ROLL SOUNDS
global.sound_fx[e_actor_states.roll_backward, 0] = snd_roll_4;
global.sound_fx[e_actor_states.roll_forward, 0] = snd_roll_4;
global.sound_fx[e_actor_states.roll_up, 0] = snd_roll_4;
global.sound_fx[e_actor_states.roll_down, 0] = snd_roll_4;

#endregion

#endregion

//DEBUG SOUND ARRAY

for (var i = 0; i < e_actor_states.last; i ++){
	var str = "";
	for (var j = 0; j < array_length_2d(global.sound_fx, i); j ++){
		str += string(global.sound_fx[i, j]) + " ";
	}
	show_debug_message(str);
}

#region DEBUG MENU

global.debug_state_text = load_csv("debug_state_text.csv");

global.debug_list_stats = ds_list_create();
global.debug_list_text = ds_list_create();
ds_list_add(global.debug_list_stats, global.actor_vars, global.attacks);
ds_list_add(global.debug_list_text, global.actor_vars_text, global.attacks_text);

#endregion

#region CONTROLLER DETECTION

global.controller_detected = false;

if (global.controller_detected == false && !gamepad_is_connected(0) ){
	
	with obj_notification instance_destroy();
	
	var text = "No Gamepad Detected";
	notification = instance_create_depth(0,0,0,obj_notification);
	notification.text = text;
}

gamepad_index = -2;

global.HELD_U = false;
global.HELD_D = false;
global.HELD_L = false;
global.HELD_R = false;

global.PRESSED_U = true;
global.PRESSED_D = true;
global.PRESSED_L = true;
global.PRESSED_R = true;

global.RELEASED_U = true;
global.RELEASED_D = true;
global.RELEASED_L = true;
global.RELEASED_R = true;


#endregion

show_debug_message("Main create event complete");

slow_down = false;
global.gp_axislv_sensitivity = 0.5;