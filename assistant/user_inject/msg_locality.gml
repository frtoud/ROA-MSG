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

