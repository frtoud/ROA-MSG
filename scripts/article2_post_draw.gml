//post_draw
if (!instance_exists(client_id)) exit;

with (client_id)
{
    shader_start();
    var scale = small_sprites + 1;

    var alpha = (other.state == 1 ? 1 : 0.5);

    draw_sprite_ext(sprite_index, image_index, other.x, other.y, scale*spr_dir, scale, 0, c_white, alpha);
    shader_end();

    if (other.state == 1 && get_match_setting(SET_HITBOX_VIS))
    {
        draw_sprite_ext(hurtboxID.sprite_index, image_index, other.x, other.y, spr_dir, 1, 0, c_white, 0.5);
    }
}