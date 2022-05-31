
if (attack == AT_FSPECIAL && (spr_dir*at_prev_dir_buffer < 0)) && false
{
    attack = AT_DSPECIAL_2;
    spr_dir = sign(at_prev_dir_buffer); //dont flip
    clear_button_buffer(PC_SPECIAL_PRESSED);
}

if (msg_bspecial_category_flag)
{
    //Allowed at any time because of special input
    set_attack_value(attack, AG_CATEGORY, 2);
    msg_bspecial_category_flag = false;
}
else
{
    reset_attack_value(attack, AG_CATEGORY);

    //temp. remap of inputs, attack kept separate
    if (attack == AT_NSPECIAL) attack = AT_DSPECIAL; //TMTRAINER
    else if (attack == AT_DSPECIAL) attack = AT_NTHROW; //grab
    //todo: remap correctly


    if (attack == AT_JAB) attack = AT_FTILT; //NTILT
    if (attack == AT_DATTACK && down_down) attack = AT_DTILT;
}


if (attack == AT_TAUNT) msg_low_fps_mode = !msg_low_fps_mode;





/*
if (attack == AT_DSPECIAL_2)
{
    if (msg_bspecial_last_move.target == self)
    {
        attack = msg_bspecial_last_move.move;
    }
    else
    {
        steal_move_data(msg_bspecial_last_move.target, msg_bspecial_last_move.move);
    }

    move_cooldown[attack] = 0; //cannot prevent use of BSPEC, whatever it is at the moment
}
else
{
}*/

/*else
{
    msg_bspecial_last_move.target = self;
    msg_bspecial_last_move.move = attack;
    msg_bspecial_last_move.small_sprites = small_sprites;
}*/


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