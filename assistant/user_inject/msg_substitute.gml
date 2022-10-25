
#macro SUBS_DAMAGE       60
#macro SUBS_ADJ           1.4
#macro SUBS_MIN_LAUNCH    7

//================================================
#define msg_launch_substitute(hitbox, substitute)
{
    substitute.hitpause_timer = get_hitstop_formula(SUBS_DAMAGE, hitbox.damage, 
        hitbox.hitpause, hitbox.hitpause_growth, hitbox.extra_hitpause);
    substitute.length = 10 + get_hitstun_formula(SUBS_DAMAGE, SUBS_ADJ, 2, 
        hitbox.damage, hitbox.kb_value, hitbox.kb_scale);

    var kb = get_kb_formula(SUBS_DAMAGE, SUBS_ADJ, 1, 
        hitbox.damage, hitbox.kb_value, hitbox.kb_scale);

    kb = max(kb, SUBS_MIN_LAUNCH);

    var angle = get_hitbox_angle(hitbox) - 12 + random_func_2(7, 24, true)

    substitute.old_hsp = lengthdir_x(kb, angle);
    substitute.old_vsp = lengthdir_y(kb, angle);
    substitute.hitstop = true;

    has_parried = true;
}

