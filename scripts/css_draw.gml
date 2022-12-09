//css_draw.gml


//show_debug_message("Variables for " + object_get_name(object_index) + string(id));

if (msg_error_active)
{

    var tmp_a = draw_get_alpha();
    draw_set_alpha(0.4);
    draw_rectangle_color(0, 0, room_width, room_height, c_black, c_black, c_black, c_black, false);
    draw_set_alpha(tmp_a);

    var anim_offset = (msg_error_timer < 10) ? ease_expoOut( 500, 0, msg_error_timer, 10 ): 0;

    var dialog_spr = asset_get("popup_dynamic_spr");

    var dlg_spr_width = 154;
    var dialog_height = 220;
    var dlg_x = 328;
    var dlg_y = 158 + anim_offset;
    draw_sprite_part_ext(dialog_spr, 0, 0, 0, dlg_spr_width, 3, dlg_x, dlg_y, 2, 2, c_white, 1);
    draw_sprite_part_ext(dialog_spr, 0, 0, 3, dlg_spr_width, 1, dlg_x, dlg_y + 6, 2, dialog_height, c_white, 1);
    draw_sprite_part_ext(dialog_spr, 0, 0, 4, dlg_spr_width, 3, dlg_x, dlg_y + 6 + dialog_height, 2, 2, c_white, 1);

    var text_posx = dlg_x + dlg_spr_width - 2;
    var text_posy = dlg_y + 10;
    textDraw(text_posx, text_posy, asset_get("roundFont"), c_white, 28, 300, fa_center, 1, true, 1, msg_error_message);

    draw_sprite_ext(asset_get("popup_ok_but_spr"), 0, text_posx - 50, text_posy + 176, 2, 2, 0, c_white, 1);
    textDraw(text_posx, text_posy + 180, asset_get("medFont"), c_white, 28, 300, fa_center, 1, true, 1, "OK");
}
//gus_shopicon_spr - 10



//=====================================================================
#define textDraw(x1, y1, font, color, line_sep, line_max, align, scale, outlined, alpha, text)
// Draw text at position x1, y1, using scale, alpha, align, font and color.
// line_sep is the vertical separation between text.
// line_max is the maximum length for a line of text.
// if outlined is TRUE, draws a 2px black contour.
//=====================================================================
{
    x1 = round(x1);
    y1 = round(y1);

    draw_set_font(font);
    draw_set_halign(align);

    if (outlined)
    {
        for (var i = -1; i < 2; i++) 
        {
            for (var j = -1; j < 2; j++) 
            {
                draw_text_ext_transformed_color(x1 + i * 2, y1 + j * 2, text, 
                    line_sep, line_max, scale, scale, 0, c_black, c_black, c_black, c_black, alpha);
            }
        }
    }

    if (alpha > 0.01) 
        draw_text_ext_transformed_color(x1, y1, text, line_sep, line_max, 
                    scale, scale, 0, color, color, color, color, alpha);
}