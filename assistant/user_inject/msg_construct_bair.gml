#define msg_construct_bair(target)
//steals physical statistics to dynamically determine BAIR's stats


set_hitbox_value(AT_BAIR, 1, HG_DAMAGE, target.walljump_hsp);
set_hitbox_value(AT_BAIR, 1, HG_ANGLE, target.char_height);
set_hitbox_value(AT_BAIR, 1, HG_BASE_KNOCKBACK, target.initial_dash_speed);
set_hitbox_value(AT_BAIR, 1, HG_KNOCKBACK_SCALING, target.gravity_speed);
set_hitbox_value(AT_BAIR, 1, HG_BASE_HITPAUSE, target.max_jump_hsp);
set_hitbox_value(AT_BAIR, 1, HG_HITPAUSE_SCALING, target.dash_stop_percent);