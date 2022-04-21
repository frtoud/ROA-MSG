//hitbox_init

//==========================================================
if (attack == AT_USTRONG)
{
    coin_fading = false;
}

//==========================================================
else if (attack == AT_FSPECIAL_2)
{
    var bubble_can_hit = orig_player_id.msg_collective_bubble_lockout;

    for (var p = 0; p < array_length(bubble_can_hit); p++)
    {
        can_hit[p] = bubble_can_hit[p] == 0;
    }
}
//==========================================================
else if (attack == AT_FSPECIAL_AIR) //Hydro Pump
{
    uses_sprite_collision = false; //to show hitbox
}
//==========================================================
else if (attack == AT_DSPECIAL)
{
    if ("missingno_copied_player_id" not in self)
        missingno_copied_player_id = player_id;

    initial_hsp = hsp;
    initial_vsp = vsp;
}