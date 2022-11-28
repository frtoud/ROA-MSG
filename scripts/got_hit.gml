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