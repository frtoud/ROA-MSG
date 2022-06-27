//update.gml


//==============================================================
//First-jump physics
if (state == PS_JUMPSQUAT)
{
    msg_firstjump_timer = 0;
}
else if (free && djumps == 0)
     && (msg_firstjump_timer < msg_firstjump_timer_max)
{
    if (vsp < 0)
    {
        var capped_vsp = max(vsp, -jump_speed);
        y += capped_vsp * abs(capped_vsp/3.0); 
        msg_firstjump_timer++;
    }
    else //Reached peak or got hitstunned
    {
        msg_firstjump_timer = msg_firstjump_timer_max;
    }
    
}

//==============================================================
//crawling 
if (state == PS_CROUCH)
|| ((state == PS_ATTACK_AIR || state == PS_ATTACK_GROUND) && attack == AT_DTILT)
{
    //walk-crawl
    var speed_limit = max(abs(hsp), crawl_speed);
    hsp = clamp(hsp + (right_down - left_down) * (ground_friction + crawl_accel), 
               -speed_limit, speed_limit);
}
else if (state == PS_DASH_START) && down_down
{
    //dash-crawl
    if (right_down - left_down != 0) || (abs(hsp) > ground_friction)
    {
       state_timer = min(12, state_timer); //prevent transition to full PS_DASH

       var speed_limit = max(abs(hsp), dashcrawl_speed);
       hsp = clamp(hsp - (sign(hsp) * ground_friction) 
                       + (right_down - left_down) * (ground_friction + dashcrawl_accel),
                       -speed_limit, speed_limit);
    }
    hurtboxID.sprite_index = crouchbox_spr;
}


at_prev_dir_buffer = clamp(at_prev_dir_buffer + spr_dir, -6, 6);

//==============================================================
// BSPECIAL "Last move used" holding (previously detection)
var target_is_missingno = false;
var target_is_clone = false;

if (special_down && !at_prev_special_down)
{
    var counts_as_hitpause = (hitpause) 
                          || ( (state == PS_ATTACK_AIR || state == PS_ATTACK_GROUND)
                               && (attack == AT_NTHROW && window == 4) )
    var target = (counts_as_hitpause && hit_player_obj != noone) ? hit_player_obj : self;

    if (target.msg_is_missingno) target = self; //shortcut: copy self if copying a missingno

    msg_bspecial_last_move.target = (target_is_missingno ? self : target);
    msg_bspecial_last_move.move = target.attack;
    msg_bspecial_last_move.small_sprites = target.small_sprites;

    if (counts_as_hitpause) sound_play(sound_get("eden3"));
}
else if (!special_down && at_prev_special_down) 
     && (state_cat == SC_AIR_NEUTRAL || state_cat == SC_GROUND_NEUTRAL )
{
    if (msg_bspecial_last_move.target == self)
    {
        msg_bspecial_category_flag = (attack != AT_DSPECIAL_2);
        move_cooldown[msg_bspecial_last_move.move] = 0; //cannot prevent use, whatever move it is at the moment
        set_attack(msg_bspecial_last_move.move);

        if (attack == AT_DSPECIAL_2) sound_play(sound_get("eden2"));
    }
    else
    {
        steal_move_data(msg_bspecial_last_move.target, msg_bspecial_last_move.move, AT_DSPECIAL_2);
        set_attack(AT_DSPECIAL_2);

        sound_play(sound_get("eden2"));
    }
}
at_prev_special_down = special_down;

//==============================================================
// If this was true (from previous frame) and you were sent to hitstun, lose charge
if (msg_fspecial_is_charging)
{
    if (state_cat == SC_HITSTUN)
    { msg_fspecial_charge = 0; }
    else if (state == PS_WALL_JUMP) 
    {
        msg_fspecial_ghost_arrow_active = true;
        
        msg_unsafe_effects.bad_vsync.timer += 30;
        msg_unsafe_effects.bad_vsync.horz_max = 60;
    }
}
msg_fspecial_is_charging = (state == PS_ATTACK_AIR || state == PS_ATTACK_GROUND)
                            && ((attack == AT_FSPECIAL) && window < 3);

//bubble collective lockout update
for (var p = 0; p < array_length(msg_collective_bubble_lockout); p++)
{
    if (msg_collective_bubble_lockout[p] > 0)
    {
        msg_collective_bubble_lockout[p]--;
        if (msg_collective_bubble_lockout[p] == 0)
        {
            //reenable bubbles for target
            with (pHitBox) if (orig_player_id == other)
                           && (attack == AT_FSPECIAL_2)
            {
                can_hit[p] = true;
            }
        }
    }
}

//==============================================================
//passive charge glitch
if (msg_fstrong_interrupted_timer > 0)
{
    msg_fstrong_interrupted_timer++;
    strong_flashing = (msg_fstrong_interrupted_timer % 10 > 5);
}
//==============================================================
//stop tracking grab outcome selection if somehow no longer in grab
if  (msg_grab_selected_index != noone) &&
   (!(state == PS_ATTACK_GROUND || state == PS_ATTACK_AIR)
    || (attack != AT_NTHROW) || (window != 4))
{
    msg_grab_selected_index = noone;
    if (msg_grab_sfx != noone)
    {
        sound_stop(msg_grab_sfx);
    }
    msg_grab_selected_index = noone;
}
//==============================================================
//Leech Seed particle updates
for (var i = 0; i < msg_leechseed_particle_number; i++)
{
    var temp_part = msg_leechseed_particles[i];
    if (temp_part.timer > 0)
    {
        temp_part.timer--;
        if (temp_part.timer > 0)
        {
            //bezier curve math 
            //(1 - t) reversed because this counts down
            var norm_time = (1.0 * temp_part.timer)/msg_grab_leechseed_delay;
            var sq_time = norm_time * norm_time;
            var neg_sq_time = (1.0 - norm_time) * (1.0 - norm_time)

            temp_part.x = temp_part.mid_x 
                        + sq_time * (temp_part.source_x - temp_part.mid_x)
                        + neg_sq_time * (x - temp_part.mid_x);
            temp_part.y = temp_part.mid_y
                        + sq_time * (temp_part.source_y - temp_part.mid_y)
                        + neg_sq_time * (y - (char_height/2) - temp_part.mid_y);
        }
        else
        {
            take_damage(player, player, -1);
            sound_play(asset_get("mfx_hp"));
        }
    }
}
//==============================================================
// Explosion fakeout
if (msg_exploded_respawn)
{
    if (state == PS_RESPAWN)
    {
        //faster Respawn
        state_timer++;
    }
    else
    {
        // Non-invincible after an explosion respawn
        msg_exploded_respawn = false;
        invincible = false;
        invince_time = 0;
    }
}

//==============================================================
//Yoyo detection
if (msg_dstrong_yoyo.active)
{
    var best_hitbox = noone;
    with (pHitBox) if (type == 1 && orig_player_id == other)
    {
        if (best_hitbox == noone)
        || (best_hitbox.hit_priority < hit_priority)
        {
            best_hitbox = self;
        }
    }

    //interpolate
    if (best_hitbox != noone)
    {
        var distance = point_distance(msg_dstrong_yoyo.x, msg_dstrong_yoyo.y, 
                                      best_hitbox.x, best_hitbox.y);

        var relative_x = (msg_dstrong_yoyo.x - x);
        var relative_y = (msg_dstrong_yoyo.y - y);

        var steps = distance / 25;

        var is_group_minus = best_hitbox.hbox_group < 0;

        for (var i = 0; i < steps; i++)
        {
            var factor = i/steps;
            var interp_hb = create_hitbox(best_hitbox.attack, best_hitbox.hbox_num, floor(x-30), floor(y));
            interp_hb.length = 1;
            interp_hb.image_xscale = lerp(0.15, best_hitbox.image_xscale, factor);;
            interp_hb.image_yscale = lerp(0.15, best_hitbox.image_yscale, factor);;
            interp_hb.x_pos = lerp(relative_x, best_hitbox.x_pos, factor);
            interp_hb.y_pos = lerp(relative_y, best_hitbox.y_pos, factor);
            interp_hb.missingno_hitbox_is_copy_of = best_hitbox;
            interp_hb.missingno_hitbox_is_copy_for = noone;
            if (is_group_minus) interp_hb.hbox_group = 0;
        }
        
        msg_dstrong_yoyo.active = false;
        msg_dstrong_yoyo.visible = false;

        vfx_yoyo_snap.timer = 8;
        vfx_yoyo_snap.x = best_hitbox.x;
        vfx_yoyo_snap.y = best_hitbox.y;
        vfx_yoyo_snap.length = distance;
        vfx_yoyo_snap.angle = point_direction(best_hitbox.x, best_hitbox.y, 
                                             msg_dstrong_yoyo.x, msg_dstrong_yoyo.y);
    }

}

//========================================================
// wraparound glitch
if (msg_uspecial_wraparound)
{
    if (state == PS_RESPAWN || state == PS_DEAD)
    || (state_cat == PS_HITSTUN)
        msg_uspecial_wraparound = false;

    image_yscale = 0; //intangibility

    // 1-866-THX-SUPR
    var blastzone_t = get_stage_data(SD_TOP_BLASTZONE_Y);
    var blastzone_b = get_stage_data(SD_BOTTOM_BLASTZONE_Y);
    if (y + vsp > blastzone_b - 12)
    {
        y = blastzone_t; 
        vsp = 0;
        msg_uspecial_wraparound_require_pratfall = true;
        attack_end();
        sound_play(asset_get("sfx_genesis_tv_static"));
        msg_uspecial_wraparound = false;
    }
}
else if (image_yscale == 0) image_yscale = 1;

if (msg_uspecial_wraparound_require_pratfall)
&& !(state == PS_ATTACK_AIR || state == PS_ATTACK_GROUND)
{
    set_state(free ? PS_PRATFALL : PS_PRATLAND);
    msg_uspecial_wraparound_require_pratfall = false;
}

//other_update
user_event(0);


//========================================================
#define steal_move_data(target_id, target_move, destination_index)
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
        set_attack_value(destination_index, i, temp);
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
            set_window_value(destination_index, k, i, temp);
        }
    }
    set_num_hitboxes(destination_index, num_hitboxes);
    //Hitbox Indexes
    for (k = 1; k <= num_hitboxes; k++)
    {
        for (i = 0; i < 100; i++) 
        {
            with (target_id) { temp = get_hitbox_value(target_move, k, i); }
            if (i == HG_HITBOX_Y || i == HG_HITBOX_X) 
            { temp = clamp(temp, -500, 500) }
            set_hitbox_value(destination_index, k, i, temp);
        }
    }
    
    //allow all moves no matter the situation
    set_attack_value(destination_index, AG_CATEGORY, 2);
}