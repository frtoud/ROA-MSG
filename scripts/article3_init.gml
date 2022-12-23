//persistence init

//article standard variables
visible = true;
uses_shader = false;
sprite_index = asset_get("empty_sprite");
mask_index = asset_get("empty_sprite");
can_be_grounded = false;
ignores_walls = true;
through_platforms = true;

//Ori's compatibility
unbashable = true;

//=====================================================
//Persistent Data
achievement_hall_of_fame = false;
achievement_fatal_error = false;
achievement_saw_matrix = false;

//=====================================================
//article state
time_since_last_ran_script = noone; //time since last draw was run. if above a certain treshold, consider the character having been unloaded
prev_room = noone; //tracks previous room state to perform checks only when it changes

state = 0; //what is the current "room type" we are in (see enum)
//substate flags
is_online = false;
is_practice = false; //get_match_setting(SET_PRACTICE)
is_menu_broken = false; //true when visiting milestones menu
is_real_match = false; //only true if was previously in CSS


//draw helper
msg_unsafe_gpu_stack_level = 0; //tracks how many gpu_push_state were used to revert them if needed