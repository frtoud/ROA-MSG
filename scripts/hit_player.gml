if (my_hitboxID.orig_player_id != self) exit; //Only our own hitboxes

//Bubbles internal lockout logic (kind of heavy)
if (my_hitboxID.attack == AT_FSPECIAL_2)
{
    var victim_player = hit_player_obj.player;
    with (pHitBox) 
    if ("url" in orig_player_id && orig_player_id.url == other.url && attack == AT_FSPECIAL_2)
    {
        can_hit[victim_player] = -other.msg_fspecial_bubble_lockout;
    }
}

//Grab logic
if (my_hitboxID.attack == AT_NTHROW)
{
    if(my_hitboxID.hbox_num == 1)
    {
        if !(hit_player_obj.msg_grab_immune_timer > 0)
        {
            //grab success: send directly to window 4
            window = 4; window_timer = 0;
            hit_player_obj.msg_handler_id = self;
            hit_player_obj.msg_grabbed_timer = 5;
            hit_player_obj.hurt_img = 999;
        }
    }
    else if (my_hitboxID.hbox_num == MSG_GRAB_LEECHSEED_HITBOX)
    {
        hit_player_obj.marked = true;
        hit_player_obj.marked_player = self.player;
        hit_player_obj.poison = 4;
        hit_player_obj.msg_leechseed_timer = 0;
        hit_player_obj.msg_leechseed_owner = self;

        hit_player_obj.msg_unsafe_effects.bad_vsync.master_flag = true;
        hit_player_obj.msg_unsafe_effects.bad_vsync.horz_max = 12;
        hit_player_obj.msg_unsafe_effects.bad_vsync.freq = 5;
        hit_player_obj.msg_unsafe_effects.master_effect_timer = 240;
    }
}


//Become parent for glitch effect control
if (!hit_player_obj.msg_is_missingno)
{
    hit_player_obj.msg_unsafe_handler_id = self;
}