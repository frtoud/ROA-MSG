
#define msg_apply_effects()
//aka. unsafe_animation.gml

//essential for rendering-random checks.
if ("msg_unsafe_random" not in self) return;

//===================================================================
// BITWISE RANDOM UINT32 MAP = 0x00000000 00000000 00000000 00000000
// Effects:    Frequency uses: 
//  - Shudder                                        FFFFFF VVVVHHHH
//  - VSync                                 FFFFFF BBBBBBBB TTTTHHHH
//  - wrong image_index
//'M- wrong sprite_index
//  - trail
//===================================================================

//===========================================================
//effect type: DRAW PARAMETER
var fx = msg_unsafe_effects.shudder;
if (fx.timer > 0 || fx.freq > GET_RNG(8, 0x3F))
{
    fx.timer -= (fx.timer > 0);

    draw_x += fx.horz_max * GET_INT(0, 0x0F, true);
    draw_y += fx.vert_max * GET_INT(4, 0x0F, true);
}
//===========================================================
//effect type: REDRAW
var fx = msg_unsafe_effects.bad_vsync;
if (fx.timer > 0)
{
    fx.timer -= 1;
    var height_max = sprite_get_height(sprite_index);

    fx.clipbot = floor(GET_INT(8, 0xFF) * height_max);
    fx.cliptop = fx.clipbot + GET_INT(4, 0x0F) * height_max/3;
    fx.horz = fx.horz_max * 2 * GET_INT(0, 0x0F, true);
}
if (fx.freq > GET_RNG(16, 0x3F))
{
    fx.timer = 3;
}
//===========================================================

#define GET_RNG(offset, mask)
//===========================================================
// returns a random number from the seed by using the mask.
// uses "msg_unsafe_random" implicitly.
return (mask <= 0) ? 0 
       :((msg_unsafe_random >> offset) & mask);
       
#define GET_INT
//===========================================================
// returns an intensity for the effect, between 0 and 1.
// if centered is true, this will be between -0.5 and +0.5 instead.
// uses "msg_unsafe_random" implicitly.
var offset = argument[0], mask = argument[1];
var centered = argument_count > 2 ? argument[2] : false;
return (mask <= 0) ? 0 
       : ((msg_unsafe_random >> offset) & mask) * (1.0/mask) - (centered * 0.5);