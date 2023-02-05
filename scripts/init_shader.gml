//init_shader.gml

var color = get_player_color(player);

if ("msg_effective_alt" in self) && (msg_effective_alt != color)
{
    color = msg_effective_alt;
    apply_color_slot(0, color, 0);
    apply_color_slot(1, color, 1);
    apply_color_slot(2, color, 2);
    apply_color_slot(3, color, 3);
}

if (color == 14)
{
    var sync = get_synced_var(player);
    apply_color_slot(1, (sync & 0xF0) >> 4, 2);
    apply_color_slot(2, (sync & 0xF00)>> 8, 1);
}
else if (color == 15)
{
    colorO[8*4 + 0] = 0;
    colorO[8*4 + 1] = 0.55;
    colorO[8*4 + 2] = 0;
    set_character_color_shading(0, 0.0);
    set_character_color_shading(1, 0.0);
    set_character_color_shading(2, 0.0);
    set_character_color_shading(3, 0.0);
}

//============================================
//remove all shading
if (object_index == asset_get("oPlayer") || object_index == asset_get("oTestPlayer"))
{
    set_character_color_shading(0, 0.0);
    set_character_color_shading(1, 0.0);
    set_character_color_shading(2, 0.0);
    set_character_color_shading(3, 0.0);

    //set true colors to pixelblock zones
    apply_color_slot(4, color, 0);
    apply_color_slot(5, color, 1);
    apply_color_slot(6, color, 2);
    apply_color_slot(7, color, 3);
}

exit;
//anticheapie experiments: to put in persistent article
if (object_index == asset_get("draw_result_screen"))
{
    results_theme_enabled = false;
    winner_name = ""

    with asset_get("result_screen_box")
    {
        y = 65535; //using x softlocks the game
    }

    //these prevent results screen animation from even starting; grey screen softlock
    //results_timer = 0;
    //results_timer_real = 0;
    //result_box_timer = 0;
}
//============================================

exit;
if (object_index == asset_get("draw_result_screen"))
{
    //if !("sound_id" in self) { sound_id = true; print_debug("initshadered " + test_string) }
    var ty;
    draw_debug_text(400, 20*ty, "winner_name: " + string(winner_name)); ty++;
    //draw_debug_text(400, 20*ty, "winner: " + string(winner)); ty++;
    //draw_debug_text(400, 20*ty, "player: " + string(player)); ty++;
    //results_theme_enabled = false;
    
    //box_exit_x = (floor(results_timer/10));
    //player = 2;//(winner % 4);
    
    //winner_name = "Hey look what I did";
    
    with asset_get("result_screen_box")
    {
        if (player == other.player)
        {
            draw_sprite(sprite_get("glitch_bg"), 1, 400, 500);
        }
    }
    
    draw_debug_text(400, 20*ty, "kb: " + string(keyboard_string)); ty++;
    /* if !("t" in self) t = 0;
    t = (t + 1) % (60 * array_length(array))
    str = array[floor(t/60)] + ":" + string(variable_instance_get(id, array[floor(t/60)]));
    print_debug(str);*/
}

//if object_index == asset_get("result_screen_box")
//{
    //if !("sound_id" in self) { sound_id = true; print_debug("initshadered " + test_string) }
    
    //draw_debug_text(400, 20*ty, "player: " + string(player)); ty++;
    //print_debug(string(player));
//}

#define apply_color_slot(target_shade, source_color, source_shade)
{
   set_character_color_slot(target_shade,  
        get_color_profile_slot_r(source_color, source_shade),  
        get_color_profile_slot_g(source_color, source_shade),
        get_color_profile_slot_b(source_color, source_shade), 1);
   set_article_color_slot(target_shade,  
        get_color_profile_slot_r(source_color, source_shade),  
        get_color_profile_slot_g(source_color, source_shade),
        get_color_profile_slot_b(source_color, source_shade), 1);
}