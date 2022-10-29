//post_draw.gml

//Restore drawing parameters
msg_copy_params(msg_anim_backup, self, msg_anim_backup);

//Prevents screen from being pitch-black and not printing any error message. also prevents a crash.
msg_gpu_clear();

if (msg_dstrong_yoyo.active && msg_dstrong_yoyo.visible)
{
    draw_sprite_ext(sprite_get("dstrong"), 1, msg_dstrong_yoyo.x, msg_dstrong_yoyo.y, 2, 2, 0, c_white, 0.9);
}


if (state == PS_ATTACK_AIR || state == PS_ATTACK_GROUND)
{
    if (attack == AT_NTHROW && window == MSG_GRAB_ANTIBASH_WINDOW)
    {
        draw_sprite_ext(asset_get("bash_dir_spr"), 0, x+25*spr_dir, y-25, 1, 1, msg_antibash_direction - 45, c_white, 1);
    }
}
else if (state == PS_PARRY && (state_timer > 0 && state_timer < 10) && !has_parried)
{
    draw_sprite_ext(msg_substitute, 0, x+15*spr_dir, y, 1*spr_dir, 1, 0, c_white, 1);
}

// #region vvv LIBRARY DEFINES AND MACROS vvv
// DANGER File below this point will be overwritten! Generated defines and macros below.
// Write NO-INJECT in a comment above this area to disable injection.
#define msg_copy_params(source, target, limiter) // Version 0
    // Usage: for all variables in LIMITER: copy value from SOURCE to TARGET
    var keys = variable_instance_get_names(limiter)
    for (var k = 0; k < array_length(keys); k++)
    {
        variable_instance_set(target, keys[k],
                                variable_instance_get(source, keys[k]));
    }

#define msg_gpu_clear // Version 0
    while (msg_unsafe_gpu_stack_level > 0)
    {
        gpu_pop_state(); msg_unsafe_gpu_stack_level--;
    }
// DANGER: Write your code ABOVE the LIBRARY DEFINES AND MACROS header or it will be overwritten!
// #endregion