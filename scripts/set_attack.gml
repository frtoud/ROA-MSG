#macro AT_BSPECIAL AT_DSPECIAL_2

//temp. remap of inputs, attack kept separate
if (attack == AT_NSPECIAL) attack = AT_DSPECIAL; //TMTRAINER
else if (attack == AT_DSPECIAL) attack = AT_NTHROW; //grab
//todo: remap correctly

else if (attack == AT_JAB) attack = AT_FTILT; //NTILT
else if (attack == AT_DATTACK && down_down) attack = AT_DTILT;

//==========================================================
// BSPECIAL input
if (attack == AT_FSPECIAL && (spr_dir * at_prev_spr_dir < 0))
{
    attack = AT_BSPECIAL; //conversion
    spr_dir = sign(at_prev_spr_dir); //dont flip
    clear_button_buffer(PC_SPECIAL_PRESSED);
}

if (attack == AT_BSPECIAL)
{
    if (msg_bspecial_last_move.target == noone)
    {
        attack = at_prev_attack;
    }
    else if (msg_bspecial_last_move.target.msg_is_missingno)
    {
        attack = msg_bspecial_last_move.move;
        //...if not self; apply runes?
    }
    else
    {
        sound_play(sound_get("eden2"));
        steal_move_data(msg_bspecial_last_move.target, msg_bspecial_last_move.move);
    }

    move_cooldown[attack] = 0; //cannot prevent use of BSPEC, whatever it is at the moment
    set_attack_value(attack, AG_CATEGORY, 2); //Allowed at any time because of special input
    msg_is_bspecial = true;
}
else
{
    reset_attack_value(attack, AG_CATEGORY);
    msg_is_bspecial = false;
}

//if (attack == AT_TAUNT) msg_low_fps_mode = !msg_low_fps_mode;

//"morph" effect attacks
if (attack == AT_BSPECIAL)
|| (attack == AT_DSPECIAL)
{
    msg_unsafe_effects.quadrant.gameplay_timer = 1;
    msg_unsafe_effects.quadrant.freq = 1;
    msg_unsafe_effects.quadrant.impulse = 4;
    msg_unsafe_effects.shudder.impulse = 4;
}

if (attack == AT_USPECIAL) msg_firstjump_timer = msg_firstjump_timer_max; //fixes jump bug

#define steal_move_data(target_id, target_move)
{
    with (target_id)
    {
        var num_windows = get_attack_value(target_move, AG_NUM_WINDOWS);
        var num_hitboxes = get_num_hitboxes(target_move);
    }
    
    var k = 0; //windows and hitboxes
    var i = 0; //for indexes
    var temp = 0;
    
    //Move Indexes
    for (i = 0; i < 100; i++) 
    {
        with (target_id) { temp = get_attack_value(target_move, i); }
        set_attack_value(AT_DSPECIAL_2, i, temp);
    }
    //Window Indexes
    for (k = 1; k <= num_windows; k++)
    {
        for (i = 0; i < 100; i++) 
        {
            with (target_id) { temp = get_window_value(target_move, k, i); }
            //softlock prevention: no looping windows
            if (i == AG_WINDOW_TYPE) 
            { temp = temp == 9 ? 0 : (temp == 10 ? 8 : temp) }
            else if (i == AG_WINDOW_LENGTH) 
            { temp = clamp(temp, 0, 60) }
            set_window_value(AT_DSPECIAL_2, k, i, temp);
        }
    }
    set_num_hitboxes(AT_DSPECIAL_2, num_hitboxes);
    //Hitbox Indexes
    for (k = 1; k <= num_hitboxes; k++)
    {
        for (i = 0; i < 100; i++) 
        {
            with (target_id) { temp = get_hitbox_value(target_move, k, i); }
            if (i == HG_HITBOX_Y || i == HG_HITBOX_X) 
            { temp = clamp(temp, -500, 500) }
            set_hitbox_value(AT_DSPECIAL_2, k, i, temp);
        }
    }
    
    //allow all moves no matter the situation
    set_attack_value(AT_DSPECIAL_2, AG_CATEGORY, 2);
}