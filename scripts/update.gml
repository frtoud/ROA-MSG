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
  