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


#define msg_acemilate(index_source, other_source, hbx)
{
    var scrombled_index1 = (((msg_broken_grab_seed << 1) ^ index_source) % 64)
    var scrombled_index2 = (((scrombled_index1 << 1) ^ other_source) % 64)
    msg_broken_grab_seed = (((scrombled_index2 << 1) ^ hbx.attack + 1) % 64)
    var scan_indexes = [index_source, scrombled_index1, scrombled_index2, msg_broken_grab_seed];
    msg_broken_grab_seed *= msg_broken_grab_seed;

    for (var i = 0; i < 4; i++)
    {
        var accumulate = scan_indexes[i] > 16;
        var idx = HG_DAMAGE, stat = 1, cap = 5;
        switch (scan_indexes[i] % 16)
        {
            default:
            case  0: idx = HG_BASE_HITPAUSE;      stat = hbx.hitpause;        cap = 20;    break;
            case  1: idx = HG_HITPAUSE_SCALING;   stat = hbx.hitpause_growth; cap = 2;     break;
            case  2: idx = HG_VISUAL_EFFECT;      stat = hbx.hit_effect;      cap = noone; break;
            case  3: idx = HG_SDI_MULTIPLIER;     stat = hbx.sdi_mult-1;      cap = 3;     break;
            case  4: idx = HG_TECHABLE;           stat = hbx.can_tech;        cap = 3;     break;
            case  5: idx = HG_HIT_SFX;            stat = hbx.sound_effect;    cap = noone; break;
            case  6: idx = HG_ANGLE_FLIPPER;      stat = hbx.hit_flipper;     cap = 12;    break;
            case  7: idx = HG_EXTRA_HITPAUSE;     stat = hbx.extra_hitpause;  cap = 30;    break;
            case  8: idx = HG_HIT_LOCKOUT;        stat = hbx.no_other_hit;    cap = 50;    break;
            case  9: idx = HG_HITSTUN_MULTIPLIER; stat = hbx.hitstun_factor;  cap = 3;     break;
            case 10: idx = HG_DRIFT_MULTIPLIER;   stat = hbx.dumb_di_mult;    cap = 3;     break;
            case 11: idx = HG_DAMAGE;             stat = hbx.damage;          cap = 50;    break;
            case 12: idx = HG_ANGLE;              stat = hbx.kb_angle;        cap = 361;   break;
            case 13: idx = HG_BASE_KNOCKBACK;     stat = hbx.kb_value;        cap = 16;    break;
            case 14: idx = HG_KNOCKBACK_SCALING;  stat = hbx.kb_scale;        cap = 2;     break;
            case 15: idx = HG_EFFECT;             stat = hbx.effect;          cap = 20;    break;
        }
        
        var base = accumulate ? get_hitbox_value(AT_NTHROW, MSG_GRAB_BROKEN_HITBOX, idx) : 0;
        set_hitbox_value(AT_NTHROW, MSG_GRAB_BROKEN_HITBOX, idx, (cap == noone) ? stat : ((base + stat) % cap));
    }
}