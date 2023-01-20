//death.gml

//reset certain things
msg_exploded_damage = 0;
msg_exploded_respawn = false;

//clears saved attack index
msg_bspecial_last_move.target = noone;
msg_bspecial_last_move.move = AT_TAUNT;

//======================================================
if (gfx_glitch_death_stack > 0)
&& (gfx_glitch_death_stack < gfx_glitch_death_stack_max)
{
    set_player_stocks(player, get_player_stocks(player) + 1);
    gfx_glitch_death_stack++;
    gfx_glitch_death_position.x = x;
    gfx_glitch_death_position.y = y;
}
else if (random_func(7, 8, true) == 0 || is_laststock())
     && (get_match_setting(SET_STOCKS) > 0)
{
    var active = [0, 0,0,0,0];
    var alive = [0, 0,0,0,0];
    for (var p = 1; p <= 4; p++) if is_player_on(p)
    {
        active[get_player_team(p)] = true;
        alive[get_player_team(p)] = get_player_stocks(p) > ((p == player) ? 1 : 0);
    }

    gfx_glitch_death_ends_match = (active[1] + active[2] + active[3] + active[4])
                                > ( alive[1] +  alive[2] +  alive[3] +  alive[4]);

    if (gfx_glitch_death_ends_match) set_player_stocks(player, get_player_stocks(player) + 1);
    gfx_glitch_death_stack = 1;
    gfx_glitch_death_position.x = x;
    gfx_glitch_death_position.y = y;
}