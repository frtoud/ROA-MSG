if (my_hitboxID.orig_player_id != self) exit; //Only our own hitboxes

//==========================================================
// By FSTRONG charge-storage glitch's nature, every attack is 
// forced to become, functionally, a strong attack.
// Therefore; we need to apply the fix anyways (see article1_update)
// unless we want every hitbox we land to deal essentially no damage
if ("msg_last_known_damage" in hit_player_obj)
&& (hit_player_obj.msg_last_known_damage < 0)
&& (get_player_damage(hit_player_obj.player) == 0)
{
    var new_damage = hit_player_obj.msg_last_known_damage + my_hitboxID.damage;
    set_player_damage(hit_player_obj.player, new_damage);
    hit_player_obj.msg_last_known_damage = new_damage;
}
//==========================================================

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
// UTILT: airtech
if (my_hitboxID.attack == AT_UTILT && my_hitboxID.hbox_num == 2)
{
    msg_air_tech_active = true;
}
//==========================================================
// DSTRONG: save which side to activate yoyo from
if (my_hitboxID.attack == AT_DSTRONG && my_hitboxID.hbox_num <= 2)
{
    //1 is in front, 2 is in back
    msg_dstrong_yoyo.dir = spr_dir * (my_hitboxID.hbox_num == 1 ? 1 : -1);
    msg_dstrong_yoyo.x = my_hitboxID.x;
    msg_dstrong_yoyo.y = my_hitboxID.y;
}
else if (my_hitboxID.attack == AT_DSTRONG && my_hitboxID.hbox_num == 4)
{
    //1 is in front, 2 is in back
    msg_dstrong_sweetspot_hit = true;
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
        orig_knock = point_distance(0, 0, old_hsp, old_vsp);

        hitstop = max(coin.hitpause, hitstop);
        hitstop_full = max(coin.hitpause, hitstop_full);
        can_be_hit[coin.player] = coin.no_other_hit + hitstop;
        sound_play(coin.sound_effect);
    }
}

//==========================================================
// FAIR variable damage
if (my_hitboxID.attack == AT_FAIR)
{
    var victim_dmg = get_player_damage(hit_player_obj.player);

    var bonus_dmg = floor(clamp(14.5 - (victim_dmg * 0.12), 0, 19));
    take_damage(hit_player_obj.player, player, bonus_dmg);

    var min_knockback = 7;
    if (hit_player_obj.old_vsp > 0) 
    {
        hit_player_obj.orig_knock = min_knockback;
        hit_player_obj.old_vsp *= -1;
        hit_player_obj.old_hsp *= -1;
    }
    else if (hit_player_obj.orig_knock < min_knockback) hit_player_obj.orig_knock = min_knockback;

    //SFX
    if (victim_dmg < -80)   
    { sound_play(sound_get("aurorabeam")); msg_alt_sprite = get_attack_value(attack, AG_MSG_ALT_SPRITES)[0]; }
    else if (bonus_dmg > 5) sound_play(sound_get("confusion"));
    else                    sound_play(sound_get("cometpunch"));
}

//==========================================================
// UAIR stacking reset
if (my_hitboxID.attack == AT_UAIR)
{
    reset_hitbox_value(AT_UAIR, 1, HG_WIDTH);
    reset_hitbox_value(AT_UAIR, 1, HG_HEIGHT);
    reset_hitbox_value(AT_UAIR, 1, HG_DAMAGE);
    reset_window_value(AT_UAIR, 1, AG_WINDOW_LENGTH);
    reset_window_value(AT_UAIR, 1, AG_WINDOW_SFX_FRAME);
    reset_window_value(AT_UAIR, 1, AG_WINDOW_SFX);
}

//==========================================================
//Grab logic
if (my_hitboxID.attack == AT_NTHROW)
{
    hit_player_obj.msg_handler_id = self;

    if(my_hitboxID.hbox_num == 1)
    {
        if !(hit_player_obj.msg_grab_immune_timer > 0)
        {
            //grab success: send directly to window 4
            window = 4; window_timer = 0;
            hit_player_obj.msg_grabbed_timer = 5;
            hit_player_obj.hurt_img = 0x99;
            var expected_x = x + spr_dir * get_hitbox_value(AT_NTHROW, 1, HG_HITBOX_X);
            var expected_y = y + get_hitbox_value(AT_NTHROW, 1, HG_HITBOX_Y) + char_height/2;
            if (point_distance(expected_x, expected_y, hit_player_obj.x, hit_player_obj.y) > 50)
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
        var curr_damage = get_player_damage(hit_player_obj.player);
        if (curr_damage > 0)
        {
            var dmg = abs(floor(curr_damage * msg_grab_negative_multiplier));
            set_player_damage(hit_player_obj.player, clamp(-dmg, -999, 999));
        }
        hit_player_obj.msg_negative_dmg_timer = msg_grab_negative_duration;
    }
    else if (my_hitboxID.hbox_num == MSG_GRAB_FREEZE_HITBOX)
    {
        //Reduces freeze time
        hit_player_obj.state_timer += 45;
    }
    else if (my_hitboxID.hbox_num == MSG_GRAB_GLITCHTIME_HITBOX)
    {
        //apply Glitch Time
        hit_player_obj.msg_doubled_time_timer = msg_grab_glitchtime_duration;
        with (hit_player_obj)
        {
            msg_prev_status.x = x;
            msg_prev_status.y = y;
            msg_prev_status.hsp = hsp;
            msg_prev_status.vsp = vsp;
            msg_prev_status.state = state;
        }
    }
    else if (my_hitboxID.hbox_num == MSG_GRAB_VANISH_HITBOX)
    {
        if (!hit_player_obj.msg_is_local)
        {
            hit_player_obj.visible = false;
            hit_player_obj.msg_unsafe_invisible_timer = msg_grab_vanish_duration + hit_player_obj.player*30;
        }
    }
}

//==========================================================
//hit someone with the TMTRAINER
if (my_hitboxID.attack == AT_NSPECIAL && my_hitboxID.hbox_num == 1)
{
    var hb = create_hitbox(my_hitboxID.attack, 2, my_hitboxID.x, my_hitboxID.y)
    hb.hsp = my_hitboxID.initial_hsp;
    hb.vsp = my_hitboxID.initial_vsp;
    hb.missingno_copied_player_id = hit_player_obj;
    //consume existing clones
    destroy_copies(hit_player_obj);
}

//==========================================================
//Become parent for glitch effect control
if (!hit_player_obj.msg_is_missingno)
{
    hit_player_obj.msg_unsafe_handler_id = self;
}

//==========================================================
// destroy all current missingno-copies of a player
#define destroy_copies(target_client_id)
{
    with (obj_article2) if ("is_missingno_copy" in self)
                        && (client_id == target_client_id)
    {
        needs_to_die = true; //article consumed
    }
}