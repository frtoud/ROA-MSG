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
        y += vsp * abs(vsp/3); msg_firstjump_timer++;
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
// BSPECIAL "Last move used" detection
var target_is_missingno = false;
var target_is_clone = false;
var target = noone;
with (oPlayer)
{
    if (state_timer == 1)
    && (state == PS_ATTACK_AIR || state == PS_ATTACK_GROUND)
    {
        var is_clone = (clone || custom_clone);
        var is_missingno = (url == other.url);
        if ( target == noone )
        || ( target_is_clone && !is_clone )
        || ( target_is_clone == is_clone  && !target_is_missingno && is_missingno)
        || ((target_is_clone == is_clone) && (target_is_missingno == is_missingno) 
            && (target.player > player))
        { 
            target = self;
            target_is_clone = is_clone;
            target_is_missingno = is_missingno;
        }
    }
}

if (target != noone) && !(target_is_missingno && target.attack == AT_DSPECIAL_2)
{
    //shortcut: if target is another missingno; consider yourself the target
    at_bspecial_last_move.target = (target_is_missingno ? self : target);
    at_bspecial_last_move.move = target.attack;
    at_bspecial_last_move.small_sprites = target.small_sprites;
}
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
            var interp_hb = create_hitbox(best_hitbox.attack, best_hitbox.hbox_num, x-30, y);
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
    }

}

//other_update
user_event(0);