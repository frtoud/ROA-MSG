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
//tracks how many gpu_push_state were used to revert them if needed
msg_unsafe_gpu_stack_level = 0;