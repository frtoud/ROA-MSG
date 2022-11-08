set_attack_value(AT_DAIR, AG_CATEGORY, 2);
set_attack_value(AT_DAIR, AG_SPRITE, sprite_get("dair"));
set_attack_value(AT_DAIR, AG_NUM_WINDOWS, 4);
set_attack_value(AT_DAIR, AG_HAS_LANDING_LAG, 1);
set_attack_value(AT_DAIR, AG_LANDING_LAG, 4);
set_attack_value(AT_DAIR, AG_HURTBOX_SPRITE, sprite_get("dair_hurt"));

set_window_value(AT_DAIR, 1, AG_WINDOW_TYPE, 1);
set_window_value(AT_DAIR, 1, AG_WINDOW_LENGTH, 12);
set_window_value(AT_DAIR, 1, AG_WINDOW_ANIM_FRAMES, 1);
set_window_value(AT_DAIR, 1, AG_WINDOW_VSPEED, -3);
set_window_value(AT_DAIR, 1, AG_WINDOW_VSPEED_TYPE, 2);
set_window_value(AT_DAIR, 1, AG_WINDOW_HAS_SFX, 1);
set_window_value(AT_DAIR, 1, AG_WINDOW_SFX, asset_get("sfx_kragg_roll_start"));
set_window_value(AT_DAIR, 1, AG_WINDOW_SFX_FRAME, 1);

//set_window_value(AT_DAIR, 2, AG_WINDOW_TYPE, 10); //BROKEN BY OMNICHARGE MECHANIC: cannot coexist with the hidden strong charge window... urgh
set_window_value(AT_DAIR, 2, AG_WINDOW_LENGTH, 6);
set_window_value(AT_DAIR, 2, AG_WINDOW_VSPEED, 16);
set_window_value(AT_DAIR, 2, AG_WINDOW_VSPEED_TYPE, 1);
set_window_value(AT_DAIR, 2, AG_WINDOW_HSPEED_TYPE, 1);
set_window_value(AT_DAIR, 2, AG_WINDOW_ANIM_FRAMES, 1);
set_window_value(AT_DAIR, 2, AG_WINDOW_ANIM_FRAME_START, 1);

set_window_value(AT_DAIR, 3, AG_WINDOW_TYPE, 1);
set_window_value(AT_DAIR, 3, AG_WINDOW_LENGTH, 3);
set_window_value(AT_DAIR, 3, AG_WINDOW_ANIM_FRAMES, 1);
set_window_value(AT_DAIR, 3, AG_WINDOW_ANIM_FRAME_START, 1);

set_window_value(AT_DAIR, 4, AG_WINDOW_TYPE, 1);
set_window_value(AT_DAIR, 4, AG_WINDOW_LENGTH, 18);
set_window_value(AT_DAIR, 4, AG_WINDOW_ANIM_FRAMES, 1);
set_window_value(AT_DAIR, 4, AG_WINDOW_ANIM_FRAME_START, 1);
set_window_value(AT_DAIR, 4, AG_WINDOW_HAS_WHIFFLAG, 5);

set_num_hitboxes(AT_DAIR, 2);

set_hitbox_value(AT_DAIR, 1, HG_HITBOX_TYPE, 1);
set_hitbox_value(AT_DAIR, 1, HG_WINDOW, 2);
set_hitbox_value(AT_DAIR, 1, HG_WINDOW_CREATION_FRAME, 1);
set_hitbox_value(AT_DAIR, 1, HG_LIFETIME, 2);
set_hitbox_value(AT_DAIR, 1, HG_HITBOX_Y, -20);
set_hitbox_value(AT_DAIR, 1, HG_WIDTH, 40);
set_hitbox_value(AT_DAIR, 1, HG_HEIGHT, 50);
set_hitbox_value(AT_DAIR, 1, HG_SHAPE, 1);
set_hitbox_value(AT_DAIR, 1, HG_PRIORITY, 2);
set_hitbox_value(AT_DAIR, 1, HG_DAMAGE, 10);
set_hitbox_value(AT_DAIR, 1, HG_ANGLE, 270);
set_hitbox_value(AT_DAIR, 1, HG_BASE_KNOCKBACK, 10);
set_hitbox_value(AT_DAIR, 1, HG_KNOCKBACK_SCALING, 1.0);
set_hitbox_value(AT_DAIR, 1, HG_BASE_HITPAUSE, 15);
set_hitbox_value(AT_DAIR, 1, HG_HITPAUSE_SCALING, 0.0);
set_hitbox_value(AT_DAIR, 1, HG_EXTRA_HITPAUSE, 5);
set_hitbox_value(AT_DAIR, 1, HG_VISUAL_EFFECT, 305);
set_hitbox_value(AT_DAIR, 1, HG_VISUAL_EFFECT_Y_OFFSET, 20);
set_hitbox_value(AT_DAIR, 1, HG_HIT_LOCKOUT, 10);
set_hitbox_value(AT_DAIR, 1, HG_HIT_SFX, asset_get("sfx_blow_heavy2"));

set_hitbox_value(AT_DAIR, 2, HG_HITBOX_TYPE, 1);
set_hitbox_value(AT_DAIR, 2, HG_WINDOW, 3);
set_hitbox_value(AT_DAIR, 2, HG_LIFETIME, 2);
set_hitbox_value(AT_DAIR, 2, HG_HITBOX_Y, -13);
set_hitbox_value(AT_DAIR, 2, HG_WIDTH, 80);
set_hitbox_value(AT_DAIR, 2, HG_HEIGHT, 35);
set_hitbox_value(AT_DAIR, 2, HG_SHAPE, 1);
set_hitbox_value(AT_DAIR, 2, HG_PRIORITY, 2);
set_hitbox_value(AT_DAIR, 2, HG_DAMAGE, 3);
set_hitbox_value(AT_DAIR, 2, HG_ANGLE, 80);
set_hitbox_value(AT_DAIR, 2, HG_ANGLE_FLIPPER, 3);
set_hitbox_value(AT_DAIR, 2, HG_BASE_KNOCKBACK, 10);
set_hitbox_value(AT_DAIR, 2, HG_KNOCKBACK_SCALING, 0.7);
set_hitbox_value(AT_DAIR, 2, HG_BASE_HITPAUSE, 1);
set_hitbox_value(AT_DAIR, 2, HG_EXTRA_HITPAUSE, 7);
set_hitbox_value(AT_DAIR, 2, HG_HITPAUSE_SCALING, 0);
set_hitbox_value(AT_DAIR, 2, HG_VISUAL_EFFECT, 301);
set_hitbox_value(AT_DAIR, 2, HG_VISUAL_EFFECT_Y_OFFSET, 20);
set_hitbox_value(AT_DAIR, 2, HG_HIT_SFX, asset_get("sfx_blow_heavy2"));
set_hitbox_value(AT_DAIR, 2, HG_HITBOX_GROUP, -1);


set_attack_value(AT_DTHROW, AG_CATEGORY, 2);
set_attack_value(AT_DTHROW, AG_SPRITE, sprite_get("nair"));
set_attack_value(AT_DTHROW, AG_NUM_WINDOWS, 3);
set_attack_value(AT_DTHROW, AG_HAS_LANDING_LAG, 1);
set_attack_value(AT_DTHROW, AG_LANDING_LAG, 4);
set_attack_value(AT_DTHROW, AG_HURTBOX_SPRITE, sprite_get("nair_hurt"));

set_window_value(AT_DTHROW, 1, AG_WINDOW_TYPE, 1);
set_window_value(AT_DTHROW, 1, AG_WINDOW_LENGTH, 12);
set_window_value(AT_DTHROW, 1, AG_WINDOW_ANIM_FRAMES, 1);
set_window_value(AT_DTHROW, 2, AG_WINDOW_ANIM_FRAME_START, 5);
set_window_value(AT_DTHROW, 1, AG_WINDOW_VSPEED, -3);
set_window_value(AT_DTHROW, 1, AG_WINDOW_VSPEED_TYPE, 0);
set_window_value(AT_DTHROW, 1, AG_WINDOW_HAS_SFX, 1);
set_window_value(AT_DTHROW, 1, AG_WINDOW_SFX, asset_get("sfx_kragg_roll_start"));
set_window_value(AT_DTHROW, 1, AG_WINDOW_SFX_FRAME, 1);

//set_window_value(AT_DAIR, 2, AG_WINDOW_TYPE, 10); //BROKEN BY OMNICHARGE MECHANIC: cannot coexist with the hidden strong charge window... urgh
set_window_value(AT_DTHROW, 2, AG_WINDOW_LENGTH, 6);
set_window_value(AT_DTHROW, 2, AG_WINDOW_ANIM_FRAMES, 1);
set_window_value(AT_DTHROW, 2, AG_WINDOW_ANIM_FRAME_START, 0);

set_window_value(AT_DTHROW, 3, AG_WINDOW_TYPE, 1);
set_window_value(AT_DTHROW, 3, AG_WINDOW_LENGTH, 12);
set_window_value(AT_DTHROW, 3, AG_WINDOW_ANIM_FRAMES, 1);
set_window_value(AT_DTHROW, 3, AG_WINDOW_ANIM_FRAME_START, 5);

//counter window
set_window_value(AT_DTHROW, 4, AG_WINDOW_TYPE, 1);
set_window_value(AT_DTHROW, 4, AG_WINDOW_LENGTH, 15);
set_window_value(AT_DTHROW, 4, AG_WINDOW_INVINCIBILITY, 1);
set_window_value(AT_DTHROW, 4, AG_WINDOW_ANIM_FRAMES, 5);
set_window_value(AT_DTHROW, 4, AG_WINDOW_ANIM_FRAME_START, 0);

set_num_hitboxes(AT_DTHROW, 2);

set_hitbox_value(AT_DTHROW, 1, HG_HITBOX_TYPE, 2);
set_hitbox_value(AT_DTHROW, 1, HG_WINDOW, 2);
set_hitbox_value(AT_DTHROW, 1, HG_LIFETIME, 480);
set_hitbox_value(AT_DTHROW, 1, HG_HITBOX_X, 6);
set_hitbox_value(AT_DTHROW, 1, HG_HITBOX_Y, 0);
set_hitbox_value(AT_DTHROW, 1, HG_WIDTH, 40);
set_hitbox_value(AT_DTHROW, 1, HG_HEIGHT, 20);
set_hitbox_value(AT_DTHROW, 1, HG_SHAPE, 1);
set_hitbox_value(AT_DTHROW, 1, HG_PRIORITY, 7);
set_hitbox_value(AT_DTHROW, 1, HG_DAMAGE, 9);
set_hitbox_value(AT_DTHROW, 1, HG_ANGLE, 90);
set_hitbox_value(AT_DTHROW, 1, HG_BASE_KNOCKBACK, 8);
set_hitbox_value(AT_DTHROW, 1, HG_KNOCKBACK_SCALING, 0.4);
set_hitbox_value(AT_DTHROW, 1, HG_BASE_HITPAUSE, 5);
set_hitbox_value(AT_DTHROW, 1, HG_HITPAUSE_SCALING, 1);
set_hitbox_value(AT_DTHROW, 1, HG_GROUNDEDNESS, 0);
set_hitbox_value(AT_DTHROW, 1, HG_IGNORES_PROJECTILES, 1);
set_hitbox_value(AT_DTHROW, 1, HG_VISUAL_EFFECT, hfx_error_x);
set_hitbox_value(AT_DTHROW, 1, HG_PROJECTILE_DESTROY_EFFECT, hfx_error_b);
set_hitbox_value(AT_DTHROW, 1, HG_HIT_SFX, asset_get("sfx_blow_heavy2"));
set_hitbox_value(AT_DTHROW, 1, HG_THROWS_ROCK, 2); //ignore
set_hitbox_value(AT_DTHROW, 1, HG_PROJECTILE_SPRITE, msg_substitute);
set_hitbox_value(AT_DTHROW, 1, HG_PROJECTILE_ANIM_SPEED, 0);
set_hitbox_value(AT_DTHROW, 1, HG_PROJECTILE_MASK, -1);
set_hitbox_value(AT_DTHROW, 1, HG_PROJECTILE_WALL_BEHAVIOR, 1);
set_hitbox_value(AT_DTHROW, 1, HG_PROJECTILE_ENEMY_BEHAVIOR, 0);
set_hitbox_value(AT_DTHROW, 1, HG_PROJECTILE_PARRY_STUN, 0);
set_hitbox_value(AT_DTHROW, 1, HG_PROJECTILE_UNBASHABLE, 1);
set_hitbox_value(AT_DTHROW, 1, HG_PROJECTILE_DOES_NOT_REFLECT, 1);
set_hitbox_value(AT_DTHROW, 1, HG_PROJECTILE_IS_TRANSCENDENT, 1);

set_hitbox_value(AT_DTHROW, 1, HG_PROJECTILE_GRAVITY, gravity_speed);
set_hitbox_value(AT_DTHROW, 1, HG_PROJECTILE_GROUND_FRICTION, 0.2);
set_hitbox_value(AT_DTHROW, 1, HG_PROJECTILE_AIR_FRICTION, 0.03);

set_hitbox_value(AT_DTHROW, 2, HG_HITBOX_TYPE, 1);
set_hitbox_value(AT_DTHROW, 2, HG_WINDOW, 4);
set_hitbox_value(AT_DTHROW, 2, HG_WINDOW_CREATION_FRAME, 3);
set_hitbox_value(AT_DTHROW, 2, HG_LIFETIME, 5);
set_hitbox_value(AT_DTHROW, 2, HG_HITBOX_Y, -40);
set_hitbox_value(AT_DTHROW, 2, HG_WIDTH, 110);
set_hitbox_value(AT_DTHROW, 2, HG_HEIGHT, 90);
set_hitbox_value(AT_DTHROW, 2, HG_SHAPE, 2);
set_hitbox_value(AT_DTHROW, 2, HG_PRIORITY, 2);
set_hitbox_value(AT_DTHROW, 2, HG_DAMAGE, 16);
set_hitbox_value(AT_DTHROW, 2, HG_ANGLE, 70);
set_hitbox_value(AT_DTHROW, 2, HG_ANGLE_FLIPPER, 3);
set_hitbox_value(AT_DTHROW, 2, HG_BASE_KNOCKBACK, 10);
set_hitbox_value(AT_DTHROW, 2, HG_KNOCKBACK_SCALING, 0.7);
set_hitbox_value(AT_DTHROW, 2, HG_BASE_HITPAUSE, 5);
set_hitbox_value(AT_DTHROW, 2, HG_EXTRA_HITPAUSE, 0);
set_hitbox_value(AT_DTHROW, 2, HG_HITPAUSE_SCALING, 1);
set_hitbox_value(AT_DTHROW, 2, HG_VISUAL_EFFECT, 301);
set_hitbox_value(AT_DTHROW, 2, HG_VISUAL_EFFECT_Y_OFFSET, 20);
set_hitbox_value(AT_DTHROW, 2, HG_HIT_SFX, asset_get("sfx_blow_heavy2"));
set_hitbox_value(AT_DTHROW, 2, HG_HITBOX_GROUP, -1);