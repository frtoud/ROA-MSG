//death.gml

//reset certain things
msg_exploded_damage = 0;
msg_exploded_respawn = false;

//clears saved attack index
msg_bspecial_last_move.target = noone;

/*
if (get_player_stocks(player) == 1)
{
    set_player_stocks(player, 2);
    gfx_glitch_death = true;
}
*/