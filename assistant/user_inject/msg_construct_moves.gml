#define msg_construct_bair(target)
//steals physical statistics to dynamically determine BAIR's stats

set_window_value(AT_BAIR, 1, AG_WINDOW_LENGTH, target.max_fall);
set_window_value(AT_BAIR, 1, AG_WINDOW_SFX_FRAME, target.max_fall-1);

set_window_value(AT_BAIR, 3, AG_WINDOW_LENGTH, target.fast_fall);

set_hitbox_value(AT_BAIR, 1, HG_ANGLE, target.char_height);
set_hitbox_value(AT_BAIR, 1, HG_EFFECT, target.land_time);
set_hitbox_value(AT_BAIR, 1, HG_DAMAGE, target.walljump_vsp);
set_hitbox_value(AT_BAIR, 1, HG_BASE_KNOCKBACK, target.initial_dash_speed);
set_hitbox_value(AT_BAIR, 1, HG_KNOCKBACK_SCALING, target.prat_fall_accel);

set_hitbox_value(AT_BAIR, 1, HG_BASE_HITPAUSE, target.max_jump_hsp);
set_hitbox_value(AT_BAIR, 1, HG_HITPAUSE_SCALING, target.gravity_speed);

