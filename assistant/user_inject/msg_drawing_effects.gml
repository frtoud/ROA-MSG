#define msg_manual_draw
/// msg_manual_draw(main_draw = true)
//Handles REDRAW-type effects that need to draw differently than usual
var main_draw = argument_count > 0 ? argument[0] : true;
var skips_draw = false; //determines if the actual draw event needs to be interrupted

var scale = 1 + small_sprites;


//===========================================================
//effect type: REDRAW
if (msg_unsafe_effects.bad_vsync.timer > 0)
{
    var spr_w = sprite_get_width(sprite_index);
    var spr_h = sprite_get_height(sprite_index);
    var spr_cliptop = spr_h - msg_unsafe_effects.bad_vsync.cliptop;
    var spr_clipbot = spr_h - msg_unsafe_effects.bad_vsync.clipbot;
    var vsync_offset = msg_unsafe_effects.bad_vsync.horz;
    
    var pos_x = x - scale*sprite_xoffset + draw_x;
    var pos_y = y - scale*sprite_yoffset + draw_y;
    
    if (main_draw) shader_start();
    draw_sprite_part_ext(sprite_index, image_index, 0, 0, spr_w, spr_cliptop, 
                        pos_x, pos_y, spr_dir * scale, scale, c_white, 1.0);
    draw_sprite_part_ext(sprite_index, image_index, 0, spr_cliptop, spr_w, spr_clipbot - spr_cliptop, 
                        pos_x + vsync_offset, pos_y + spr_cliptop*scale, spr_dir * scale, scale, c_white, 1.0);
    draw_sprite_part_ext(sprite_index, image_index, 0, spr_clipbot, spr_w, max(spr_h - spr_clipbot, 0), 
                        pos_x, pos_y + spr_clipbot*scale, spr_dir * scale, scale, c_white, 1.0);
    if (main_draw) shader_end();
    
    skips_draw = main_draw;
}
//===========================================================
// Normal draw (possibly needed by glitch BG)
else if (!main_draw) || (small_sprites != msg_anim_backup.small_sprites)
{
    //note: not sure if worth keeping small_sprites clause.
    if (main_draw) shader_start();
    draw_sprite_ext(sprite_index, image_index, x+draw_x, y+draw_y, 
                    scale*spr_dir, scale, spr_angle, c_white, 1);
    if (main_draw) shader_end();
    
    skips_draw = main_draw;
}
//===========================================================

// to turn off normal rendering for this frame
if (skips_draw) sprite_index = asset_get("empty_sprite");

#define msg_copy_params(source, target, limiter)
//Usage: for all variables in LIMITER: copy value from SOURCE to TARGET
var keys = variable_instance_get_names(limiter)
for (var k = 0; k < array_length(keys); k++)
{
    variable_instance_set(target, keys[k], 
                            variable_instance_get(source, keys[k]));
}
