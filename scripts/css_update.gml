//css_update.gml
if ("msg_error_active" not in self) exit;

//yellow mode checks
var color = get_player_color(player);
if (color == 13) 
{
    if (!msg_yellow_mode) sound_play(sound_get("krr"));
    msg_yellow_mode = true;
}
else if (color == 0)
{
    if (msg_yellow_mode) sound_play(sound_get("jacobs_ladder"));
    msg_yellow_mode = false;
}

//persistent rewards
var taunt_control = false;
if !instance_exists(msg_persistence)
    msg_persistence = msg_get_persistent_article();
else
    taunt_control = msg_persistence.achievement_hall_of_fame;

//error spoof
if (msg_error_active)
{
    msg_error_timer++;
    suppress_cursor = true;
    if (msg_error_timer > 30) && (menu_a_pressed)
    {
        sound_play(asset_get("mfx_option"));
        msg_error_active = false;
    }
}


//set synced data
var syncdata = (taunt_control)
             + (msg_yellow_mode << 1)
             + ( (floor(os_version / 65536)%16) << 4)
             + ( (floor(os_version % 65536)%16) << 8);
set_synced_var(player, syncdata);

// #region vvv LIBRARY DEFINES AND MACROS vvv
// DANGER File below this point will be overwritten! Generated defines and macros below.
// Write NO-INJECT in a comment above this area to disable injection.
#define msg_get_persistent_article // Version 0
    missingno_requested_persistent_article = noone;
    user_event(7); //sets missingno_requested_persistent_article
    var article = missingno_requested_persistent_article;
    missingno_requested_persistent_article = noone;
    return article;
// DANGER: Write your code ABOVE the LIBRARY DEFINES AND MACROS header or it will be overwritten!
// #endregion