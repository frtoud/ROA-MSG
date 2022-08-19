#define msg_manual_draw
/// msg_manual_draw(main_draw = true)
//Handles REDRAW-type effects that need to draw differently than usual
var main_draw = argument_count > 0 ? argument[0] : true;
var skips_draw = false; //determines if the actual draw event needs to be interrupted

var scale = 1 + small_sprites;

//===========================================================
// REDRAW EFFECT: VSYNC
// sprite trisected vertically, middle displaced
if (msg_unsafe_effects.bad_vsync.timer > 0)
{
    var spr_w = abs(sprite_width); //WHY!?
    var spr_cliptop = sprite_height - msg_unsafe_effects.bad_vsync.cliptop;
    var spr_clipbot = sprite_height - msg_unsafe_effects.bad_vsync.clipbot;
    var pos_x = x - scale*sprite_xoffset + draw_x;
    var pos_y = y - scale*sprite_yoffset + draw_y;

    var mid_cliptop = spr_cliptop;
    var mid_sprite = sprite_index;
    var mid_scale = scale;
    var mid_width = spr_w;
    var mid_posx = msg_unsafe_effects.bad_vsync.horz + pos_x;
    var mid_clipheight = spr_clipbot - spr_cliptop;

    if (msg_unsafe_effects.bad_vsync.garbage)
    {
        //middle bit borrowed from unrelated sprite
        mid_sprite = msg_unsafe_garbage.spr;
        mid_scale = msg_unsafe_garbage.scale;
        mid_width = msg_unsafe_garbage.width;
        mid_posx -= (spr_dir*mid_scale*msg_unsafe_garbage.x_offset - scale*sprite_xoffset);
        mid_clipheight *= (scale/mid_scale);
        mid_cliptop += (msg_unsafe_garbage.y_offset - sprite_yoffset)
    }
    
    if (main_draw) shader_start();
    //draw_sprite_part_ext(sprite,subimg,left,top,width,height,x,y,xscale,yscale,colour,alpha)
    draw_sprite_part_ext(sprite_index, image_index, 0, 0, spr_w, spr_cliptop, 
                         pos_x, pos_y, spr_dir * scale, scale, c_white, 1.0);
    draw_sprite_part_ext(mid_sprite, image_index, 0, mid_cliptop, mid_width, mid_clipheight, 
                         mid_posx, pos_y + spr_cliptop*scale, spr_dir * mid_scale, mid_scale, c_white, 1.0);
    draw_sprite_part_ext(sprite_index, image_index, 0, spr_clipbot, spr_w, max(sprite_height - spr_clipbot, 0), 
                         pos_x, pos_y + spr_clipbot*scale, spr_dir * scale, scale, c_white, 1.0);
    if (main_draw) shader_end();

    skips_draw = main_draw;
}
//===========================================================
// REDRAW EFFECT: QUADRANT
// sprite split in four corners, then rearranged
else if (msg_unsafe_effects.quadrant.timer > 0)
{
    var ofx = abs(sprite_xoffset);
    var ofy = abs(sprite_yoffset);
    var bbt = sprite_get_bbox_top(sprite_index);
    var bbl = sprite_get_bbox_left(sprite_index);
    var bbr = sprite_get_bbox_right(sprite_index);
    var bbb = sprite_get_bbox_bottom(sprite_index);
    
    //centerpoint of sprite quad division
    var half_h = min((ofy - bbt)*scale, char_height) / 2; //realspace
    var c_y = ofy - half_h/scale; //spritespace

    // 0 1
    // 2 3
    var q = [noone, noone, noone, noone];
    q[0]={spr:sprite_index, ind:image_index, x:bbl, y:bbt, w:(ofx - bbl), h:(c_y - bbt) };
    q[1]={spr:sprite_index, ind:image_index, x:ofx, y:bbt, w:(bbr - ofx), h:(c_y - bbt) };
    q[2]={spr:sprite_index, ind:image_index, x:bbl, y:c_y, w:(ofx - bbl), h:(bbb - c_y) };
    q[3]={spr:sprite_index, ind:image_index, x:ofx, y:c_y, w:(bbr - ofx), h:(bbb - c_y) };


    //draw_line_color(x - (ofx - bbl)*scale, y - half_h, x + (bbr - ofx)*scale, y - half_h, c_white, c_white)
    //draw_line_color(x, y - half_h - half_h, x, y - half_h + half_h, c_white, c_white)

    if (main_draw) shader_start();
    //draw_sprite_part_ext(sprite,subimg,left,top,width,height,x,y,xscale,yscale,colour,alpha)
    
    var s = msg_unsafe_effects.quadrant.source[0];
    draw_sprite_part_ext(q[s].spr, q[s].ind, q[s].x, q[s].y, q[s].w, q[s].h, 
                         x +draw_x - q[s].w*scale*spr_dir, y +draw_y - half_h - q[s].h*scale, 
                         spr_dir * scale, scale, c_white, 1.0);
    
    s = msg_unsafe_effects.quadrant.source[1];
    draw_sprite_part_ext(q[s].spr, q[s].ind, q[s].x, q[s].y, q[s].w, q[s].h, 
                         x +draw_x, y +draw_y - half_h - q[s].h*scale, 
                         spr_dir * scale, scale, c_white, 1.0);
    
    s = msg_unsafe_effects.quadrant.source[2];
    draw_sprite_part_ext(q[s].spr, q[s].ind, q[s].x, q[s].y, q[s].w, q[s].h, 
                         x +draw_x - q[s].w*scale*spr_dir, y +draw_y - half_h, 
                         spr_dir * scale, scale, c_white, 1.0);
    
    s = msg_unsafe_effects.quadrant.source[3];
    draw_sprite_part_ext(q[s].spr, q[s].ind, q[s].x, q[s].y, q[s].w, q[s].h, 
                         x +draw_x, y +draw_y - half_h, 
                         spr_dir * scale, scale, c_white, 1.0);
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
