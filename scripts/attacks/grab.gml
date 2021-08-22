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

var hbox_num = 0;

//Grab
hbox_num++;
set_hitbox_value(AT_NTHROW, hbox_num, HG_HITBOX_TYPE, 1);
set_hitbox_value(AT_NTHROW, hbox_num, HG_WINDOW, 2);
set_hitbox_value(AT_NTHROW, hbox_num, HG_LIFETIME, get_window_value(AT_NTHROW, 2, AG_WINDOW_LENGTH));
set_hitbox_value(AT_NTHROW, hbox_num, HG_HITBOX_X, 25);
set_hitbox_value(AT_NTHROW, hbox_num, HG_HITBOX_Y, -25);
set_hitbox_value(AT_NTHROW, hbox_num, HG_WIDTH, 60);
set_hitbox_value(AT_NTHROW, hbox_num, HG_HEIGHT, 60);
set_hitbox_value(AT_NTHROW, hbox_num, HG_PRIORITY, 3);
set_hitbox_value(AT_NTHROW, hbox_num, HG_DAMAGE, 3);
set_hitbox_value(AT_NTHROW, hbox_num, HG_ANGLE, 90);
set_hitbox_value(AT_NTHROW, hbox_num, HG_EFFECT, 9);
set_hitbox_value(AT_NTHROW, hbox_num, HG_BASE_KNOCKBACK, 5);
set_hitbox_value(AT_NTHROW, hbox_num, HG_BASE_HITPAUSE, 0);
set_hitbox_value(AT_NTHROW, hbox_num, HG_VISUAL_EFFECT, 1);

//========================================================================
//Grab Outcome: Frozen + Burning
current_window = 5;
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
set_hitbox_value(AT_NTHROW, hbox_num, HG_DAMAGE, 1);
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
set_hitbox_value(AT_NTHROW, hbox_num, HG_DAMAGE, 1);
set_hitbox_value(AT_NTHROW, hbox_num, HG_ANGLE, 270);
set_hitbox_value(AT_NTHROW, hbox_num, HG_EFFECT, 5); //Freeze
set_hitbox_value(AT_NTHROW, hbox_num, HG_BASE_KNOCKBACK, 1);
set_hitbox_value(AT_NTHROW, hbox_num, HG_BASE_HITPAUSE, 3);
set_hitbox_value(AT_NTHROW, hbox_num, HG_EXTRA_HITPAUSE, 3);

//========================================================================
// Grab Outcome: Leech Seed Bug
current_window = 6;
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
set_hitbox_value(AT_NTHROW, hbox_num, HG_PRIORITY, 6);
set_hitbox_value(AT_NTHROW, hbox_num, HG_DAMAGE, 1);
set_hitbox_value(AT_NTHROW, hbox_num, HG_ANGLE, 85);
set_hitbox_value(AT_NTHROW, hbox_num, HG_EFFECT, 6); //Mark (poison stacks handled separately)
set_hitbox_value(AT_NTHROW, hbox_num, HG_BASE_KNOCKBACK, 1);
set_hitbox_value(AT_NTHROW, hbox_num, HG_EXTRA_HITPAUSE, 3);
//========================================================================



set_num_hitboxes(AT_NTHROW, hbox_num);