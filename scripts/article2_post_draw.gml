//post_draw
if (!instance_exists(client_id)) exit;

with (client_id)
{
    shader_start();
    var scale = small_sprites + 1;
    draw_sprite_ext(sprite_index, image_index, other.x, other.y, scale*spr_dir, scale, 0, c_white, 1);
    shader_end();

    if (get_match_setting(SET_HITBOX_VIS))
    {
        draw_sprite_ext(hurtboxID.sprite_index, image_index, other.x, other.y, spr_dir, 1, 0, c_white, 0.5);
    }
}