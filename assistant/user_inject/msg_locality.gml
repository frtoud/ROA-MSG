//=======================================
#define msg_init_locality()
{
    //Local CSS player zero has hud color 0,0,0
    //Online CSS player zero has your current team's hud color, or online-only green color
    //this information is kept on match start, meaning it's possible to detect who's remote
    var zero_hud = get_player_hud_color(0);

    //wether we are online or not
    msg_is_online = zero_hud != 0;

    //if online, wether or not you (or a teammate) is the local player
    //else, always false
    msg_is_local = (zero_hud == get_player_hud_color(player));
}

//========================================
#define msg_get_local_player()
{
    //get closest local player
    var best_player = player;
    var best_distance = 9999999;
    with (oPlayer)
    {
        if (msg_is_local) && (point_distance(other.x, other.y, x, y) < best_distance)
            best_player = player;
    }
    return best_player;
}

//========================================
#define msg_get_local_hud_order()
{
    //determine the HUD ordering for negative percent icon

    msg_player_to_hud_positions = [noone, noone, noone, noone, noone];
    var hud_pos_list = [noone, noone, noone, noone];
    switch (is_player_on(1) + is_player_on(2) + is_player_on(3) + is_player_on(4))
    {
        case 1: hud_pos_list = [  377, noone, noone, noone] break;
        case 2: hud_pos_list = [  258,   496, noone, noone] break;
        case 3: hud_pos_list = [  139,   377,   615, noone] break;
        case 4: hud_pos_list = [   20,   258,   496,   734] break;
    }

    if (!msg_is_online)
    {
        //Not online, known ordering: P1, P2, P3, P4
        var hud_num = 0;
        for (var p = 1; p <= 4; p++)
        {
            if (is_player_on(p))
            {
                msg_player_to_hud_positions[p] = hud_pos_list[hud_num];
                hud_num++;
            }
        }
    }
    else 
    {
        //Online match: ordering is shown differently per client
        //Local player is always first, rest are sorted in order P1, P2, P3, P4
        var true_local_player = 0;

        if !get_match_setting(SET_TEAMS)
        {
            //msg_is_local is accurate
            with (oPlayer) if (msg_is_local) true_local_player = player;
        }
        else
        {
            //additional check with nicknames
            var local_nickname = get_player_name(0);
            var number_of_nickname_matches = 0;
            for (var p = 1; p <= 4; p++)
            {
                if (get_player_name(p) == (local_nickname == "P0" ? "P"+string(p) : local_nickname))
                {
                    true_local_player = p;
                    number_of_nickname_matches++;
                }
            }

            //nickname check unsuccessful; check using temp_x
            if (number_of_nickname_matches != 1)
            {
                true_local_player = 0;
                //check if a temp_x matches predicted local HUD
                //Notes:
                // temp_x doesnt exist on basecast
                // temp_x only exists after at least one call to draw_hud
                // temp_x not guaranteed to be accurate on workshop, either (can be set to)
                with (oPlayer) if ("temp_x" in self) && (temp_x == hud_pos_list[0])
                { true_local_player = player; break; }
            }

            //temp_x check unsuccessful; assume lowest playerport with msg_is_local to be true local.
            if (true_local_player == 0)
            {
                with (oPlayer) if (msg_is_local) && (player < true_local_player)
                {
                    true_local_player = player;
                }
                if (true_local_player == 99) //how can no one be local!?
                    true_local_player = player;
            }
        }
        
        //Get resulting order
        msg_player_to_hud_positions[true_local_player] = hud_pos_list[0];
        var hud_num = 1;
        for (var p = 1; p <= 4; p++)
        {
            if (is_player_on(p) && true_local_player != p)
            {
                msg_player_to_hud_positions[p] = hud_pos_list[hud_num];
                hud_num++;
            }
        }
    }
}
