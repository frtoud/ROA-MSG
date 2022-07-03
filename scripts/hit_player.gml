if (my_hitboxID.orig_player_id != self) exit; //Only our own hitboxes

//==========================================================
//Bubbles internal lockout logic (hopefully less heavy)
if (my_hitboxID.attack == AT_FSPECIAL_2)
{
    var victim_player = hit_player_obj.player;
    with (pHitBox) if (orig_player_id == other)
                   && (attack == AT_FSPECIAL_2)
    {
        can_hit[victim_player] = false;
    }
    msg_collective_bubble_lockout[victim_player] = msg_fspecial_bubble_lockout;
}

//==========================================================
// NAIR sfx
if (my_hitboxID.attack == AT_NAIR && my_hitboxID.hbox_num == 1)
{
    sound_stop(get_window_value(AT_NAIR, 1, AG_WINDOW_SFX));
}
//==========================================================
// USTRONG non-interruption of kb
if (my_hitboxID.attack == AT_USTRONG && my_hitboxID.hbox_num != 1)
{
    var coin = my_hitboxID;
    //signal for kb preservation
    if (coin.kb_value == 0) with (hit_player_obj)
    {
        if (!hitpause)
        {
            old_vsp = vsp;
            old_hsp = hsp;
            hitpause = true;
        }
        hitstop = max(coin.hitpause, hitstop);
        hitstop_full = max(coin.hitpause, hitstop_full);
        can_be_hit[coin.player] = coin.no_other_hit;
        sound_play(coin.sound_effect);
    }
}

//==========================================================
// FAIR variable damage
if (my_hitboxID.attack == AT_FAIR)
{
    var victim_dmg = get_player_damage(hit_player_obj.player);

    var bonus_dmg = floor(max(0, 8 - victim_dmg * (0.1)));
    take_damage(hit_player_obj.player, player, bonus_dmg);

    var min_knockback = 7;
    if (hit_player_obj.old_vsp > 0) 
    {
        hit_player_obj.orig_knock = min_knockback;
        hit_player_obj.old_vsp *= -1;
        hit_player_obj.old_hsp *= -1;
    }
    else if (hit_player_obj.orig_knock < min_knockback) hit_player_obj.orig_knock = min_knockback;
}

//==========================================================
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
            var expected_x = x + spr_dir * get_hitbox_value(AT_NTHROW, 1, HG_HITBOX_X);
            var expected_y = y + get_hitbox_value(AT_NTHROW, 1, HG_HITBOX_Y) + char_height/2;
            if (point_distance(expected_x, expected_y, hit_player_obj.x, hit_player_obj.y) > 20)
            {
                hit_player_obj.x = expected_x;
                hit_player_obj.y = expected_y;
            }
        }
    }
    else if (my_hitboxID.hbox_num == MSG_GRAB_LEECHSEED_HITBOX)
    {
        hit_player_obj.marked = true;
        hit_player_obj.marked_player = self.player;
        hit_player_obj.msg_leechseed_timer = 0;
        hit_player_obj.msg_leechseed_owner = self;

        hit_player_obj.msg_unsafe_effects.bad_vsync.gameplay_timer = 240;
        hit_player_obj.msg_unsafe_effects.bad_vsync.horz_max = 12;
        hit_player_obj.msg_unsafe_effects.bad_vsync.freq = 5;
    }
    else if (my_hitboxID.hbox_num == MSG_GRAB_NEGATIVE_HITBOX)
    {
        //turn damage into negatives (and amplify it)
        var dmg = abs(floor(get_player_damage(hit_player_obj.player) * msg_grab_negative_multiplier));
        set_player_damage(hit_player_obj.player, clamp(-dmg, -999, 999));
        hit_player_obj.msg_negative_dmg_timer = msg_grab_negative_duration;
    }
    else if (my_hitboxID.hbox_num == MSG_GRAB_FREEZE_HITBOX)
    {
        //turn damage into negatives (and amplify it)
        hit_player_obj.state_timer += 45;
    }
}

//==========================================================
//Become parent for glitch effect control
if (!hit_player_obj.msg_is_missingno)
{
    hit_player_obj.msg_unsafe_handler_id = self;
}