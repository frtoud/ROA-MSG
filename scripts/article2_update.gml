//pseudoclone update

if (instance_exists(client_id))
{
    x = client_id.x + client_offset_x;
    y = client_id.y + client_offset_y;

    spr_dir = client_id.spr_dir;
    //small_sprites = client_id.small_sprites;
    //true_sprite_index = client_id.sprite_index;
    //true_image_index = client_id.image_index;
    //hurtbox_index = client_id.hurtboxID.sprite_index;
    mask_index = client_id.mask_index;
}

depth = min(depth, client_id.depth - 1); //because of missingno predraw render shenans

var identifier = "missingno_hitbox_was_copied_by" + string(self.id); //WARNING: UNCERTAIN ABOUT THIS WORKING ONLINE. CHECK FOR DESYNCS
with (pHitBox) if (type == 1) && (orig_player_id == other.client_id)
{
    if ("missingno_hitbox_is_copy_of" in self)
    {
        if (missingno_hitbox_is_copy_for == other && instance_exists(missingno_hitbox_is_copy_of))
        {
            length = max(missingno_hitbox_is_copy_of.length, 1);
            hitbox_timer = max(0, missingno_hitbox_is_copy_of.hitbox_timer - 1);
            x_pos = missingno_hitbox_is_copy_of.x_pos + other.client_offset_x;
            y_pos = missingno_hitbox_is_copy_of.y_pos + other.client_offset_y;
        }
    }
    else if ( identifier not in self)
    {
        var hb_copy = noone;
        with (orig_player_id) { hb_copy = create_hitbox(other.attack, other.hbox_num, x, y); }

        hb_copy.x_pos = x_pos + other.client_offset_x;
        hb_copy.y_pos = y_pos + other.client_offset_y;
        hb_copy.missingno_hitbox_is_copy_of = self;
        hb_copy.missingno_hitbox_is_copy_for = other;

        variable_instance_set(self, identifier, true);

        hb_copy.length = max(length, 1);
        hb_copy.hitbox_timer = max(0, hitbox_timer - 1);
    }
}

if (detect_hit())
{
    swap_with_player();
}

//============================================================
// detect a hit and force it to connect
#define detect_hit()
{
    var result = false;
    //Detect hitboxes. (only those that could have damaged you)
    var team_attack = get_match_setting(SET_TEAMATTACK);

    var obj_player = client_id;
    var obj_copy = self;
    with (pHitBox)  if ( (hit_priority > 0) && (player != obj_player.player || can_hit_self)
                    && (obj_player.can_be_hit[player] == 0) && (can_hit[obj_player.player])
                    //&& (groundedness == 0 || (obj_player.free ? 2 : 1) == groundedness)
                    && (get_player_team(obj_player.player) != get_player_team(player) || team_attack)
                    && place_meeting(x - obj_copy.client_offset_x, y - obj_copy.client_offset_y, obj_player.hurtboxID) )
    {
        result = true;
    }

    return result;
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
    //adjust relative offset of all OTHER copies
    with (obj_article2) if (self != other) 
                        && ("is_missingno_copy" in self)
                        && (client_id == other.client_id)
    {
        client_offset_x += other.client_offset_x;
        client_offset_y += other.client_offset_y;
    }

}