//animation.gml

//==================================================================
// BSPECIAL must consider the small_sprites parameter of the stolen sprites!
// note: regular draw event needs this to happen before pre_draw, apparently.
if (state == PS_ATTACK_AIR || state == PS_ATTACK_GROUND) && (attack == AT_DSPECIAL_2)
{
    small_sprites = at_bspecial_last_move.small_sprites;
}
else { small_sprites = 1; }

//==================================================================
// Glitch unsafe effects timers
if (msg_unsafe_paused_timer > 0)
{ msg_unsafe_paused_timer--; }

msg_unsafe_handler_id = self; //missingnos always handle themselves
with (oPlayer) if ("msg_unsafe_handler_id" in self 
               &&   msg_unsafe_handler_id == other)
{
    var msg_master_timer_running = (msg_unsafe_effects.master_effect_timer > 0);
    msg_unsafe_effects.master_effect_timer -= msg_master_timer_running;

    for (var i = 0; i < array_length(msg_unsafe_effects.effects_list); i++)
    {
        var fx = msg_unsafe_effects.effects_list[i];
        //reset all effect's frequencies IF the master timer is done or the master flag is false
        fx.master_flag = (fx.master_flag && msg_master_timer_running);
        fx.freq *= fx.master_flag;
    }
}
//==================================================================

//crawl transition timers
if (state == PS_CROUCH && (right_down - left_down != 0) || state == PS_DASH_START) && down_down
{
    if (msg_crawlintro_timer < 6) msg_crawlintro_timer++;
}
else 
{
    if (msg_crawlintro_timer > 0) msg_crawlintro_timer--;
}

switch (state)
{
    case PS_IDLE:
    {
        if (msg_crawlintro_timer > 0)
        {
            sprite_index = msg_crawl_spr;
            image_index = 4;
        }
    } break;
//==================================================================
    case PS_WALK:
    {
        sprite_index = sprite_get("idle");
        if (state_timer == 0)
        {
            msg_walk_start_x = x;
        }
        else
        {
            var max_dist = 80;
            var distance_walked = x - msg_walk_start_x;

            msg_unsafe_effects.bad_vsync.freq = abs(distance_walked/5);
            msg_unsafe_effects.bad_vsync.horz_max = abs(distance_walked/10);

            distance_walked = clamp(distance_walked, -max_dist, max_dist);
            distance_walked = random_func(0, distance_walked, true);
            distance_walked = random_func(0, distance_walked, true);
            draw_x = -floor(distance_walked/2);
            
            msg_unsafe_effects.shudder.freq = abs(distance_walked);
            msg_unsafe_effects.shudder.horz_max = abs(distance_walked);
            msg_unsafe_effects.shudder.vert_max = 0;
            
        }
    } break;
//==================================================================
    case PS_WALK_TURN:
    {
        sprite_index = sprite_get("idle");
        msg_unsafe_effects.bad_vsync.freq = 12;
        msg_unsafe_effects.bad_vsync.horz_max = 18;
        msg_unsafe_effects.shudder.freq = 12;
        msg_unsafe_effects.shudder.horz_max = 18;
        msg_unsafe_effects.shudder.vert_max = 12;
    } break;
//==================================================================
    case PS_CROUCH:
    {
        if (!joy_pad_idle) && (right_down - left_down != 0)
        {
            sprite_index = msg_crawl_spr;
            msg_crawl_anim_index = 
            (msg_crawl_anim_index + 4 + crouch_anim_speed * spr_dir * (right_down - left_down)) % 4;
            image_index = msg_crawl_anim_index;

            if (msg_crawlintro_timer < 5)
            {
                image_index = 4;
            }
        }
        else if (msg_crawlintro_timer > 0)
        {
            sprite_index = msg_crawl_spr;
            image_index = 4;
        }
    } break;
//==================================================================
    case PS_DASH_START:
    {
        if (down_down)
        {
            sprite_index = msg_crawl_spr;
            msg_crawl_anim_index = 
            (msg_crawl_anim_index + 4 + crouch_anim_speed * 2 * spr_dir * (right_down - left_down)) % 4;
            if (right_down - left_down) == 0 
            {
                msg_crawl_anim_index = (msg_crawl_anim_index + 4 + hsp/12) % 4;
            }
            image_index = msg_crawl_anim_index;
        }
    } break;
//==================================================================
    case PS_ATTACK_AIR:
    case PS_ATTACK_GROUND:
    switch (attack)
    {
//==================================================================
        case AT_NTHROW:
        {
            if (window == 4)
            {
                msg_unsafe_effects.bad_vsync.freq = 999;
                msg_unsafe_effects.bad_vsync.horz_max = 50;
                msg_unsafe_paused_timer = max(msg_unsafe_paused_timer, 5);
            }
        } break;
//==================================================================
        default: break;
        
    }
//==================================================================
    default: break;
}

//==================================================================
// general

//unstable hitstun
if (state_cat == SC_HITSTUN)
{
    msg_unsafe_effects.bad_vsync.freq = 999;
    if (hitpause)
    { msg_unsafe_paused_timer = max(msg_unsafe_paused_timer, 2); }
}