
//===========================================================
#define msg_background_draw
/// msg_manual_draw(bg_spr, bg_index, bg_x = draw_x, bg_y = draw_y)
var bg_spr = argument[0];
var bg_index = argument[1];
var bg_x = argument_count > 2 ? argument[2] : draw_x;
var bg_y = argument_count > 3 ? argument[3] : draw_y;
// Draws the masked Missingno-patterned unmoving plaid background
//considers:
// - Current sprite
// - REDRAW effects (special mention to CRT)
// - Copies of self
// - Yoyo vfx

msg_gpu_push_state();
//====================
///Disable blend; write alpha only, don't alphatest
gpu_set_blendenable(false);
gpu_set_alphatestenable(false);
var cw = gpu_get_colorwriteenable();
gpu_set_colorwriteenable(false, false, false, true);
///Draw an alpha-zero background as a base "no draw" zone
draw_set_alpha(0);
draw_sprite_tiled(glitch_bg_spr, 0, 0, 0);
draw_set_alpha(1);
gpu_set_alphatestenable(true);

//====================
//setup masks

// (exact position/sprite of player)
msg_manual_draw(false);

//copies of this player
msg_draw_clones()

// yoyo stretch fx
if (vfx_yoyo_snap.timer > 0)
{
    draw_sprite_ext(vfx_yoyo_snap.spr, (8 - vfx_yoyo_snap.timer)/2, 
    vfx_yoyo_snap.x, vfx_yoyo_snap.y, (vfx_yoyo_snap.length/128.0), 2, vfx_yoyo_snap.angle, c_white, 1);
}

//trail fxs
for (var n = 0; n < msg_unsafe_trail_max; ++n) 
{
    var trail = msg_unsafe_trail[n];
    if (trail.x != 0) draw_rectangle_color(trail.x, trail.y, trail.x + trail.w, trail.y + trail.h, 
                                           c_white, c_white, c_white, c_white, false);
}

//====================
///Reenable blend, alphatest & colors
gpu_set_blendenable(true);
///Blend using destination pixels alpha, set by the mask
gpu_set_blendmode_ext(bm_dest_alpha, bm_inv_dest_alpha);
gpu_set_colorwriteenable(1, 1, 1, 1);
draw_rectangle_color(0,0, room_width, room_height, c_black, c_black, c_black, c_black, false);
gpu_set_colorwriteenable(cw[0], cw[1], cw[2], cw[3]);

//====================
///draw the masked "background"
//cannot shade -- kills performance... 
//uses preshaded backgrounds for this purpose
if (msg_unsafe_effects.crt.timer > 0)
{
    var crt_offset = msg_unsafe_effects.crt.offset;
    gpu_set_colorwriteenable(false, cw[1], cw[2], cw[3]); //R
    draw_sprite_tiled_ext(bg_spr, bg_index, bg_x - crt_offset, bg_y, 2, 2, c_white, 1);
    gpu_set_colorwriteenable(cw[0], false, false, cw[3]); //GB
    draw_sprite_tiled_ext(bg_spr, bg_index, bg_x + crt_offset, bg_y, 2, 2, c_white, 1);
}
else draw_sprite_tiled_ext(bg_spr, bg_index, bg_x, bg_y, 2, 2, c_white, 1);

//====================
//playtest zone fix (or unfix...?)
///Disable blend; write alpha only, don't alphatest
gpu_set_blendenable(false);
gpu_set_alphatestenable(false);
gpu_set_colorwriteenable(false, false, false, true);
///Draw an alpha-one background to reallow draw
draw_sprite_tiled(glitch_bg_spr, 0, 0, 0);

//====================
msg_gpu_pop_state();
//Function end

//===========================================================
#define msg_manual_draw
/// msg_manual_draw(main_draw = true)
//Handles REDRAW-type effects that need to draw differently than usual
//also reused for clone's draws and glitch-bg draws
var main_draw = argument_count > 0 ? argument[0] : true; //FALSE when rendering the glitch BG
var skips_draw = false; //determines if the actual draw event needs to be prevented

var scale = 1 + small_sprites;
var g = msg_unsafe_garbage;

//===========================================================
// REDRAW EFFECT: VSYNC
// sprite trisected vertically, middle displaced
if (msg_unsafe_effects.bad_vsync.timer > 0)
{
    var spr_w = abs(sprite_width); //why is this necessary !?
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
        mid_sprite = g.spr;
        mid_scale = g.scale;
        mid_width = g.width;
        mid_posx -= (spr_dir*mid_scale*g.x_offset - scale*sprite_xoffset);
        mid_clipheight *= (scale/mid_scale);
        mid_cliptop += (g.y_offset - sprite_yoffset)
    }
    
    //draw_sprite_part_ext(sprite,subimg,left,top,width,height,x,y,xscale,yscale,colour,alpha)
    draw_sprite_part_ext(sprite_index, image_index, 0, 0, spr_w, spr_cliptop, 
                         pos_x, pos_y, spr_dir * scale, scale, c_white, image_alpha);
    draw_sprite_part_ext(mid_sprite, image_index, 0, mid_cliptop, mid_width, mid_clipheight, 
                         mid_posx, pos_y + spr_cliptop*scale, spr_dir * mid_scale, mid_scale, c_white, image_alpha);
    draw_sprite_part_ext(sprite_index, image_index, 0, spr_clipbot, spr_w, max(sprite_height - spr_clipbot, 0), 
                         pos_x, pos_y + spr_clipbot*scale, spr_dir * scale, scale, c_white, image_alpha);

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
    var half_h = min((ofy - bbt)*scale, char_height) / 2; //realspace (used for draw pos)
    var c_y = ofy - half_h/scale; //spritespace (used for sprite source cropping)

    //garbage variables
    var gofx = abs(g.x_offset);
    var gofy = abs(g.y_offset);
    var gbt = sprite_get_bbox_top(g.spr);
    var gbl = sprite_get_bbox_left(g.spr);
    var gbr = sprite_get_bbox_right(g.spr);
    var gbb = sprite_get_bbox_bottom(g.spr);
    var gcy = gofy - half_h/g.scale; //spritespace (used for sprite source cropping)

    // 0 1
    // 2 3
    var q = [noone, noone, noone, noone];
    q[0]=msg_unsafe_effects.quadrant.garbage[0] ? 
         {scale:g.scale, spr:g.spr,        ind:image_index, x:gbl, y:gbt, w:(gofx- gbl), h:(gcy - gbt) }:
         {scale:scale,   spr:sprite_index, ind:image_index, x:bbl, y:bbt, w:(ofx - bbl), h:(c_y - bbt) };
    q[1]=msg_unsafe_effects.quadrant.garbage[1] ? 
         {scale:g.scale, spr:g.spr,        ind:image_index, x:gofx,y:gbt, w:(gbr -gofx), h:(gcy - gbt) }:
         {scale:scale,   spr:sprite_index, ind:image_index, x:ofx, y:bbt, w:(bbr - ofx), h:(c_y - bbt) };
    q[2]=msg_unsafe_effects.quadrant.garbage[2] ? 
         {scale:g.scale, spr:g.spr,        ind:image_index, x:gbl, y:gcy, w:(gofx- gbl), h:(gbb - gcy) }:
         {scale:scale,   spr:sprite_index, ind:image_index, x:bbl, y:c_y, w:(ofx - bbl), h:(bbb - c_y) };
    q[3]=msg_unsafe_effects.quadrant.garbage[3] ? 
         {scale:g.scale, spr:g.spr,        ind:image_index, x:gofx,y:gcy, w:(gbr -gofx), h:(gbb - gcy) }:
         {scale:scale,   spr:sprite_index, ind:image_index, x:ofx, y:c_y, w:(bbr - ofx), h:(bbb - c_y) };

    //draw_line_color(x - (ofx - bbl)*scale, y - half_h, x + (bbr - ofx)*scale, y - half_h, c_white, c_white)
    //draw_line_color(x, y - half_h - half_h, x, y - half_h + half_h, c_white, c_white)

    //draw_sprite_part_ext(sprite,subimg,left,top,width,height,x,y,xscale,yscale,colour,alpha)
    
    var s = msg_unsafe_effects.quadrant.source[0];
    draw_sprite_part_ext(q[s].spr, q[s].ind, q[s].x, q[s].y, q[s].w, q[s].h, 
                         x +draw_x - q[s].w*q[s].scale*spr_dir, y +draw_y - half_h - q[s].h*q[s].scale, 
                         spr_dir * q[s].scale, q[s].scale, c_white, image_alpha);
    
    s = msg_unsafe_effects.quadrant.source[1];
    draw_sprite_part_ext(q[s].spr, q[s].ind, q[s].x, q[s].y, q[s].w, q[s].h, 
                         x +draw_x, y +draw_y - half_h - q[s].h*q[s].scale, 
                         spr_dir * q[s].scale, q[s].scale, c_white, image_alpha);
    
    s = msg_unsafe_effects.quadrant.source[2];
    draw_sprite_part_ext(q[s].spr, q[s].ind, q[s].x, q[s].y, q[s].w, q[s].h, 
                         x +draw_x - q[s].w*q[s].scale*spr_dir, y +draw_y - half_h, 
                         spr_dir * q[s].scale, q[s].scale, c_white, image_alpha);
    
    s = msg_unsafe_effects.quadrant.source[3];
    draw_sprite_part_ext(q[s].spr, q[s].ind, q[s].x, q[s].y, q[s].w, q[s].h, 
                         x +draw_x, y +draw_y - half_h, 
                         spr_dir * q[s].scale, q[s].scale, c_white, image_alpha);

    skips_draw = main_draw;
}
//===========================================================
// REDRAW EFFECT: BAD_STRIP
// sprite split vertically as if (n+1) was the strip number given
else if (msg_unsafe_effects.bad_strip.timer > 0)
{
    var num_img = sprite_get_number(sprite_index);
    var spr_w = abs(sprite_width); //why is this necessary !?

    var clamped_index = floor(image_index % num_img);
    var crop_step = floor(spr_w / (num_img + 1));
    var crop_total = crop_step * clamped_index;
    var pos_x = x + draw_x  - scale* (sprite_xoffset - crop_step*sign(spr_dir)*0.5);
    var pos_y = y - scale*sprite_yoffset + draw_y;

    if (clamped_index > 0)
    {   //slice of previous image
        draw_sprite_part_ext(sprite_index, clamped_index-1, spr_w - crop_total, 0, crop_total, sprite_height, 
                             pos_x, pos_y, spr_dir * scale, scale, c_white, image_alpha);
    }
    //current image, sliced
    draw_sprite_part_ext(sprite_index, clamped_index, 0, 0, spr_w - crop_total - crop_step, sprite_height, 
                         pos_x + scale*spr_dir*crop_total, pos_y, spr_dir * scale, scale, c_white, image_alpha);

    skips_draw = main_draw;
}
//===========================================================
// REDRAW EFFECT: CRT
// sprite R/G/B misaligned
else if (msg_unsafe_effects.crt.timer > 0)
{
    var crt_offset = msg_unsafe_effects.crt.offset;

    gpu_set_colorwriteenable(false, true, true, true); //R
    draw_sprite_ext(sprite_index, image_index, x+draw_x-crt_offset, y+draw_y, 
                    scale*spr_dir, scale, spr_angle, c_white, image_alpha);

    gpu_set_colorwriteenable(true, false, false, true); //GB
    draw_sprite_ext(sprite_index, image_index, x+draw_x+crt_offset, y+draw_y, 
                    scale*spr_dir, scale, spr_angle, c_white, image_alpha);

    gpu_set_colorwriteenable(true, true, true, true);

    skips_draw = main_draw;
}
//===========================================================
// Normal draw (needed by glitch BG)
else if (!main_draw) 
     //changing small_sprites in pre_draw does not affect regular draw code.
     || (small_sprites != msg_anim_backup.small_sprites)
     //requires an extra pass to draw in negative colors
     || ((msg_unsafe_effects.blending.timer > 0) && (msg_unsafe_effects.blending.kind == 0))
{
    draw_sprite_ext(sprite_index, image_index, x+draw_x, y+draw_y, 
                    scale*spr_dir, scale, spr_angle, c_white, image_alpha);
    
    skips_draw = main_draw;
}
//===========================================================

// to turn off normal rendering for this frame
if (skips_draw) sprite_index = asset_get("empty_sprite");


//===========================================================
#define msg_draw_clones()
//Draws every clone you own
with (obj_article2) if ("is_missingno_copy" in self)
                    && (client_id == other)
{
    var cl_scale = (1 + other.small_sprites);
    var cl_alpha = (state == 2 ? 0.5 : 1);
    if (state == 0) 
    {
        cl_scale *= floor(state_timer/5) * 0.25;
        with (other) draw_sprite_ext(sprite_index, image_index, other.x, other.y, cl_scale*spr_dir, cl_scale, 0, c_white, cl_alpha)
    }
    else with (other)
    {
        var temp = msg_unsafe_effects.quadrant.timer;
        if (other.is_clone_broken) msg_unsafe_effects.quadrant.timer = 1;
        draw_x += other.client_offset_x;
        draw_y += other.client_offset_y;
        image_alpha = cl_alpha;

        msg_manual_draw(false);

        image_alpha = 1;
        msg_unsafe_effects.quadrant.timer = temp;
        draw_x -= other.client_offset_x;
        draw_y -= other.client_offset_y;
    }
}


//===========================================================
#define msg_copy_params(source, target, limiter)
//Usage: for all variables in LIMITER: copy value from SOURCE to TARGET
var keys = variable_instance_get_names(limiter)
for (var k = 0; k < array_length(keys); k++)
{
    variable_instance_set(target, keys[k], 
                            variable_instance_get(source, keys[k]));
}

//===========================================================
#define msg_set_glitchbg_alpha(new_alpha)
{
    colorO[7*4 + 3] = new_alpha;
    colorO[6*4 + 3] = new_alpha;
    colorO[5*4 + 3] = new_alpha;
    colorO[4*4 + 3] = new_alpha;
    static_colorO[7*4 + 3] = new_alpha;
    static_colorO[6*4 + 3] = new_alpha;
    static_colorO[5*4 + 3] = new_alpha;
    static_colorO[4*4 + 3] = new_alpha;
}

//===========================================================
#define msg_prep_negative_draw()
if (msg_unsafe_effects.blending.timer > 0) && (msg_unsafe_effects.blending.kind == 0)
{
    msg_negative_sprite_save = sprite_index;
    msg_negative_image_save = image_index;
}

#define msg_negative_draw()
if (msg_unsafe_effects.blending.timer > 0) && (msg_unsafe_effects.blending.kind == 0)
{
    //Special draw step to make the blendmode draw a inverse-source-color sprite
    gpu_set_fog(true, c_white, 1, 1);
    gpu_set_blendmode_ext(bm_inv_dest_color, bm_inv_src_alpha);
    sprite_index = msg_negative_sprite_save;
    image_index = msg_negative_image_save;
    msg_draw_clones();
    msg_manual_draw(false);
    sprite_index = asset_get("empty_sprite");
    gpu_set_blendmode(bm_normal);
}

//===========================================================
#define msg_draw_parry_fx()
if (msg_fakeout_parry_timer > 0)
{
    if (msg_fakeout_parry_timer > 20)
    {
        draw_sprite_ext(vfx_parry_bg, (38 - msg_fakeout_parry_timer)/3, 
                        x, y-32, 2, 2, 0, c_white, 0.5);
        draw_sprite_ext(vfx_parry_fg, 0, x, y, 1, 1, 0, c_white, 1);
    }
    else
    {
        draw_sprite_ext(vfx_parry_fg, (20 - msg_fakeout_parry_timer)/5, 
                        x, y, 1, 1, 0, c_white, 1);
    }
}


//===================================================
//GPU stack helpers
//Use these to avoid bitter debug sessions
#define msg_gpu_push_state()
    gpu_push_state(); msg_unsafe_gpu_stack_level++;

#define msg_gpu_pop_state()
if (msg_unsafe_gpu_stack_level > 0)
{
    gpu_pop_state(); msg_unsafe_gpu_stack_level--;
}

#define msg_gpu_clear()
while (msg_unsafe_gpu_stack_level > 0)
{
    gpu_pop_state(); msg_unsafe_gpu_stack_level--;
}