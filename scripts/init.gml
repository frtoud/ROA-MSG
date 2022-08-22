
//Physical size
char_height = 72;
knockback_adj = 1.1; //the multiplier to KB dealt to you. 

//Hurtboxes
hurtbox_spr = sprite_get("idle_hurt");
crouchbox_spr = asset_get("orca_crouchbox");
air_hurtbox_spr = -1;
hitstun_hurtbox_spr = -1;

//Ground movement
walk_speed          = 3.15;
walk_accel          = 0.1;
walk_turn_time      = 8;    //note: influences window of grounded bspec input

initial_dash_time   = 14;
initial_dash_speed  = 6;
dash_speed          = 6.25;
dash_turn_time      = 8;    //note: influences window of grounded bspec input
dash_turn_accel     = 4.5;
dash_stop_time      = 4;
dash_stop_percent   = .05; //the value to multiply your hsp by when going into idle from dash or dashstop

ground_friction     = 0.45;
moonwalk_accel      = 1.8;

//Air movement
leave_ground_max    = 12; // maximum hsp you keep when you go from grounded to aerial without jumping
max_jump_hsp        = 12; // maximum hsp you can have when jumping from the ground
air_max_speed       = 5; // maximum hsp you can accelerate to when in a normal aerial state
jump_change         = 6; // maximum hsp when double jumping. If already going faster, it will not slow you down

air_friction        = .07;
air_accel           = .25;
prat_fall_accel     = .65; //multiplier of air_accel while in pratfall

max_fall            = 12; //maximum fall speed without fastfalling
fast_fall           = 16; //fast fall speed
gravity_speed       = .5;
hitstun_grav        = .5;

//Jumping
jump_start_time     = 5;
jump_speed          = 7.5; //boosted by msg_firstjump_timer
short_hop_speed     = 4.5;
double_jump_time    = 25; //the number of frames to play the djump animation. 
djump_speed         = 9;
max_djumps          = 2;

walljump_time       = 32;
walljump_hsp        = 7;
walljump_vsp        = 11;

land_time           = 6; //normal landing frames
prat_land_time      = 31;

//Shielding
roll_forward_max    = 7; //roll speed
roll_backward_max   = 7;
wave_friction       = .04; //grounded deceleration when wavelanding
wave_land_time      = 8;
wave_land_adj       = 1.35; //the multiplier to your initial hsp when wavelanding. Usually greater than 1
air_dodge_speed     = 6.5;
techroll_speed      = 10;

//Animation
idle_anim_speed = .1;
crouch_anim_speed = .25;
walk_anim_speed = .125;
dash_anim_speed = .2;
pratfall_anim_speed = .25;

//crouch animation frames
crouch_startup_frames = 2;
crouch_active_frames = 1;
crouch_recovery_frames = 2;

//parry animation frames
dodge_startup_frames = 1;
dodge_active_frames = 1;
dodge_recovery_frames = 3;

//tech animation frames
tech_active_frames = 3;
tech_recovery_frames = 1;

//tech roll animation frames
techroll_startup_frames = 1;
techroll_active_frames = 1;
techroll_recovery_frames = 1;

//airdodge animation frames
air_dodge_startup_frames = 1;
air_dodge_active_frames = 2;
air_dodge_recovery_frames = 3;

//roll animation frames
roll_forward_startup_frames = 1;
roll_forward_active_frames = 1;
roll_forward_recovery_frames = 1;
roll_back_startup_frames = 1;
roll_back_active_frames = 1;
roll_back_recovery_frames = 1;

//standard SFX
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
//CRAWLING
crawl_accel = 0.3;
crawl_speed = 5;
dashcrawl_accel = 0.8;
dashcrawl_speed = initial_dash_speed + 5; //restrained by initial_dash_speed when going forwards

msg_crawl_spr = sprite_get("crawl");
msg_crawlintro_timer = 0; //time in which to animate the transition into/from crawl
msg_crawl_anim_index = 0; //crawling animation

//=========================================================
//extra physics on first jump
msg_firstjump_timer_max = 8; //number of frames to apply extreme boost
msg_firstjump_timer = 0; //if between zero and _max, gets vsp boost

//=========================================================
// Balance variables
msg_ntilt_accel = 1.05;
msg_ntilt_maxspeed = dash_speed * 2.2;

msg_fspecial_bubble_lockout = 8;
msg_fspecial_bubble_random_hsp_boost = 5;
msg_fspecial_ghost_arrow_min_speed = 8;
msg_fspecial_ghost_arrow_target_distance = 100;

msg_grab_immune_timer_max = 240;

msg_grab_leechseed_delay = 30; //frames it takes to reach player
msg_grab_leechseed_duration = 60; //how long each poison stack lasts before being decremented
msg_grab_explode_penalty = 30; //damage cost of using Explosion
msg_grab_negative_multiplier = 2; // Amplifies the damage when going to negatives
msg_grab_negative_duration = 60*8; //how long before negative damage gets restored to positive
msg_grab_negative_bugfix_tolerance = 10; // ±damage tolerance to detect snap-to-zero glitch
msg_grab_glitchtime_duration = 60*8; //how long to stay in glitchtime debuff mode
msg_grab_antibash_force = 12; //how far to send Missingno after the bash


//=========================================================
// Attack variables
at_prev_spr_dir = 0;
at_prev_attack = AT_TAUNT;
at_prev_special_down = false; //edge detection. set to true by either update or set_attack

msg_bspecial_last_move = 
{ target:noone, move:AT_TAUNT, small_sprites:0 }; //if target is noone, actually uses at_prev_attack
msg_is_bspecial = false; //this move was input through BSPECIAL; extra considerations apply.

msg_air_tech_active = false; //if true, allows teching in midair. see update

msg_dstrong_yoyo = 
{
    x: 0,
    y: 0,
    active: false,
    visible: false
}

vfx_yoyo_snap = 
{
    x: 0,
    y: 0,
    spr: sprite_get("vfx_yoyo_snap"),
    timer: 0,
    angle: 0,
    length: 0,
}

msg_dair_earthquake_counter = 0;
msg_dair_earthquake_max = 10;

msg_uair_ace_activated = false; //if true, next melee hit will be saved
msg_uair_ace_buffer = [AT_UAIR, AT_UAIR]; //act as NOPs
msg_uair_ace_pointer = 0;
msg_uair_ace_coins = 0;

msg_fstrong_interrupted_timer = 0;

msg_ntilt_origin = { x:0, y:0 };

//See attacks -> grab.gml for the actual definition
var dummy_outcome = { name:"00", window:3, sound:asset_get("sfx_bubblepop")};
// list of outcomes selectable by direction inputs
msg_grab_pointer = 0;
msg_grab_rotation = [dummy_outcome];
msg_grab_selected_index = noone;  //selected index within msg_grab_rotation
msg_grab_selection_timer = 0;

//estimated maximum of particles at once (4/second, 2 at once, per victim)
//if you somehow exceed that number, it will start overwriting previous ones and... well, let's say its an intentional bug.
msg_leechseed_particle_number = 4 * (4 * msg_grab_leechseed_delay / msg_grab_leechseed_duration);
//Initialize a list of healy crystal shards, used for both gameplay and rendering
for (var i = msg_leechseed_particle_number-1; i >= 0; i--)
{ 
    msg_leechseed_particles[i] = { timer:0, x:0, y:0, source_x:0, source_y:0, mid_x:0, mid_y:0 } 
};
msg_leechseed_particle_pointer = 0;

//Explosion
msg_exploded_damage = 0; //to reapply once Missingno gets hit
msg_exploded_respawn = false; //to check wether a respawned missingno gets invincibility

msg_antibash_direction = 0; //where to send Missingno after the bash


msg_fspecial_charge = 0;
msg_fspecial_is_charging = false;
msg_collective_bubble_lockout = array_create(20, 0);
msg_fspecial_ghost_arrow_active = false;


msg_uspecial_wraparound = false; //while this is true, you get one free vertical wraparound + solid intangibility
msg_uspecial_wraparound_require_pratfall = false; //once wraparound happens, apply pratfall first chance you get

//Copy of other_init
msg_common_init();

//=========================================================
// Visual effects
AG_MSG_ALT_SPRITES = 39; //Array of alternate sprites to use. see set_attack.gml

msg_alt_sprite = noone;
glitch_bg_spr = sprite_get("glitch_bg");
no_sprite = asset_get("empty_sprite");

jump_sprite = sprite_get("jump");
djump_sprite = sprite_get("doublejump");

//Grab
msg_grab_sfx = noone; //looping grab SFX that is currently playing (if any)

vfx_healing = asset_get("abyss_hp_idle_spr"); //uses 6 subimages, [9, 14]

hfx_ball_open = hit_fx_create(sprite_get("vfx_ball_open"), 15);

sfx_sd = sound_get("selfdestruct_hit");
sfx_error = sound_get("error");

//glitch-slide walk
msg_walk_start_x = x;

//glitch death
gfx_glitch_death = false;

//gaslight rolls
msg_gaslight_dodge = { x:0, y:0, active:true };


//TBD: move to article?
msg_is_online = false;
msg_local_player = player;
for (var cur = 0; cur < 4; cur++) 
if (get_player_hud_color(cur+1) == $64e542) //online-only color 
{
    msg_local_player = cur+1;
    msg_is_online = true;
    break;
}

//initialize VFX
msg_init_effects(true);

//removes special rendering shenanigans
msg_low_fps_mode = false; //pointless?
//flag to help prevent Rivals outright crashing if an error interrupts pre_draw code at the wrong time
msg_draw_is_in_progress_temp_flag_should_never_be_true_outside_pre_draw = false;

//=========================================================

// #region vvv LIBRARY DEFINES AND MACROS vvv
// DANGER File below this point will be overwritten! Generated defines and macros below.
// Write NO-INJECT in a comment above this area to disable injection.
#define msg_init_effects(is_missingno) // Version 0
    // =========================================================
    // initializes structures for all glitch VFX
    // NOTE: anything in here derives from inherently client-side data
    //       instant desync if used anywhere near gameplay stuff
    // easier identification later
    if (is_missingno)
    {
        msg_is_missingno = true;

    }
    //A ditto match can involve multiple MissingNo other_init.gml running here. on top of their own inits.
    //initialize everything "generic" once only
    //==========================================================
    if ("msg_unsafe_handler_id" not in self)
    {
        //initialize everything here
        msg_is_missingno = false;
        msg_unsafe_random = current_time + player;
        msg_unsafe_paused_timer = 0; //for pausing the RNG

        msg_unsafe_handler_id = noone;
        msg_unsafe_garbage = msg_make_garbage(asset_get("bug_idle"), 2); //updated once in a while

        //ability to restore draw parameters
        msg_anim_backup = {
            small_sprites:0,
            sprite_index:0, image_index:0,
            spr_angle:0, draw_x:0, draw_y:0
        }

        //Namespace for effect structures
        msg_unsafe_effects = {
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
        msg_unsafe_effects.bad_vsync.garbage = false; //middle segment taken from wrong sprite if true

        //===========================================================
        //effect type: REDRAW
        msg_unsafe_effects.quadrant = msg_make_effect();
        msg_unsafe_effects.quadrant.source = [0, 1, 2, 3]; //which corner to draw
        msg_unsafe_effects.quadrant.garbage = [false, false, false, false]; //does this draw from wrong sprite?

        //===========================================================
        //effect type: REDRAW
        msg_unsafe_effects.bad_crop = msg_make_effect();

    } //end for generics
    //==========================================================
    if (is_missingno) //MissingNo's own special init steps
    {
        msg_is_missingno = true;
        msg_unsafe_handler_id = self;

        msg_garbage_collection[15] = msg_make_garbage(asset_get("zet_taunt"), 2);
        msg_garbage_collection[14] = msg_make_garbage(asset_get("brad_walljump"), 2);
        msg_garbage_collection[13] = msg_make_garbage(asset_get("burrito_rock_walkturn"), 2);
        msg_garbage_collection[12] = msg_make_garbage(asset_get("orca_fair"), 2);
        msg_garbage_collection[11] = msg_make_garbage(asset_get("poet_dspecial"), 2);
        msg_garbage_collection[10] = msg_make_garbage(asset_get("goat_spinhurt"), 2);
        msg_garbage_collection[9]  = msg_make_garbage(asset_get("rag_plant_attack"), 1);
        msg_garbage_collection[8]  = msg_make_garbage(asset_get("panda_idle"), 2);
        msg_garbage_collection[7]  = msg_make_garbage(asset_get("sword_uair_spr"), 2);
        msg_garbage_collection[6]  = msg_make_garbage(asset_get("mech_dashstop"), 2);
        msg_garbage_collection[5]  = msg_make_garbage(asset_get("wolf_genesis_taunt"), 2);
        msg_garbage_collection[4]  = msg_make_garbage(asset_get("tux_utilt_spr"), 2);
        msg_garbage_collection[3]  = msg_make_garbage(asset_get("cat_usmash"), 2);
        msg_garbage_collection[2]  = msg_make_garbage(asset_get("gus_jump_flex"), 2);
        msg_garbage_collection[1]  = msg_make_garbage(asset_get("ex_idle"), 1);
        msg_garbage_collection[0]  = msg_make_garbage(sprite_get("idle"), 2);

        msg_unsafe_garbage = msg_garbage_collection[player];
    }

#define msg_make_garbage(spr, scale) // Version 0
    // create a garbage entry out of any sprite.
    {
        return { spr: spr,
                 scale: scale,
                 width: sprite_get_width(spr),
                 height: sprite_get_height(spr),
                 x_offset: sprite_get_xoffset(spr),
                 y_offset: sprite_get_yoffset(spr)
               }
    }

#define msg_make_effect // Version 0
    // initializes a standard VFX structure
    var fx = {
                gameplay_timer: 0, //if zero; resets frequency. may count as effect duration. (in game frames)
                freq:0,        //chance per frame of activating; exact ratio varies
                timer:0,       //time of effect duration (in draw frames)
                impulse:0,     //effect duration, also scales intensity (in draw frames)
                frozen:false   //if true, locks the effect in its current state
             };
    // standard behavior as follows:
    //
    // gameplay_timer counts down (gameframe)
    //    if zero, freq & frozen resets
    //
    //    if freq rolls success OR impulse, roll parameters & timer
    //    if timer, apply parameters
    //       if !frozen, count down (drawframes)


    //append to list directly
    array_push(msg_unsafe_effects.effects_list, fx);
    return fx;

#define msg_common_init // Version 0
    // initialize variables for debuffs and oddities
    {
        msg_handler_id = noone;
        msg_grabbed_timer = 0;

        msg_grab_immune_timer = 0;

        // Leech Seed
        msg_leechseed_timer = 0;
        msg_leechseed_owner = noone; //if not noone, leech seed is active and heals THIS player.
        // Negative DMG
        msg_negative_dmg_timer = 0;
        //ACTUAL BUG: getting hit by <0 hitboxes (or uncharged strongs) while in negative damage resets % to zero
        msg_last_known_damage = 0;
        //Glitched double-time
        msg_doubled_time_timer = 0;
        msg_has_doubled_frame = false;
        msg_prev_status = { state:0, x:0, y:0, hsp:0, vsp:0 };

        msg_clone_microplatform = noone; //clone pseudoground
        msg_clone_tempswaptarget = noone; //where the true player must return after a special interaction
        msg_clone_last_attack_that_needed_offedge = noone;
    }
// DANGER: Write your code ABOVE the LIBRARY DEFINES AND MACROS header or it will be overwritten!
// #endregion