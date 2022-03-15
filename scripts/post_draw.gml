//post_draw.gml

//Restore drawing parameters
msg_copy_params(msg_anim_backup, self, msg_anim_backup);

//Prevents screen from being pitch-black and not printing any error message. also prevents a crash.
if (msg_draw_is_in_progress_temp_flag_should_never_be_true_outside_pre_draw) gpu_pop_state();

if (msg_dstrong_yoyo.active && msg_dstrong_yoyo.visible)
{
    draw_sprite_ext(sprite_get("dstrong"), 1, msg_dstrong_yoyo.x, msg_dstrong_yoyo.y, 2, 2, 0, c_white, 0.9);
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
// DANGER: Write your code ABOVE the LIBRARY DEFINES AND MACROS header or it will be overwritten!
// #endregion