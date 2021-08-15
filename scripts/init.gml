hurtbox_spr = asset_get("ex_guy_hurt_box");
crouchbox_spr = asset_get("ex_guy_crouch_box");
air_hurtbox_spr = -1;
hitstun_hurtbox_spr = -1;

char_height = 67;
idle_anim_speed = .1;
crouch_anim_speed = .1;
walk_anim_speed = .125;
dash_anim_speed = .2;
pratfall_anim_speed = .25;

walk_speed = 3.25;
walk_accel = 0.2;
walk_turn_time = 1;
initial_dash_time = 14;
initial_dash_speed = 8;
dash_speed = 7.5;
dash_turn_time = 10;
dash_turn_accel = 1.5;
dash_stop_time = 4;
dash_stop_percent = .35; //the value to multiply your hsp by when going into idle from dash or dashstop
ground_friction = .5;
moonwalk_accel = 1.4;

jump_start_time = 5;
jump_speed = 13;
short_hop_speed = 8;
djump_speed = 12;
leave_ground_max = 7; //the maximum hsp you can have when you go from grounded to aerial without jumping
max_jump_hsp = 7; //the maximum hsp you can have when jumping from the ground
air_max_speed = 7; //the maximum hsp you can accelerate to when in a normal aerial state
jump_change = 3; //maximum hsp when double jumping. If already going faster, it will not slow you down
air_accel = .3;
prat_fall_accel = .85; //multiplier of air_accel while in pratfall
air_friction = .02;
max_djumps = 1;
double_jump_time = 32; //the number of frames to play the djump animation. Can't be less than 31.
walljump_hsp = 7;
walljump_vsp = 11;
walljump_time = 32;
max_fall = 13; //maximum fall speed without fastfalling
fast_fall = 16; //fast fall speed
gravity_speed = .65;
hitstun_grav = .5;
knockback_adj = 1.0; //the multiplier to KB dealt to you. 1 = default, >1 = lighter, <1 = heavier

land_time = 4; //normal landing frames
prat_land_time = 3;
wave_land_time = 8;
wave_land_adj = 1.35; //the multiplier to your initial hsp when wavelanding. Usually greater than 1
wave_friction = .04; //grounded deceleration when wavelanding

//crouch animation frames
crouch_startup_frames = 1;
crouch_active_frames = 1;
crouch_recovery_frames = 1;

//parry animation frames
dodge_startup_frames = 1;
dodge_active_frames = 1;
dodge_recovery_frames = 3;

//tech animation frames
tech_active_frames = 3;
tech_recovery_frames = 1;

//tech roll animation frames
techroll_startup_frames = 2
techroll_active_frames = 2;
techroll_recovery_frames = 2;
techroll_speed = 10;

//airdodge animation frames
air_dodge_startup_frames = 1;
air_dodge_active_frames = 2;
air_dodge_recovery_frames = 3;
air_dodge_speed = 7.5;

//roll animation frames
roll_forward_startup_frames = 2;
roll_forward_active_frames = 4;
roll_forward_recovery_frames = 2;
roll_back_startup_frames = 2;
roll_back_active_frames = 4;
roll_back_recovery_frames = 2;
roll_forward_max = 9; //roll speed
roll_backward_max = 9;

land_sound = asset_get("sfx_land_med");
landing_lag_sound = asset_get("sfx_land");
waveland_sound = asset_get("sfx_waveland_zet");
jump_sound = asset_get("sfx_jumpground");
djump_sound = asset_get("sfx_jumpair");
air_dodge_sound = asset_get("sfx_quick_dodge");

//visual offsets for when you're in Ranno's bubble
bubble_x = 0;
bubble_y = 8;

//=========================================================
// Balance variables

msg_fspecial_bubble_lockout = 8;
msg_fspecial_bubble_random_hsp_boost = 5;


msg_grab_effects[0] = {};

//=========================================================
// Attack variables
at_prev_dir_buffer = 0;
at_bspecial_last_move = { target:self, move:AT_TAUNT, small_sprites:0 };

msg_dair_earthquake_counter = 0;
msg_dair_earthquake_max = 30;

msg_fspecial_charge = 0;
msg_fspecial_is_charging = false;
msg_fspecial_ghost_arrow_active = false;
msg_fspecial_ghost_arrow_min_speed = 8;
msg_fspecial_ghost_arrow_target_distance = 100;

//=========================================================
// Visual effects
glitch_bg_spr = sprite_get("glitch_bg");
no_sprite = asset_get("empty_sprite");

//glitch-slide walk
msg_walk_start_x = x;

//glitch death
gfx_glitch_death = false;

//=========================================================
// NOTE: anything in here derives from inherently client-side data
//       instant desync if used anywhere near gameplay stuff 

//keep in sync with other_init, I need this block on everyone *including* myself!
msg_unsafe_paused_timer = 0;
//random value calculated by handler missingno.
msg_unsafe_random = current_time;
msg_unsafe_handler_id = self;

//missingno's Random is constant & dependent on individual frequency
//case 1: Missingno being unstable at higher damage
// - floor frequency/intensity of certain effects raised
//case 2: Missingno shaketrail while walking
// - specific state that induces frequency of an effect
//enemy randoms are temporary & decided by move interactions
//case 1:postgrab debuff
// - missingno starts effect timer & increases frequency of effect
msg_init_effects(true);

//=========================================================

// vvv LIBRARY DEFINES AND MACROS vvv
// DANGER File below this point will be overwritten! Generated defines and macros below.
// Write NO-INJECT in a comment above this area to disable injection.
#define msg_init_effects(is_missingno) // Version 0
    // initializes structures for all glitch VFX

    //random value calculated by handler missingno.
    msg_unsafe_random = current_time;
    msg_unsafe_handler_id = (is_missingno ? self : other);

    //ability to restore draw parameters
    msg_anim_backup =
    {
        small_sprites:0,
        sprite_index:0, image_index:0,
        spr_angle:0, draw_x:0, draw_y:0
    }

    //Namespace for effect structures
    msg_unsafe_effects = {
        master_effect_timer: 0, //resets all frequencies to zero if zero
        effects_list:[] //shortcut to iterate through all effects
    }

    //===========================================================
    //effect type: DRAW PARAMETER
    msg_unsafe_effects.shudder = msg_make_effect();
    //Parameters
    msg_unsafe_effects.shudder.horz_max = 8; //maximum horizontal displacement
    msg_unsafe_effects.shudder.vert_max = 8; //maximum vertical displacement

    //===========================================================
    //effect type: REDRAW
    msg_unsafe_effects.bad_vsync = msg_make_effect();
    //Parameters
    msg_unsafe_effects.bad_vsync.horz_max = 8; //maximum horizontal displacement of middle segment
    //Outputs
    msg_unsafe_effects.bad_vsync.cliptop = 0; //top of middle segment
    msg_unsafe_effects.bad_vsync.clipbot = 0; //bottom of middle segment
    msg_unsafe_effects.bad_vsync.horz = 0; //displacement of middle segment

    //===========================================================
    //effect type: REDRAW
    msg_unsafe_effects.bad_axis = msg_make_effect();

    //===========================================================
    //effect type: REDRAW
    msg_unsafe_effects.bad_crop = msg_make_effect();

#define msg_make_effect // Version 0
    // initializes a standard VFX structure
    var fx = {
                master_flag: false, //true if controlled by master_effect_timer (in game frames)
                freq:0,      //chance per frame of activating, from 0 to 16
                timer:0,     //time of effect duration (in draw frames)
                impulse:0,   //if not zero, timer * impulse is used to scale parameters
             };

    //append to list directly
    array_push(msg_unsafe_effects.effects_list, fx);
    return fx;
// DANGER: Write your code ABOVE the LIBRARY DEFINES AND MACROS header or it will be overwritten!