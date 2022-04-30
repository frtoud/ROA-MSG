//hitbox_update

//==========================================================
if (attack == AT_USTRONG)
{
    if (coin_fading) 
    { 
        visible = (hitbox_timer % 2) == 0 || hitbox_timer < 10;
    }
    else if (!free) 
    { 
        coin_fading = true; 
        image_yscale = 0;
        hitbox_timer = 0;
        img_spd = 0;
        image_index = floor(image_index);
        length = 20;
    }
}

//==========================================================
if (attack == AT_FSPECIAL)
{
    image_index = clamp(2 + (vsp/2), 0, 6)
    if (!free) { destroyed = true; }
}

//==========================================================
if (attack == AT_DSPECIAL)
{
    if (!free && hitbox_timer < 12)
    {
        vsp -= 6;
    }
    else if (!free) || (hitbox_timer >= length - 1) 
    {
        if (hbox_num == 1) destroy_copies(missingno_copied_player_id); //flushes old clones
        destroyed = true;


        with (orig_player_id)
        {
            var k = spawn_hit_fx(other.x, other.y, hfx_ball_open);
            k.depth -= 20;
            sound_play(asset_get("sfx_blow_weak2"));

            //ownership of projectile determines article's scripts when created in hitbox_update.gml
            //this un-parries the projectile for article creation
            //DAN PLS
            other.orig_player_id = self;
            other.orig_player= player;
            other.player_id = self;
            other.player = player;

            //y offset because of size of pokeball when landed
            var copy = instance_create(other.x, other.y + 12, "obj_article2");
            copy.client_id = other.missingno_copied_player_id;
            copy.client_offset_x = 8 * floor((copy.x - copy.client_id.x) / 8);
            copy.client_offset_y = 8 * floor((copy.y - copy.client_id.y) / 8);

        }
    }
    else if (hbox_num == 1)
    {
        var hbox = self;
        var hbox_has_hit = false;
        with (obj_article2) if (!hbox_has_hit) 
                            && ("is_missingno_copy" in self) && (state != 2)
        {
            with (client_id.hurtboxID) 
            { hbox_has_hit = place_meeting(x + other.client_offset_x, y + other.client_offset_y, hbox); }

            if (hbox_has_hit) with (hbox.orig_player_id)
            {
                sound_play(hbox.sound_effect);
                spawn_hit_fx(floor(hbox.x), floor(hbox.y), hbox.hit_effect);
                hbox.destroyed = true;

                var hbox_top = create_hitbox(hbox.attack, 2, hbox.x, hbox.y);
                hbox_top.missingno_copied_player_id = other.client_id;
                hbox_top.image_index = 1;
                hbox_top.length -= 15;
                hbox_top.hsp = max(abs(hbox.initial_hsp), 2);
                hbox_top.vsp = min(hbox.vsp, -2);
                var hbox_bot = create_hitbox(hbox.attack, 2, hbox.x, hbox.y);
                hbox_bot.missingno_copied_player_id = other.client_id;
                hbox_bot.image_index = 2;
                hbox_bot.hsp = -max(abs(hbox.initial_hsp), 2);
                hbox_bot.vsp = min(hbox.vsp, -2);

                destroy_copies(other.client_id); //other copies consumed
            }
        }
    }
}

//==========================================================
if (attack == AT_DSPECIAL_2)
{
    //All copied projectiles fall under here
    if (grounds == 0) && (!free) { destroyed = true; }
}

//==========================================================
// destroy all current missingno-copies of a player
#define destroy_copies(target_client_id)
{
    with (obj_article2) if ("is_missingno_copy" in self)
                        && (client_id == target_client_id)
    {
        needs_to_die = true; //article consumed
    }
}