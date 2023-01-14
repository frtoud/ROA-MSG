//=============================================

//========================================================================================================
#define spawn_base_dust
///spawn_base_dust(x, y, name, dir = 0, angle = 0)
///spawn_base_dust(x, y, name, ?dir, ?angle)
// originally by supersonic
//This function spawns base cast dusts. Names can be found below.
//========================================================================================================
var x = argument[0], 
    y = argument[1], 
    name = argument[2];
var dir = argument_count > 3 ? argument[3] : 0;
var angle = argument_count > 4 ? argument[4] : 0;

var dlen; //dust_length value
var dfx; //dust_fx value
var dfg; //fg_sprite value
var dfa = 0; //draw_angle value
var dust_color = 0;

switch (name) 
{
    default: 
    // warning: sprite assets magic numbers
    case "dash_start": dlen = 21; dfx = 3;  dfg = 2626; break;
    case "dash":       dlen = 16; dfx = 4;  dfg = 2656; break;
    case "jump":       dlen = 12; dfx = 11; dfg = 2646; break;
    case "doublejump": 
    case "djump":      dlen = 21; dfx = 2;  dfg = 2624; break;
    case "walk":       dlen = 12; dfx = 5;  dfg = 2628; break;
    case "land":       dlen = 24; dfx = 0;  dfg = 2620; break;
    case "walljump":   dlen = 24; dfx = 0;  dfg = 2629; dfa = -90 *(dir != 0 ? dir : spr_dir); break;
    case "n_wavedash": dlen = 24; dfx = 0;  dfg = 2620; dust_color = 1; break;
    case "wavedash":   dlen = 16; dfx = 4;  dfg = 2656; dust_color = 1; break;
}
var newdust = spawn_dust_fx(round(x),round(y),asset_get("empty_sprite"),dlen);
if (newdust == noone) return noone;

newdust.draw_angle = dfa + angle;
newdust.dust_fx = dfx; //set the fx id
newdust.dust_color = dust_color; //set the dust color
if (dfg != -1) newdust.fg_sprite = dfg; //set the foreground sprite
if (dir != 0) newdust.spr_dir = dir; //set the spr_dir
return newdust;