//hitbox_init

//==========================================================
if (attack == AT_FSPECIAL_2)
{
    with (pHitBox) if (self != other && attack == AT_FSPECIAL_2 
    && "url" in orig_player_id && orig_player_id.url == other.orig_player_id.url)
    {
        for (var p = 0; p < array_length(can_hit); p++)
        {
            other.can_hit[p] = can_hit[p];
        }
        break;
    }
}

//==========================================================
if (attack == AT_DSPECIAL)
{
    if ("missingno_copied_player_id" not in self)
        missingno_copied_player_id = player_id;

    initial_hsp = hsp;
    initial_vsp = vsp;
}