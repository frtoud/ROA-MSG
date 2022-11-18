//pre_draw.gml

//Colors stuff
//This block should be the same in css-draw (minus spin variability)
//===================================================

//draw_sprite(sprite_get("Axonium_coloradjust_portrait"), 0, 0, 0);
/*
//===================================================
if (get_player_color(player) == 2) 
{ 
    set_character_color_shading( 0, 0.5 ); 
    set_character_color_shading( 3, 0.0 );
}
//===================================================
*/
//draw_text_color(x, y-32, "", c_black, c_white,c_black,c_black, 1);

var h = 50;

for (var i = 0; i <= 4; i++)
{
    var str = get_char_info(i, INFO_STR_NAME) + " team " + string(get_player_team(i)) + " hud " + string(get_player_hud_color(i))
    draw_debug_text(x-4, floor(y+h), str); h+=20;
}

//draw_sprite_tiled_ext(sprite_get("hurt"), 1, 1, 1, 2, 2, c_white, 1);
exit;
var found = noone;
with (asset_get("obj_article3")) if ("missingno" == num)
{
    found = self;
    break;
}

if !instance_exists(found)
{
    found = instance_create(0, 0, "obj_article3");
    found.num = "missingno";
    found.persistent = true;
    found.uses_shader = false;
}

//show_debug_message("Variables for " + object_get_name(object_index) + string(id));