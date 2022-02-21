//other_update.gml

//oddity management -- any missingno detecting such parameters fixes it
with (oPlayer)
{
    //negative hitstun/hitpause
    if (hitstun < 0 || hitstun_full < 0)
    {
        hitstun = max(3, abs(hitstun));
        hitstun_full = max(3, abs(hitstun_full));
        if (state != PS_HITSTUN) set_state(PS_HITSTUN);
    }

    if (hitstop < 0 || hitstop_full < 0)
    {
        hitstop = clamp(abs(hitstop), 3, 20);
        hitstop_full = clamp(abs(hitstop_full), 3, 20);
        
        if (!hitpause)
        {
            hitpause = true;
            old_vsp = vsp;
            old_hsp = hsp;
        }
    }

}

//debuffs management -- only the "handler" missingno needs to manage it
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
        
        var curr_damage = get_player_damage(player);
        //Rivals Bug: certain attacks can snap the damage counter back to Zero
        //Detect those cases and (try) adjusting them
        if ( curr_damage == 0 && msg_last_known_damage < -10)
        {
            set_player_damage( player, msg_last_known_damage )
        }
        else msg_last_known_damage = curr_damage;
        
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