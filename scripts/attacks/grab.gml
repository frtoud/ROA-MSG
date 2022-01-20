set_attack_value(AT_NTHROW, AG_CATEGORY, 2);
set_attack_value(AT_NTHROW, AG_SPRITE, sprite_get("nspecial"));
set_attack_value(AT_NTHROW, AG_NUM_WINDOWS, 3);
set_attack_value(AT_NTHROW, AG_OFF_LEDGE, 1);
set_attack_value(AT_NTHROW, AG_AIR_SPRITE, sprite_get("nspecial"));
set_attack_value(AT_NTHROW, AG_HURTBOX_SPRITE, sprite_get("nspecial_hurt"));

//startup
set_window_value(AT_NTHROW, 1, AG_WINDOW_LENGTH, 6);
set_window_value(AT_NTHROW, 1, AG_WINDOW_ANIM_FRAMES, 2);
//set_window_value(AT_NTHROW, 1, AG_WINDOW_HAS_SFX, 1);
//set_window_value(AT_NTHROW, 1, AG_WINDOW_SFX, asset_get("sfx_bubblepop"));
//set_window_value(AT_NTHROW, 1, AG_WINDOW_SFX_FRAME, 4);

//active
set_window_value(AT_NTHROW, 2, AG_WINDOW_LENGTH, 3);
set_window_value(AT_NTHROW, 2, AG_WINDOW_ANIM_FRAMES, 1);
set_window_value(AT_NTHROW, 2, AG_WINDOW_ANIM_FRAME_START, 2);

//Endlag
set_window_value(AT_NTHROW, 3, AG_WINDOW_LENGTH, 12);
set_window_value(AT_NTHROW, 3, AG_WINDOW_ANIM_FRAMES, 1);
set_window_value(AT_NTHROW, 3, AG_WINDOW_ANIM_FRAME_START, 3);

//Grab Success
set_window_value(AT_NTHROW, 4, AG_WINDOW_LENGTH, 40);
set_window_value(AT_NTHROW, 4, AG_WINDOW_INVINCIBILITY, 1);
set_window_value(AT_NTHROW, 4, AG_WINDOW_HSPEED_TYPE, 1);
set_window_value(AT_NTHROW, 4, AG_WINDOW_VSPEED_TYPE, 1);
set_window_value(AT_NTHROW, 4, AG_WINDOW_ANIM_FRAMES, 1);
set_window_value(AT_NTHROW, 4, AG_WINDOW_ANIM_FRAME_START, 2);

//Grab
set_hitbox_value(AT_NTHROW, 1, HG_HITBOX_TYPE, 1);
set_hitbox_value(AT_NTHROW, 1, HG_WINDOW, 2);
set_hitbox_value(AT_NTHROW, 1, HG_LIFETIME, get_window_value(AT_NTHROW, 2, AG_WINDOW_LENGTH));
set_hitbox_value(AT_NTHROW, 1, HG_HITBOX_X, 25);
set_hitbox_value(AT_NTHROW, 1, HG_HITBOX_Y, -25);
set_hitbox_value(AT_NTHROW, 1, HG_WIDTH, 60);
set_hitbox_value(AT_NTHROW, 1, HG_HEIGHT, 60);
set_hitbox_value(AT_NTHROW, 1, HG_PRIORITY, 3);
set_hitbox_value(AT_NTHROW, 1, HG_DAMAGE, 3);
set_hitbox_value(AT_NTHROW, 1, HG_ANGLE, 90);
set_hitbox_value(AT_NTHROW, 1, HG_EFFECT, 9);
set_hitbox_value(AT_NTHROW, 1, HG_BASE_KNOCKBACK, 5);
set_hitbox_value(AT_NTHROW, 1, HG_BASE_HITPAUSE, 0);
set_hitbox_value(AT_NTHROW, 1, HG_VISUAL_EFFECT, 1);

//========================================================================
// Grab outcomes
var hbox_num = 1;
var current_window = 4;
//========================================================================
//Grab Outcome: Frozen + Burning
current_window++;
MSG_GRAB_FROSTBURN_WINDOW = current_window;
set_window_value(AT_NTHROW, current_window, AG_WINDOW_LENGTH, 3);
set_window_value(AT_NTHROW, current_window, AG_WINDOW_ANIM_FRAMES, 1);
set_window_value(AT_NTHROW, current_window, AG_WINDOW_ANIM_FRAME_START, 3);

hbox_num++;
set_hitbox_value(AT_NTHROW, hbox_num, HG_HITBOX_TYPE, 1);
set_hitbox_value(AT_NTHROW, hbox_num, HG_HITBOX_GROUP, -1);
set_hitbox_value(AT_NTHROW, hbox_num, HG_WINDOW, current_window);
set_hitbox_value(AT_NTHROW, hbox_num, HG_LIFETIME, 1);
set_hitbox_value(AT_NTHROW, hbox_num, HG_HITBOX_X, 25);
set_hitbox_value(AT_NTHROW, hbox_num, HG_HITBOX_Y, -25);
set_hitbox_value(AT_NTHROW, hbox_num, HG_WIDTH, 60);
set_hitbox_value(AT_NTHROW, hbox_num, HG_HEIGHT, 60);
set_hitbox_value(AT_NTHROW, hbox_num, HG_PRIORITY, 4);
set_hitbox_value(AT_NTHROW, hbox_num, HG_TECHABLE, 3);
set_hitbox_value(AT_NTHROW, hbox_num, HG_DAMAGE, 0);
set_hitbox_value(AT_NTHROW, hbox_num, HG_ANGLE, 270);
set_hitbox_value(AT_NTHROW, hbox_num, HG_EFFECT, 1); //Burn
set_hitbox_value(AT_NTHROW, hbox_num, HG_BASE_KNOCKBACK, 1);
set_hitbox_value(AT_NTHROW, hbox_num, HG_BASE_HITPAUSE, 3);
set_hitbox_value(AT_NTHROW, hbox_num, HG_EXTRA_HITPAUSE, 3);
hbox_num++;
set_hitbox_value(AT_NTHROW, hbox_num, HG_HITBOX_TYPE, 1);
set_hitbox_value(AT_NTHROW, hbox_num, HG_HITBOX_GROUP, -1);
set_hitbox_value(AT_NTHROW, hbox_num, HG_WINDOW, current_window);
set_hitbox_value(AT_NTHROW, hbox_num, HG_LIFETIME, 1);
set_hitbox_value(AT_NTHROW, hbox_num, HG_HITBOX_X, 25);
set_hitbox_value(AT_NTHROW, hbox_num, HG_HITBOX_Y, -25);
set_hitbox_value(AT_NTHROW, hbox_num, HG_WIDTH, 60);
set_hitbox_value(AT_NTHROW, hbox_num, HG_HEIGHT, 60);
set_hitbox_value(AT_NTHROW, hbox_num, HG_PRIORITY, 6);
set_hitbox_value(AT_NTHROW, hbox_num, HG_TECHABLE, 3);
set_hitbox_value(AT_NTHROW, hbox_num, HG_DAMAGE, 0);
set_hitbox_value(AT_NTHROW, hbox_num, HG_ANGLE, 270);
set_hitbox_value(AT_NTHROW, hbox_num, HG_EFFECT, 5); //Freeze
set_hitbox_value(AT_NTHROW, hbox_num, HG_BASE_KNOCKBACK, 1);
set_hitbox_value(AT_NTHROW, hbox_num, HG_BASE_HITPAUSE, 3);
set_hitbox_value(AT_NTHROW, hbox_num, HG_EXTRA_HITPAUSE, 3);

//========================================================================
// Grab Outcome: Leech Seed Bug
current_window++;
MSG_GRAB_LEECHSEED_WINDOW = current_window;
set_window_value(AT_NTHROW, current_window, AG_WINDOW_LENGTH, 3);
set_window_value(AT_NTHROW, current_window, AG_WINDOW_ANIM_FRAMES, 1);
set_window_value(AT_NTHROW, current_window, AG_WINDOW_ANIM_FRAME_START, 3);

hbox_num++;
MSG_GRAB_LEECHSEED_HITBOX = hbox_num;

//needed 4 different hitboxes because Dan doesnt like me setting poison variable directly
for (var i = 0; i < 4; i++)
{
    set_hitbox_value(AT_NTHROW, hbox_num + i, HG_HITBOX_TYPE, 1);
    set_hitbox_value(AT_NTHROW, hbox_num + i, HG_HITBOX_GROUP, -1);
    set_hitbox_value(AT_NTHROW, hbox_num + i, HG_WINDOW, current_window);
    set_hitbox_value(AT_NTHROW, hbox_num + i, HG_LIFETIME, 1);
    set_hitbox_value(AT_NTHROW, hbox_num + i, HG_HITBOX_X, 25);
    set_hitbox_value(AT_NTHROW, hbox_num + i, HG_HITBOX_Y, -25);
    set_hitbox_value(AT_NTHROW, hbox_num + i, HG_WIDTH, 70);
    set_hitbox_value(AT_NTHROW, hbox_num + i, HG_HEIGHT, 60);
    set_hitbox_value(AT_NTHROW, hbox_num + i, HG_PRIORITY, 6);
    set_hitbox_value(AT_NTHROW, hbox_num + i, HG_DAMAGE, 1);
    set_hitbox_value(AT_NTHROW, hbox_num + i, HG_ANGLE, 85);
    set_hitbox_value(AT_NTHROW, hbox_num + i, HG_EFFECT, 10); //Mark doesnt work apparently
    set_hitbox_value(AT_NTHROW, hbox_num + i, HG_BASE_KNOCKBACK, 7);
    set_hitbox_value(AT_NTHROW, hbox_num + i, HG_KNOCKBACK_SCALING, 0.3);
    set_hitbox_value(AT_NTHROW, hbox_num + i, HG_BASE_HITPAUSE, 7);
    set_hitbox_value(AT_NTHROW, hbox_num + i, HG_EXTRA_HITPAUSE, 3);
    if (i == 0) 
    {
        set_hitbox_value(AT_NTHROW, hbox_num + i, HG_HIT_SFX, asset_get("sfx_leafy_hit2"));
        set_hitbox_value(AT_NTHROW, hbox_num + i, HG_VISUAL_EFFECT, 198);
    }
}
hbox_num += 3;
//========================================================================
// Grab Outcome: SELF DESTRUCT
current_window++;
MSG_GRAB_EXPLOSION_WINDOW = current_window;
set_window_value(AT_NTHROW, current_window, AG_WINDOW_LENGTH, 5);
set_window_value(AT_NTHROW, current_window, AG_WINDOW_ANIM_FRAMES, 1);
set_window_value(AT_NTHROW, current_window, AG_WINDOW_ANIM_FRAME_START, 3);
set_window_value(AT_NTHROW, current_window, AG_WINDOW_INVINCIBILITY, 1);

hbox_num++;
set_hitbox_value(AT_NTHROW, hbox_num, HG_HITBOX_TYPE, 1);
set_hitbox_value(AT_NTHROW, hbox_num, HG_HITBOX_GROUP, -1);
set_hitbox_value(AT_NTHROW, hbox_num, HG_WINDOW, current_window);
set_hitbox_value(AT_NTHROW, hbox_num, HG_LIFETIME, 1);
set_hitbox_value(AT_NTHROW, hbox_num, HG_HITBOX_X, 5);
set_hitbox_value(AT_NTHROW, hbox_num, HG_HITBOX_Y, -35);
set_hitbox_value(AT_NTHROW, hbox_num, HG_WIDTH, 120);
set_hitbox_value(AT_NTHROW, hbox_num, HG_HEIGHT, 120);
set_hitbox_value(AT_NTHROW, hbox_num, HG_PRIORITY, 6);
set_hitbox_value(AT_NTHROW, hbox_num, HG_DAMAGE, 20);
set_hitbox_value(AT_NTHROW, hbox_num, HG_ANGLE, 75);
set_hitbox_value(AT_NTHROW, hbox_num, HG_ANGLE_FLIPPER, 3);
set_hitbox_value(AT_NTHROW, hbox_num, HG_BASE_KNOCKBACK, 12);
set_hitbox_value(AT_NTHROW, hbox_num, HG_KNOCKBACK_SCALING, 1.0);
set_hitbox_value(AT_NTHROW, hbox_num, HG_BASE_HITPAUSE, 0);
set_hitbox_value(AT_NTHROW, hbox_num, HG_HITPAUSE_SCALING, 1);
set_hitbox_value(AT_NTHROW, hbox_num, HG_EXTRA_HITPAUSE, 8);
set_hitbox_value(AT_NTHROW, hbox_num, HG_VISUAL_EFFECT, 4);
//========================================================================
// Grab Outcome: NEGATIVE_DAMAGE
current_window++;
MSG_GRAB_NEGATIVE_WINDOW = current_window;
set_window_value(AT_NTHROW, current_window, AG_WINDOW_LENGTH, 3);
set_window_value(AT_NTHROW, current_window, AG_WINDOW_ANIM_FRAMES, 1);
set_window_value(AT_NTHROW, current_window, AG_WINDOW_ANIM_FRAME_START, 3);
set_window_value(AT_NTHROW, current_window, AG_WINDOW_INVINCIBILITY, 1);

hbox_num++;
MSG_GRAB_NEGATIVE_HITBOX = hbox_num;
set_hitbox_value(AT_NTHROW, hbox_num, HG_HITBOX_TYPE, 1);
set_hitbox_value(AT_NTHROW, hbox_num, HG_HITBOX_GROUP, -1);
set_hitbox_value(AT_NTHROW, hbox_num, HG_WINDOW, current_window);
set_hitbox_value(AT_NTHROW, hbox_num, HG_LIFETIME, 1);
set_hitbox_value(AT_NTHROW, hbox_num, HG_HITBOX_X, 25);
set_hitbox_value(AT_NTHROW, hbox_num, HG_HITBOX_Y, -25);
set_hitbox_value(AT_NTHROW, hbox_num, HG_WIDTH, 70);
set_hitbox_value(AT_NTHROW, hbox_num, HG_HEIGHT, 60);
set_hitbox_value(AT_NTHROW, hbox_num, HG_PRIORITY, 6);
set_hitbox_value(AT_NTHROW, hbox_num, HG_DAMAGE, 0);
set_hitbox_value(AT_NTHROW, hbox_num, HG_ANGLE, 75);
set_hitbox_value(AT_NTHROW, hbox_num, HG_BASE_KNOCKBACK, 10);
set_hitbox_value(AT_NTHROW, hbox_num, HG_BASE_HITPAUSE, 20);
set_hitbox_value(AT_NTHROW, hbox_num, HG_HIT_SFX, asset_get("sfx_blow_heavy2"));
//========================================================================

set_num_hitboxes(AT_NTHROW, hbox_num);
//Filling in this array with the info above
//List of Grab outcomes
var grab_frostburn = { window:MSG_GRAB_FROSTBURN_WINDOW, sound:sound_get("grab2")}; //Frozen + Burning
var grab_leechseed = { window:MSG_GRAB_LEECHSEED_WINDOW, sound:sound_get("grab3")}; //LeechSeed x Poisoned
var grab_explode =   { window:MSG_GRAB_EXPLOSION_WINDOW, sound:sound_get("grab4")}; //Selfdestruct
var grab_negative =  { window:MSG_GRAB_NEGATIVE_WINDOW,  sound:sound_get("grab5")}; //Negative Damage

//Put 4 in starting rotation
msg_grab_rotation = [grab_negative, 
                     grab_explode, 
                     grab_frostburn, 
                     grab_leechseed];

//Add the rest to the queue (minimum 1)
msg_grab_queue = [grab_frostburn];