//pre_draw.gml

//==================================================================
//playing sounds (needs to happen here so it works when pausing)
if (msg_grab_selected_index >= 0)
{
    suppress_stage_music(0, 1);
}


//==================================================================
//Leech seed healy bits
for (var i = 0; i < msg_leechseed_particle_number; i++)
{
    var temp_part = msg_leechseed_particles[i];
    if (temp_part.timer > 0)
    {
        ////uses subimages [9, 14]
        draw_sprite(vfx_healing, 9 + (i % 6), temp_part.x, temp_part.y);
    }
}

if (!msg_low_fps_mode)
{
    //==================================================================
    // GLITCH-FX BEYOND THIS POINT
    //==================================================================
    // back up drawing-related parameters that can get fiddled with
    //todo: move to animation.gml?
    msg_copy_params(self, msg_anim_backup, msg_anim_backup);
    
    // Reroll Missingno effects
    msg_apply_effects();

    //glitch trail
    var trail = msg_unsafe_trail[msg_unsafe_trail_pointer];
    trail.w = msg_unsafe_trail_active ? 8 + GET_RNG(20, 0x0F) : 0;
    trail.h = msg_unsafe_trail_active ? 8 + GET_RNG(16, 0x0F) : 0;
    trail.x = msg_unsafe_trail_active ? x + draw_x - 16 + GET_RNG(8, 0x1F) - (trail.w/2) : 0;
    trail.y = msg_unsafe_trail_active ? y + draw_y - 16 - GET_RNG(2, 0x1F) - (trail.h/2) : 0;
    msg_unsafe_trail_pointer = (msg_unsafe_trail_pointer + 1) % msg_unsafe_trail_max;

    // Plaid effect
    msg_background_draw(glitch_bg_spr, get_player_color(player))

    //might need to override normal draw code
    msg_manual_draw(true);
}

if (vfx_yoyo_snap.timer > 0)
{
    if (msg_low_fps_mode)
    {
        //yoyo glitch trail visible even with plaid bg disabled
        shader_start();
        draw_sprite_ext(vfx_yoyo_snap.spr, (8 - vfx_yoyo_snap.timer)/2, 
        vfx_yoyo_snap.x, vfx_yoyo_snap.y, (vfx_yoyo_snap.length/128.0), 2, vfx_yoyo_snap.angle, c_white, 1);
        shader_end();
    }

    vfx_yoyo_snap.timer --;
}

// #region vvv LIBRARY DEFINES AND MACROS vvv
// DANGER File below this point will be overwritten! Generated defines and macros below.
// Write NO-INJECT in a comment above this area to disable injection.
#define msg_background_draw(bg_spr, bg_index) // Version 0
    // Draws the masked Missingno-patterned unmoving plaid background
    // considers:
    // - Current sprite
    // - REDRAW effects (special mention to CRT)
    // - Copies of self
    // - Yoyo vfx

    msg_gpu_push_state();
    //====================
    ///Disable blend; write alpha only, don't alphatest
    gpu_set_blendenable(false);
    gpu_set_alphatestenable(false);
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
    with (obj_article2) if ("is_missingno_copy" in self) && (client_id == other)
    {
        var bg_scale = (1 + other.small_sprites);
        if (state == 0) bg_scale *= floor(state_timer/5) * 0.25;
        var bg_alpha = (state == 2 ? 0.5 : 1);
        with (other) draw_sprite_ext(sprite_index, image_index, other.x, other.y, bg_scale*spr_dir, bg_scale, 0, c_white, bg_alpha);
    }

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
    gpu_set_colorwriteenable(true, true, true, true);
    ///Blend using destination pixels alpha, set by the mask
    gpu_set_blendmode_ext(bm_dest_alpha, bm_inv_dest_alpha);

    //====================
    ///draw the masked "background"
    //cannot shade -- kills performance...
    //uses preshaded backgrounds for this purpose
    if (msg_unsafe_effects.crt.timer > 0)
    {
        var crt_offset = msg_unsafe_effects.crt.offset;
        gpu_set_colorwriteenable(false, true, true, true); //R
        draw_sprite_tiled_ext(bg_spr, bg_index, draw_x - crt_offset, draw_y, 2, 2, c_white, 1);
        gpu_set_colorwriteenable(true, false, false, true); //GB
        draw_sprite_tiled_ext(bg_spr, bg_index, draw_x + crt_offset, draw_y, 2, 2, c_white, 1);
        gpu_set_colorwriteenable(true, true, true, true);
    }
    else draw_sprite_tiled_ext(bg_spr, bg_index, draw_x, draw_y, 2, 2, c_white, 1);

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

#define msg_manual_draw // Version 0
    // / msg_manual_draw(main_draw = true)
    // Handles REDRAW-type effects that need to draw differently than usual
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
        q[3]=msg_unsafe_effects.quadrant.garbage[2] ?
             {scale:g.scale, spr:g.spr,        ind:image_index, x:gofx,y:gcy, w:(gbr -gofx), h:(gbb - gcy) }:
             {scale:scale,   spr:sprite_index, ind:image_index, x:ofx, y:c_y, w:(bbr - ofx), h:(bbb - c_y) };

        //draw_line_color(x - (ofx - bbl)*scale, y - half_h, x + (bbr - ofx)*scale, y - half_h, c_white, c_white)
        //draw_line_color(x, y - half_h - half_h, x, y - half_h + half_h, c_white, c_white)

        if (main_draw) shader_start();
        //draw_sprite_part_ext(sprite,subimg,left,top,width,height,x,y,xscale,yscale,colour,alpha)

        var s = msg_unsafe_effects.quadrant.source[0];
        draw_sprite_part_ext(q[s].spr, q[s].ind, q[s].x, q[s].y, q[s].w, q[s].h,
                             x +draw_x - q[s].w*q[s].scale*spr_dir, y +draw_y - half_h - q[s].h*q[s].scale,
                             spr_dir * q[s].scale, q[s].scale, c_white, 1.0);

        s = msg_unsafe_effects.quadrant.source[1];
        draw_sprite_part_ext(q[s].spr, q[s].ind, q[s].x, q[s].y, q[s].w, q[s].h,
                             x +draw_x, y +draw_y - half_h - q[s].h*q[s].scale,
                             spr_dir * q[s].scale, q[s].scale, c_white, 1.0);

        s = msg_unsafe_effects.quadrant.source[2];
        draw_sprite_part_ext(q[s].spr, q[s].ind, q[s].x, q[s].y, q[s].w, q[s].h,
                             x +draw_x - q[s].w*q[s].scale*spr_dir, y +draw_y - half_h,
                             spr_dir * q[s].scale, q[s].scale, c_white, 1.0);

        s = msg_unsafe_effects.quadrant.source[3];
        draw_sprite_part_ext(q[s].spr, q[s].ind, q[s].x, q[s].y, q[s].w, q[s].h,
                             x +draw_x, y +draw_y - half_h,
                             spr_dir * q[s].scale, q[s].scale, c_white, 1.0);
        if (main_draw) shader_end();

        skips_draw = main_draw;
    }
    //===========================================================
    // REDRAW EFFECT: CRT
    // sprite R/G/B misaligned
    else if (msg_unsafe_effects.crt.timer > 0)
    {
        if (main_draw) shader_start();
        var crt_offset = msg_unsafe_effects.crt.offset;

        gpu_set_colorwriteenable(false, true, true, true); //R
        draw_sprite_ext(sprite_index, image_index, x+draw_x-crt_offset, y+draw_y,
                        scale*spr_dir, scale, spr_angle, c_white, 1);

        gpu_set_colorwriteenable(true, false, false, true); //GB
        draw_sprite_ext(sprite_index, image_index, x+draw_x+crt_offset, y+draw_y,
                        scale*spr_dir, scale, spr_angle, c_white, 1);

        gpu_set_colorwriteenable(true, true, true, true);
        if (main_draw) shader_end();

        skips_draw = main_draw;
    }
    //===========================================================
    // Normal draw (needed by glitch BG)
    else if (!main_draw) || (small_sprites != msg_anim_backup.small_sprites)
    {
        //note: the small_sprites clause is there because changing
        //      it in pre_draw does not affect regular draw code.
        if (main_draw) shader_start();
        draw_sprite_ext(sprite_index, image_index, x+draw_x, y+draw_y,
                        scale*spr_dir, scale, spr_angle, c_white, 1);
        if (main_draw) shader_end();

        skips_draw = main_draw;
    }
    //===========================================================

    // to turn off normal rendering for this frame
    if (skips_draw) sprite_index = asset_get("empty_sprite");

#define msg_gpu_push_state // Version 0
    gpu_push_state(); msg_unsafe_gpu_stack_level++;

#define msg_gpu_pop_state // Version 0
    if (msg_unsafe_gpu_stack_level > 0)
    {
        gpu_pop_state(); msg_unsafe_gpu_stack_level--;
    }

#define msg_copy_params(source, target, limiter) // Version 0
    // Usage: for all variables in LIMITER: copy value from SOURCE to TARGET
    var keys = variable_instance_get_names(limiter)
    for (var k = 0; k < array_length(keys); k++)
    {
        variable_instance_set(target, keys[k],
                                variable_instance_get(source, keys[k]));
    }

#define msg_apply_effects // Version 0
    // aka. unsafe_animation.gml
    // placed in pre_draw (runs on draw frames)

    //essential for rendering-random checks.
    if ("msg_unsafe_random" not in self) return;

    msg_reroll_random();

    //special msg_is_missingno-only effects are denoted 'M
    //===================================================================
    // BITWISE RANDOM UINT32 MAP = 0x00000000 00000000 00000000 00000000
    // Effects:    Frequency uses: .
    //  - Shudder                  .                   ttffffff VVVVHHHH
    //  - VSync                    .       tt GGffffff BBBBBBBB TTTTHHHH
    //  - Quadrant                 .             tttff ffffGGSS 22GGSS11
    //  - CRT                      .                OO OOOO  tt ffff
    //  - wrong image_index
    //'M- garbage collector        . P4P3P2P1                    EEEEFF
    //  - trail
    //'M- gaslit dodge             .                         FF FF
    //'M- glitch trail             .          wwwwhhhh   xxxxxx  yyyyy
    //'M- Alt Sprites              .     FFFF FFFF        NNN
    //===================================================================
    // Also see animation.gml, set_attack.gml


    //===========================================================
    //effect: SHUDDER, type: DRAW PARAMETER
    var fx = msg_unsafe_effects.shudder
    {
        if (fx.impulse > 0) || (fx.freq > GET_RNG(8, 0x3F))
        {
            fx.impulse -= (fx.impulse > 0);
            //reroll parameters
            fx.timer = 2 * GET_INT(14, 0x03);
        }
        if (fx.timer > 0)
        {
            fx.timer -= !fx.frozen;
            //apply
            draw_x += max(fx.impulse , 1) * fx.horz_max * GET_INT(0, 0x0F, true);
            draw_y += max(fx.impulse , 1) * fx.vert_max * GET_INT(4, 0x0F, true);
        }
    }
    //===========================================================
    //effect: VSYNC, type: REDRAW
    var fx = msg_unsafe_effects.bad_vsync
    {
        if (fx.impulse > 0) || (fx.freq > GET_RNG(16, 0x3F))
        {
            fx.impulse -= (fx.impulse > 0);
            //reroll parameters
            fx.timer = 4 + GET_RNG(22, 0x03);

            fx.clipbot = floor(GET_INT(8, 0xFF) * sprite_height/2)
            fx.cliptop = fx.clipbot + GET_INT(4, 0x0F) * sprite_height/2;
            fx.horz = fx.horz_max * max(fx.impulse / 2 , 2) * GET_INT(0, 0x0F, true);
            fx.garbage = (2 > GET_RNG(22, 0x07));
        }
        if (fx.timer > 0)
        {
            fx.timer -= !fx.frozen;
            //apply
        }
    }
    //===========================================================
    //effect: QUADRANT, type: REDRAW
    var fx = msg_unsafe_effects.quadrant
    {
        if (fx.impulse > 0) || (fx.freq > GET_RNG(12, 0x3F))
        {
            fx.source[0]  = 0; fx.source[1]  = 1; fx.source[2]  = 2; fx.source[3]  = 3;
            fx.garbage[0] = 0; fx.garbage[1] = 0; fx.garbage[2] = 0; fx.garbage[3] = 0;

            fx.impulse -= (fx.impulse > 0);
            //reroll parameters
            fx.timer = 4 + GET_RNG(18, 0x07);

            //roll twice for sector corruption
            var sector = GET_RNG(0, 0x03);
            fx.source[sector] = GET_RNG(2, 0x03);
            fx.garbage[sector] = (0 == GET_RNG(4, 0x03));

            sector = GET_RNG(6, 0x03);
            fx.source[sector] = GET_RNG(8, 0x03);
            fx.garbage[sector] = (0 == GET_RNG(10, 0x03));
        }
        if (fx.timer > 0)
        {
            fx.timer -= !fx.frozen;
            //apply
        }
    }
    //===========================================================
    //effect: CRT, type: REDRAW
    var fx = msg_unsafe_effects.crt
    {
        if (fx.impulse > 0) || (fx.freq > GET_RNG(4, 0x0F))
        {
            fx.impulse -= (fx.impulse > 0);
            //reroll parameters
            fx.timer = 4 + GET_RNG(8, 0x03);

            fx.offset = floor(GET_INT(12, 0x3F) * fx.maximum);
        }
        if (fx.timer > 0)
        {
            fx.timer -= !fx.frozen;
            //apply
        }
    }

#define msg_reroll_random // Version 0
    // reroll msg_unsafe_random

    //DEBUG utility
    var debug_pass = false;
    if (string_count("*", keyboard_string)) { keyboard_string = ""; debug_pass = true; }
    msg_unsafe_paused_timer |= (keyboard_lastchar == '*');

    //xorshift algorithm
    if (msg_unsafe_paused_timer <= 0 || debug_pass)
    {
        var UINT_MAX = 0xFFFFFFFF;
        var rng = msg_unsafe_random;

        rng = (rng ^(rng << 13)) % UINT_MAX;
        rng = (rng ^(rng >> 17)) % UINT_MAX;
        rng = (rng ^(rng << 5 )) % UINT_MAX;

        msg_unsafe_random = rng;
    }

#define GET_RNG(offset, mask) // Version 0
    // ===========================================================
    // returns a random number from the seed by using the mask.
    // uses "msg_unsafe_random" implicitly.
    return (mask <= 0) ? 0
           :((msg_unsafe_random >> offset) & mask);

#define GET_INT // Version 0
    // ===========================================================
    // returns an intensity for the effect, between 0 and 1.
    // if centered is true, this will be between -0.5 and +0.5 instead.
    // uses "msg_unsafe_random" implicitly.
    var offset = argument[0], mask = argument[1];
    var centered = argument_count > 2 ? argument[2] : false;
    return (mask <= 0) ? 0
           : ((msg_unsafe_random >> offset) & mask) * (1.0/mask) - (centered * 0.5);
// DANGER: Write your code ABOVE the LIBRARY DEFINES AND MACROS header or it will be overwritten!
// #endregion