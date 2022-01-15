//pseudoclone update

if (instance_exists(client_id))
{
    x = client_id.x + client_offset_x;
    y = client_id.y + client_offset_y;

    spr_dir = client_id.spr_dir;
    small_sprites = client_id.small_sprites;
    true_sprite_index = client_id.sprite_index;
    true_image_index = client_id.image_index;
    hurtbox_index = client_id.hurtboxID.sprite_index;
    mask_index = client_id.mask_index;
}

depth = min(depth, client_id.depth - 1);