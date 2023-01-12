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
    master.menu_is_broken = false;
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
    if (menu_is_broken)
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
        draw_sprite_ext(special_sprite_get("glitch_bg"), 0, 4*((current_time * current_time) % 16) ^ 0x17 - 120, 140, 40, 2, -7, c_white, 1);
   
    msg_gpu_clear();

    if !(state == PERS_MATCH || state == PERS_CSS)
        msg_draw_achievement(special_sprite_get("achievement"));
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

#macro PERS_CSS 3

#macro PERS_MATCH 5

#define msg_draw_achievement(spr) // Version 0
    if (achievement.end_time < current_time) return;
    //assumed called from the perspective of the master article holding the required information
    //bottom corner of screen: (960, 540)
    //size of achievement block: 240x94
    var popup_down = 540;
    var popup_up = popup_down - 94;
    var popup_x = 720;
    var popup_y = popup_up;

    //THX-UHC2
    if (current_time < achievement.rise_time)
    {
        popup_y = ease_linear(popup_down, popup_up,
                              current_time - achievement.start_time,
                              achievement.rise_time - achievement.start_time);
    }
    else if (current_time > achievement.fall_time)
    {
        popup_y = ease_linear(popup_up, popup_down,
                              achievement.fall_time - current_time,
                              achievement.fall_time - achievement.end_time);
    }

    draw_sprite(spr, achievement.id, popup_x, popup_y);
// DANGER: Write your code ABOVE the LIBRARY DEFINES AND MACROS header or it will be overwritten!
// #endregion