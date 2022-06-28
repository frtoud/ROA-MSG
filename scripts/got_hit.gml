//Reapply damage from previous life
if (msg_exploded_damage != 0)
{
    take_damage( player, -1, msg_exploded_damage );
    msg_exploded_damage = 0;
}

//clears saved attack index
msg_bspecial_last_move.target = noone;

if (attack == AT_FSTRONG && strong_charge > 0 && strong_charge < 60)
{
    //interrupted: start charging passively >:]
    msg_fstrong_interrupted_timer = strong_charge;
}