//hitbox_update

//==========================================================
if (attack == AT_USTRONG)
{
    if (coin_fading) 
    { 
        //flickering
        visible = (hitbox_timer % 2) == 0 || hitbox_timer < 10;
    }
    else if (!free) 
    { 
        coin_fading = true; 
        image_yscale = 0; //essentially turns off collider
        hitbox_timer = 0;
        img_spd = 0;
        image_index = floor(image_index);
        length = 20;
    }
    else
    {
        //Shyguy DI glitch: check for victims already in hitstun
        var target_in_hitstun = false;
        var proj_team = get_player_team(player);
        var coin = self;

        with (oPlayer) if (state_cat == SC_HITSTUN) && (!hitpause)
        && (self != other.orig_player_id || other.can_hit_self)
        && (can_be_hit[other.player] == 0) && (other.can_hit[player])
        //teamattack check
        && ( (player == other.player && other.can_hit_self)
        ||   (proj_team != get_player_team(player) 
             || (temp_team_attack && other.player != player) ) )
        //minimum speed of hitstun
        && (point_distance(0, 0, hsp, vsp) > 6)
        {
            with (hurtboxID) //collision test
            {
                target_in_hitstun = place_meeting(x, y, coin);
            }
            if (target_in_hitstun) break;
        }

        //zero KB means that hit_player.gml can restore the previous speeds
        //..."Thanks" Dan?
        kb_value = target_in_hitstun ? 0 : original_kb_value;
        kb_scale = target_in_hitstun ? 0 : original_kb_scale;
    }
}

//==========================================================
if (attack == AT_FSPECIAL)
{
    //animated droplet
    image_index = clamp(2 + (vsp/2), 0, 6)
}

//==========================================================
if (attack == AT_NSPECIAL)
{
    //early land: bounce
    if (!free && hitbox_timer < 12)
    {
        vsp -= 6;
    }
    //clone creation after enough time
    else if (!free) || (hitbox_timer >= length - 1) 
    {
        if (hbox_num == 1) destroy_copies(missingno_copied_player_id); //flushes old clones
        destroyed = true;

        with (orig_player_id)
        {
            var k = spawn_hit_fx(other.x, other.y, hfx_ball_open);
            k.depth -= 20;
            sound_play(sound_get("ball_explode"));

            //ownership of projectile determines article's scripts when created in hitbox_update.gml
            //this un-parries the projectile for article creation (just in case) (dan pls)
            other.orig_player_id = self;
            other.orig_player = player;
            other.player_id = self;
            other.player = player;

            //y offset because of size of pokeball when landed
            var copy = instance_create(other.x, other.y + 12, "obj_article2");
            copy.client_id = other.missingno_copied_player_id;
            var GRIDSNAP = 16;
            copy.client_offset_x = GRIDSNAP * floor((copy.x - copy.client_id.x) / GRIDSNAP);
            copy.client_offset_y = GRIDSNAP * floor((copy.y - copy.client_id.y) / GRIDSNAP);
        }
    }
    //special collision checks
    else if (hbox_num == 1)
    {
        var hbox = self;
        var hbox_has_hit = false;
        //clone duplication
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
        // Teammate interaction
        with (oPlayer) if (!hbox_has_hit)
                       && (self != other.orig_player_id)
                       && (get_player_team(player) == hbox.my_team)
        {
            with (hurtboxID) 
            { hbox_has_hit = place_meeting(x, y, hbox); }

            if (hbox_has_hit) with (hbox.orig_player_id)
            {
                sound_play(hbox.sound_effect);
                spawn_hit_fx(floor(hbox.x), floor(hbox.y), hbox.hit_effect);
                hbox.destroyed = true;

                var hb = create_hitbox(hbox.attack, 2, hbox.x, hbox.y)
                hb.hsp = hbox.initial_hsp;
                hb.vsp = hbox.initial_vsp;
                hb.missingno_copied_player_id = other;
                //consume existing clones
                destroy_copies(other);
            }
        }
        // Hit by melee hitbox
        with (pHitBox) if (!hbox_has_hit)
                       && (type == 1) && (hit_priority > 0)
                       && (orig_player_id != other.orig_player_id)
                       && (get_player_team(player) != hbox.my_team)
                       && place_meeting(x, y, hbox)
        {
            hbox_has_hit = true;
            var enemy_hitbox = self;

            with (hbox.orig_player_id)
            {
                sound_play(other.sound_effect);
                spawn_hit_fx(floor(hbox.x), floor(hbox.y), hbox.hit_effect);
                hbox.destroyed = true;

                var hb = create_hitbox(hbox.attack, 2, hbox.x, hbox.y)
                
                var angle = 90;
                with (hbox) angle = get_hitbox_angle(enemy_hitbox);

                hb.hsp = lengthdir_x(enemy_hitbox.kb_value, angle);
                hb.vsp = lengthdir_y(enemy_hitbox.kb_value, angle);
                hb.missingno_copied_player_id = enemy_hitbox.orig_player_id;
                //consume existing clones
                destroy_copies(other);
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