#macro AR_STATE_NONE   -1
#macro AR_STATE_SPAWN   0
#macro AR_STATE_ACTIVE  1
#macro AR_STATE_DYING   2

//reupdate position
if (instance_exists(client_id))
{
    x = client_id.x + client_offset_x;
    y = client_id.y + client_offset_y;

    spr_dir = client_id.spr_dir;
    mask_index = client_id.mask_index;
    //small_sprites = client_id.small_sprites;
    //true_sprite_index = client_id.sprite_index;
    //true_image_index = client_id.image_index;
    //hurtbox_index = client_id.hurtboxID.sprite_index;
}
else
//makes no sense to continue like this
{ destroy_my_hitboxes(); instance_destroy(self); exit; }


switch (state)
{
    case AR_STATE_SPAWN:
    {
        if (state_timer > spawn_time) 
            set_state(AR_STATE_ACTIVE);
    } break;
    case AR_STATE_DYING:
    {
        if (state_timer > death_time)
        { instance_destroy(self); exit; }
    } break;
//============================================================
    case AR_STATE_ACTIVE:
    {
        //test for swapping
        var detected_hitbox = detect_hit();
        if (detected_hitbox != noone)
        {
            swap_with_player();
            //ensure hit connects
            if (detected_hitbox.type == 1) //"Melee"
            {
                //fake hitpause
                do_hitpause(client_id);
                do_hitpause(detected_hitbox.player_id);
            }
            else //type 2 "Projectile"
            {
                //give a tad more length to allow connecting
                do_hitpause(client_id);
                detected_hitbox.length = max(2, detected_hitbox.length)
                detected_hitbox.hitbox_timer = min(detected_hitbox.hitbox_timer, detected_hitbox.length - 1)
            }
        }
        //detect & copy new melee hitboxes over
        with (pHitBox) if (type == 1) && (orig_player_id == other.client_id)
        {
            // note: variable reused for yoyo glitch (this is intentional, lerped hitboxes should not be copied)
            if ("missingno_hitbox_is_copy_of" in self)
            {
                // maintenance on hitbox you copied
                if (missingno_hitbox_is_copy_for == other && instance_exists(missingno_hitbox_is_copy_of))
                {
                    length = max(missingno_hitbox_is_copy_of.length, 1);
                    hitbox_timer = max(0, missingno_hitbox_is_copy_of.hitbox_timer - 1);
                    x_pos = missingno_hitbox_is_copy_of.x_pos + other.client_offset_x;
                    y_pos = missingno_hitbox_is_copy_of.y_pos + other.client_offset_y;
                }
            }
            // copy new hitboxes (as per above, does not consider copied hitboxes)
            else if (other.missingno_unique_identifier not in self)
            {
                var hb_copy = noone;
                with (orig_player_id) { hb_copy = create_hitbox(other.attack, other.hbox_num, x, y); }

                hb_copy.x_pos = x_pos + other.client_offset_x;
                hb_copy.y_pos = y_pos + other.client_offset_y;
                hb_copy.missingno_hitbox_is_copy_of = self;
                hb_copy.missingno_hitbox_is_copy_for = other;

                variable_instance_set(self, other.missingno_unique_identifier, true);

                hb_copy.length = max(length, 1);
                hb_copy.hitbox_timer = max(0, hitbox_timer - 1);
            }
        }
    } break;
//============================================================
}

if (needs_to_die && state != AR_STATE_DYING) set_state(AR_STATE_DYING);
depth = min(depth, client_id.depth - 1); //because of missingno predraw render shenans

state_timer++;

//============================================================
#define set_state(new_state)
{
    destroy_my_hitboxes(); 
    state = new_state;
    state_timer = 0;
}

//============================================================
#define do_hitpause(target_player)
with (target_player) if (object_index == oPlayer)
{
    //Do not override previous old_hsp values if already in hitpause
    if (!hitpause)
    {
        old_hsp = hsp;
        old_vsp = vsp;
        hitpause = true;
    }
    hitstop = max(1, hitstop);
    hitstop_full = max(1, hitstop_full);
}

//============================================================
// return best detected hitbox that could hit you
#define detect_hit()
{
    var best_hitbox = noone;
    var best_priority = 0;
    //Detect hitboxes. (only those that could have damaged you)
    var team_attack = get_match_setting(SET_TEAMATTACK);

    var obj_player = client_id;
    var obj_copy = self;
    with (pHitBox)  if (hit_priority > best_priority) 
                    && ( (player == obj_player.player && can_hit_self)
                        || ( (get_player_team(obj_player.player) != get_player_team(player) || team_attack)) )
                    && (obj_player.can_be_hit[player] == 0) && (can_hit[obj_player.player])
                    //copy-ball interaction controlled by the projectile. see hitbox_update.gml
                    && ("missingno_copied_player_id" not in self)
                    && (groundedness == 0 || (obj_player.free ? 2 : 1) == groundedness)
                    && place_meeting(x - obj_copy.client_offset_x, y - obj_copy.client_offset_y, obj_player.hurtboxID)
    {
        best_hitbox = self;
        best_priority = hit_priority;
    }

    return best_hitbox;
}


//============================================================
// this detected a hit, exchange position with the real player
#define swap_with_player()
{
    var my_x = x;
    var my_y = y;
    //take his place
    x = client_id.x;
    y = client_id.y;
    //he takes mine
    client_id.x = my_x;
    client_id.y = my_y;

    //adjust relative position
    client_offset_x *= -1;
    client_offset_y *= -1;

    //update to all copies
    with (obj_article2) if ("is_missingno_copy" in self)
                        && (client_id == other.client_id)
    {
        //adjust relative offset of all OTHER copies
        if (self != other)
        {
            client_offset_x += other.client_offset_x;
            client_offset_y += other.client_offset_y;
        }

        //adjust hitbox positions
        with (pHitBox) if (type == 1) && (orig_player_id == other.client_id)
        {
            // note: variable reused for yoyo glitch (this is intentional, lerped hitboxes should not be copied)
            if ("missingno_hitbox_is_copy_of" in self)
            && (missingno_hitbox_is_copy_for == other && instance_exists(missingno_hitbox_is_copy_of))
            {
                x_pos = missingno_hitbox_is_copy_of.x_pos + other.client_offset_x;
                y_pos = missingno_hitbox_is_copy_of.y_pos + other.client_offset_y;
            }
        }

        //TODO: setup swap_cooldown (on clones? or on players? not sure theres a difference)
    }
}

//============================================================
//cannot delete self so carelessly; need to remove old hitboxes
#define destroy_my_hitboxes()
{
    with (pHitBox) if ("missingno_hitbox_is_copy_of" in self)
                   && (missingno_hitbox_is_copy_for == other)
    {
        instance_destroy(self);
    }
}