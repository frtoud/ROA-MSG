//css_update.gml

if (msg_error_active)
{
    msg_error_timer++;
    suppress_cursor = true;
    if (msg_error_timer > 30) && (menu_a_pressed)
    {
        sound_play(asset_get("mfx_option"));
        msg_error_active = false;
    }
}