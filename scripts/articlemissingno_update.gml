// NOTE:
// Missingno article come in pairs.
// master handles update logic
// clone only exists at a different depth to let master do two draw passes
if (master != self) exit;

if (room != prev_room)
{
    change_state();
    prev_room = room;
}


master.depth = 50; //0000000000; //!? gives OK effects
clone.depth =  -18; //something happens with dust fx at depth 7

//suppress_stage_music(0, 1);

//print("NP="+string(instance_number(asset_get("oTestPlayer"))));

//cursed knowledge
//master.depth = 20000000000; //!?
//master.depth = 19000000000; //!? starts affecting HUDs more
//master.depth = 19000000; //!? gives OK effects
//clone.depth = 8; //something happens with dust fx at depth 7

//=============================================================================
//achievement unlocking
if (achievement_request_unlock_id >= 0)
&& (achievement_request_unlock_id < array_length(achievement_status))
{
    //animation parameters
    if !(achievement_status[achievement_request_unlock_id])
    {
        achievement_status[achievement_request_unlock_id] = true;
        achievement.id = achievement_request_unlock_id;
        achievement.start_time = current_time +   750;
        achievement.rise_time  = current_time +  1000;
        achievement.fall_time  = current_time +  6000;
        achievement.end_time   = current_time +  6250;
    }
    achievement_request_unlock_id = noone;
}
//achievement statii
achievement_fatal_error = achievement_status[0];
achievement_saw_matrix = achievement_status[1];
achievement_hall_of_fame = achievement_status[2];

//contingency
#macro IMPOSSIBLY_LONG_TIME 999999999999999999999999999999999999999999999
if instance_exists(msg_contingency_hitfx)
{
    for (var i = 0; i < array_length(achievement_status); i++)
        msg_contingency_hitfx.achievement_status[i] = achievement_status[i];
    //making data last "forever"
    msg_contingency_hitfx.pause = IMPOSSIBLY_LONG_TIME;
    msg_contingency_hitfx.hit_length = IMPOSSIBLY_LONG_TIME;
    msg_contingency_hitfx.pause_timer = 0;
    msg_contingency_hitfx.step_timer = 0;
    msg_contingency_hitfx.visible = false;
}
else with (oPlayer) //attempt creation
{
    other.msg_contingency_hitfx = spawn_hit_fx(-999, -999, 0);
    with (other.msg_contingency_hitfx)
    {
        missingno_persistence_contingency = true;
        persistent = true;
        visible = false;
        player = 0;
        achievement_status = [];
    }
}

//=============================================================================

//=============================================================================
//State machine
#define change_state()
{
    var P = instance_number(asset_get("oPlayer"));
    var NP = instance_number(asset_get("oTestPlayer"));
    var S = instance_number(asset_get("obj_stage_main"));
    var CSS = instance_number(asset_get("cs_playercursor_obj"));
    var SSS = instance_number(asset_get("ss_cursor_obj"));
    var R = instance_number(asset_get("draw_result_screen"));

    var new_state = PERS_UNKNOWN;
    if (room == asset_get("mainMenu_room"))        new_state = PERS_MENUS;
    else if (room == asset_get("milestones_room")) new_state = PERS_MILESTONES;
    else if (CSS > 0)                              new_state = PERS_CSS;
    else if (SSS > 0)                              new_state = PERS_SSS;
    else if (R > 0)                                new_state = PERS_RESULTS;
    // Yes, this is all just an elaborate P != NP joke
    else if (P > 0) && (P != NP)                   new_state = PERS_MATCH;
    //DEFAULTS TO: Unknown

    //exit action
    switch (state)
    {
        default: break;
    }

    state = new_state;

    //enter action
    switch (new_state)
    {
        case PERS_MILESTONES:
            menu_is_broken = true;
            achievement_request_unlock_id = 2;
            break;
        case PERS_MENUS:
            is_real_match = false;
            break;
        case PERS_CSS:
            is_real_match = true;
            break;
        case PERS_MATCH:
            menu_is_broken = false;
            is_online = get_player_hud_color(0) != 0;
            is_practice = get_match_setting(SET_PRACTICE);
            msg_coinhits = 0;
            break;
        case PERS_RESULTS:
            with (asset_get("draw_result_screen"))
                coins_earned += 50 * other.msg_coinhits;
            break;

        default: break;
    }

}

#define depth_control()
if (string_pos("*", keyboard_string) > 0)
{
    depth++;
}
if (string_pos("/", keyboard_string) > 0)
{
    depth--;
}
var delta_depth = string_count("+", keyboard_string) 
                - string_count("-", keyboard_string);
if (delta_depth != 0) 
{
    clone.depth += delta_depth;
}
keyboard_string = "";
print("m:" + string(depth ) + " c:" + string(clone.depth ));

// #region vvv LIBRARY DEFINES AND MACROS vvv
// DANGER File below this point will be overwritten! Generated defines and macros below.
// Write NO-INJECT in a comment above this area to disable injection.
#macro PERS_UNKNOWN 0

#macro PERS_MENUS 1

#macro PERS_MILESTONES 2

#macro PERS_CSS 3

#macro PERS_SSS 4

#macro PERS_MATCH 5

#macro PERS_RESULTS 6
// DANGER: Write your code ABOVE the LIBRARY DEFINES AND MACROS header or it will be overwritten!
// #endregion