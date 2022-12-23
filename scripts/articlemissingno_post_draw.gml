// NOTE:
// Missingno article come in pairs.
// master handles update logic
// clone only exists at a different depth to let master do two draw passes
if (master != self)
{
    with (master) draw_front();
}
else draw_back();

if (master.time_since_last_ran_script + 5000) < current_time
{
    master.is_menu_broken = false;
    master.prev_room = noone;
}
master.time_since_last_ran_script = current_time;

//=========================================================
#define draw_back()
{
   //draw_sprite_tiled_ext(sprite_get("proj_pokeball"), 0, 0, 0, 1, 1, c_white, 1);
   //gpu_set_colorwriteenable(true, true, true, true);
   //gpu_set_blendenable(false);
   //gpu_set_alphatestenable(false);
    if (is_menu_broken)
    {
     msg_gpu_push_state();
     
     gpu_set_colorwriteenable(1, 0, 0, 0);
     draw_sprite_tiled_ext(special_sprite_get("glitch_bg"), 0, 0, 0, 2, 128, c_white, 1);
     gpu_set_colorwriteenable(1, 1, 1, 1);
     
     gpu_set_blendenable(false);
     gpu_set_alphatestenable(false);
    }
}
#define draw_front()
{
    
   if (room == asset_get("milestones_room"))
      draw_sprite_ext(special_sprite_get("glitch_bg"), 0, 4*((current_time * current_time) % 16) ^ 0x17 - 120, 140, 32, 2, -7, c_white, 1);
   
   msg_gpu_clear();
}

#define special_sprite_get(name)
{
    //resources folder is dependent on player
    var temp = player;
    player = orig_player;
    var ret = sprite_get(name);
    player = temp;
    return ret;
}

// #region vvv LIBRARY DEFINES AND MACROS vvv
// DANGER File below this point will be overwritten! Generated defines and macros below.
// Write NO-INJECT in a comment above this area to disable injection.
#define msg_gpu_push_state // Version 0
    gpu_push_state(); msg_unsafe_gpu_stack_level++;

#define msg_gpu_clear // Version 0
    while (msg_unsafe_gpu_stack_level > 0)
    {
        gpu_pop_state(); msg_unsafe_gpu_stack_level--;
    }
// DANGER: Write your code ABOVE the LIBRARY DEFINES AND MACROS header or it will be overwritten!
// #endregion