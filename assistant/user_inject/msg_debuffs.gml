#define msg_common_init()
//initialize variables for debuffs and oddities
{
    msg_handler_id = noone;
    msg_grabbed_timer = 0;

    msg_grab_immune_timer = 0;

    // Leech Seed
    msg_leechseed_timer = 0;
    msg_leechseed_owner = noone; //if not noone, leech seed is active and heals THIS player.
    // Negative DMG
    msg_negative_dmg_timer = 0;
    //ACTUAL BUG: getting hit by <0 hitboxes (or uncharged strongs) while in negative damage resets % to zero
    //ACTUAL BUG: having negative damage causes TempestPeak Stage (Aether mode) to spontaneously crash
    msg_last_known_damage = 0;
    //Glitched double-time
    msg_doubled_time_timer = 0;
    msg_has_doubled_frame = false;
    msg_prev_status = { state:0, x:0, y:0, hsp:0, vsp:0 };

    msg_clone_microplatform = noone; //clone pseudoground
    msg_clone_tempswaptarget = noone; //where the true player must return after a special interaction
    msg_clone_last_attack_that_needed_offedge = noone;
}
