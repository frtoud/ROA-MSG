//Reapply damage from previous life
if (msg_exploded_damage != 0)
{
    take_damage( player, -1, msg_exploded_damage );
    msg_exploded_damage = 0;
}

//==========================================================
// attempt to apply the fix to negative damage premptively (see article1_update)
if (msg_last_known_damage < 0) && (get_player_damage(player) == 0)
{
    var new_damage = msg_last_known_damage + enemy_hitboxID.damage;
    set_player_damage(player, new_damage);
    msg_last_known_damage = new_damage;
}
//==========================================================

if (prev_state == PS_ATTACK_GROUND || prev_state == PS_ATTACK_AIR)
{
    if (attack == AT_FSTRONG && strong_charge > 0 && strong_charge < 60)
    {
        //interrupted: start charging passively >:]
        msg_fstrong_interrupted_timer = strong_charge;
    }
    else if (attack == AT_UTILT)
    {
        //hit on top half: trigger glitch
        if !collision_rectangle(x-15, y, x+15, y-80, enemy_hitboxID, true, true)
        {
            y -= 80;
            msg_air_tech_active = true;
        }
    }
}

//===================
// VFXing
hurt_img = GET_RNG(6, 0x0F);
if (hurt_img > msg_num_hurt_spr) hurt_img = 153;
if (GET_RNG(5, 0x01) == 1) 
{
    var g = noone;
    with (hit_player_obj) g = msg_get_garbage();
    msg_unsafe_garbage = g;
}
msg_unsafe_effects.shudder.impulse = floor(abs(hitstop_full));

// #region vvv LIBRARY DEFINES AND MACROS vvv
// DANGER File below this point will be overwritten! Generated defines and macros below.
// Write NO-INJECT in a comment above this area to disable injection.
#define msg_get_garbage // Version 0
    // create a garbage entry out of a sprite currently in use.
    {
        return { spr: sprite_index,
                 scale: small_sprites + 1,
                 width: abs(sprite_width),
                 height: sprite_height,
                 x_offset: abs(sprite_xoffset),
                 y_offset: sprite_yoffset
               }
    }

#define GET_RNG(offset, mask) // Version 0
    // ===========================================================
    // returns a random number from the seed by using the mask.
    // uses "msg_unsafe_random" implicitly.
    return (mask <= 0) ? 0
           :((msg_unsafe_random >> offset) & mask);
// DANGER: Write your code ABOVE the LIBRARY DEFINES AND MACROS header or it will be overwritten!
// #endregion