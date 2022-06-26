#define msg_collect_garbage()
//Done in animation.gml, contrary to pre_draw
if (get_gameplay_time() % 15 == 0) && (0 == GET_RNG(1, 0x03))
{
    //random chance per player to swap with an entry as its garbage sprite
    var base_entry_rng = GET_RNG(3, 0x0F)
    with (oPlayer) with (other)
    {
        var entry_rng = (other.player + base_entry_rng) % 16;
        var player_rng = GET_RNG((other.player % 4)*2 + 24, 0x03)
        if (player_rng == 0)
        {
            //simple swap
            var temp = other.msg_unsafe_garbage;
            other.msg_unsafe_garbage = msg_garbage_collection[entry_rng];
            msg_garbage_collection[entry_rng] = temp;
        }
        else if (player_rng == 1)
        {
            //replace with sprite currently in use
            other.msg_unsafe_garbage = msg_garbage_collection[entry_rng];
            msg_garbage_collection[entry_rng] = msg_get_garbage();
        }
    }
}
//===================================================================
#define msg_refresh_effects()
//really needs a better name; urgh
// placed in animation (runs on game frames)
with (oPlayer) if ("msg_unsafe_handler_id" in self 
               &&   msg_unsafe_handler_id == other)
{
    if (msg_unsafe_paused_timer > 0)
    { msg_unsafe_paused_timer--; }

    //reset all effect's frequencies IF the game-timer is done counting
    for (var i = 0; i < array_length(msg_unsafe_effects.effects_list); i++)
    {
        var fx = msg_unsafe_effects.effects_list[i];
        var is_running = (fx.gameplay_timer > 0);
        fx.gameplay_timer -= is_running;
        fx.freq *= is_running;
    }
}

//===================================================================
#define msg_reroll_random()
//reroll msg_unsafe_random

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

//===================================================================
#define msg_apply_effects()
//aka. unsafe_animation.gml
// placed in pre_draw (runs on draw frames)

//essential for rendering-random checks.
if ("msg_unsafe_random" not in self) return;

msg_reroll_random();

//special msg_is_missingno-only effects are denoted 'M
//===================================================================
// BITWISE RANDOM UINT32 MAP = 0x00000000 00000000 00000000 00000000
// Effects:    Frequency uses: 
//  - Shudder                                      ttffffff VVVVHHHH
//  - VSync                            tt GGffffff BBBBBBBB TTTTHHHH
//  - Quadrant                               tttff ffffGGSS 22GGSS11
//  - wrong image_index
//'M- garbage collector          P4P3P2P1                    EEEEFF 
//  - trail
//===================================================================


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
        fx.timer--;
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
        fx.timer -= (fx.freq == 0);
        //apply
    }
}
//===========================================================
//effect: QUADRANT, type: REDRAW
var fx = msg_unsafe_effects.quadrant 
{
    if (fx.impulse > 0) || (fx.freq > GET_RNG(12, 0x3F))
    {
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
        fx.timer -= (fx.freq == 0);
        //apply
    }
    else
    {
        fx.source[0]  = 0; fx.source[1]  = 1; fx.source[2]  = 2; fx.source[3]  = 3;
        fx.garbage[0] = 0; fx.garbage[1] = 1; fx.garbage[2] = 2; fx.garbage[3] = 3;
    }
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