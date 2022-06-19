//other_pre_draw.gml
if ("other_player_id" not in self) exit;

//===============================================================================
if (marked && marked_player == other_player_id.player) with (other_player_id)
{
    //Draw on behalf of Maypuls everywhere
    shader_start();
    var width = 40;
    draw_sprite(asset_get("fer_leaf_spr"), 1, other.x + width - 2 * (get_gameplay_time() % width), other.y - 20);
    shader_end();
}


//===============================================================================
if ("msg_unsafe_handler_id" in self && other_player_id == msg_unsafe_handler_id)
{
    //backup draw params (restored in post_draw)
    msg_copy_params(self, msg_anim_backup, msg_anim_backup);

    //Get your random effects recalculated
    msg_apply_effects();

    msg_manual_draw();
}

// #region vvv LIBRARY DEFINES AND MACROS vvv
// DANGER File below this point will be overwritten! Generated defines and macros below.
// Write NO-INJECT in a comment above this area to disable injection.
#define msg_manual_draw // Version 0
    // / msg_manual_draw(main_draw = true)
    // Handles REDRAW-type effects that need to draw differently than usual
    var main_draw = argument_count > 0 ? argument[0] : true;
    var skips_draw = false; //determines if the actual draw event needs to be interrupted

    var scale = 1 + small_sprites;


    //===========================================================
    //effect type: REDRAW
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
    // Effects:    Frequency uses:
    //  - Shudder                                        FFFFFF VVVVHHHH
    //  - VSync                               GGFFFFFF BBBBBBBB TTTTHHHH
    //  - wrong image_index
    //'M- garbage collector          P4P3P2P1                    EEEEFF
    //  - trail
    //===================================================================

    //===========================================================
    //effect type: DRAW PARAMETER
    var fx = msg_unsafe_effects.shudder;
    if (fx.timer > 0 || fx.freq > GET_RNG(8, 0x3F))
    {
        fx.timer -= (fx.timer > 0);

        draw_x += (fx.impulse ? fx.timer : 1) * fx.horz_max * GET_INT(0, 0x0F, true);
        draw_y += (fx.impulse ? fx.timer : 1) * fx.vert_max * GET_INT(4, 0x0F, true);
    }
    else fx.impulse = false;
    //===========================================================
    //effect type: REDRAW
    var fx = msg_unsafe_effects.bad_vsync;
    if (fx.timer > 0)
    {
        fx.timer -= 1;
    }
    if (fx.freq > GET_RNG(16, 0x3F))
    {
        fx.timer = 5;

        fx.clipbot = floor(GET_INT(8, 0xFF) * sprite_height/2)
        fx.cliptop = fx.clipbot + GET_INT(4, 0x0F) * sprite_height/2;
        fx.horz = fx.horz_max * 2 * GET_INT(0, 0x0F, true);
        fx.garbage = (2 > GET_RNG(22, 0x07));
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