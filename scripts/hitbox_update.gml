//hitbox_update


//==========================================================
if (attack == AT_FSPECIAL)
{
    image_index = clamp(2 + (vsp/2), 0, 6)
    if (!free) { destroyed = true; }
}

//==========================================================
if (attack == AT_FSPECIAL_2)
{
    for (var p = 0; p < array_length(can_hit); p++)
    {
        if (can_hit[p] < 1) can_hit[p]++;
    }
}


//==========================================================
if (attack == AT_DSPECIAL)
{
    if (!free && hitbox_timer < 12)
    {
        vsp -= 6;
    }
    else if (!free || hitbox_timer >= length - 1) 
    {
        destroyed = true;
        with (orig_player_id)
        {
            spawn_hit_fx(other.x, other.y, hfx_ball_open);
            sound_play(asset_get("sfx_blow_weak2"));

            //y offset because of size of pokeball when landed
            var copy = instance_create(other.x, other.y + 12, "obj_article2");
            copy.client_id = self;
            copy.client_offset_x = copy.x - x;
            copy.client_offset_y = copy.y - y;
        }
    }
}

//==========================================================
if (attack == AT_DSPECIAL_2)
{
    //All copied projectiles fall under here
    if (grounds == 0) && (!free) { destroyed = true; }
}