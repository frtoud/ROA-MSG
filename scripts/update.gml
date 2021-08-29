//update.gml

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
//other_update.gml
with (oPlayer) if (msg_handler_id == other)
{
    //reset on death
    if (state == PS_RESPAWN)
    {
        msg_grab_immune_timer = 0;
        msg_grabbed_timer = 0;

        msg_negative_dmg_timer = 0;
    }
    
    //stay in hitpause while grabbed
    if (msg_grabbed_timer > 0)
    {
        msg_grabbed_timer--;
        hitpause = true;
        hitstop = max(hitstop, 3);
        hitstop_full++;
    }
    //post-grab immunity
    else if (msg_grab_immune_timer > 0)
    {
        msg_grab_immune_timer--;
    }

    //=========================================================
    var debuff_still_active = false;

    if (msg_leechseed_owner != noone)
    {
        if (poison > 0)
        {
            debuff_still_active = true;
            msg_leechseed_timer++;
            if (msg_leechseed_timer % (other.msg_grab_leechseed_duration/poison) == 0)
            {
                sound_play(asset_get("mfx_hp_spawn"));
                take_damage(player, other.player, 1);
                with (msg_leechseed_owner) create_leech_seed(other.x, other.y-(other.char_height/2));
            }
            if (msg_leechseed_timer >= other.msg_grab_leechseed_duration)
            {
                msg_leechseed_timer = 0;
                poison--;
            }
        }
        else
        {
            poison = 0;
            marked = false;
            msg_leechseed_timer = 0;
            msg_leechseed_owner = noone;
        }
    }

    if (msg_negative_dmg_timer > 0)
    {
        debuff_still_active = true;
        msg_negative_dmg_timer--;
        if (msg_negative_dmg_timer <= 0 && get_player_damage( player ) < 0)
        {
            //restore to positive
            var dmg = abs(floor(get_player_damage(player) / msg_handler_id.msg_grab_negative_multiplier));
            set_player_damage(player, dmg);
        }
    }

    //=========================================================
    //stop tracking if there's nothing left to track
    if (msg_grab_immune_timer == 0)
    && (msg_grabbed_timer == 0)
    && (!debuff_still_active)
    {
        msg_handler_id = noone;
    }
}

//==========================================
#define create_leech_seed(src_x, src_y)
{
    if ("msg_leechseed_particles" not in self) exit;
    var temp_part = msg_leechseed_particles[msg_leechseed_particle_pointer];
    msg_leechseed_particle_pointer = 
        (msg_leechseed_particle_pointer + 1) % msg_leechseed_particle_number;

    temp_part.timer = msg_grab_leechseed_delay;
    temp_part.x = src_x;
    temp_part.y = src_y;
    temp_part.source_x = src_x;
    temp_part.source_y = src_y;
    temp_part.mid_x = src_x - 150 + random_func(4, 300, true);
    temp_part.mid_y = src_y - 150 + random_func(5, 300, true);
}