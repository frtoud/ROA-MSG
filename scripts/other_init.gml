//other_init.gml

msg_handler_id = noone;
msg_grabbed_timer = 0;

msg_grab_immune_timer = 0;

// Leech Seed
msg_leechseed_timer = 0;
msg_leechseed_owner = noone; //if not noone, leech seed is active and heals THIS player.
// Negative DMG
msg_negative_dmg_timer = 0;


//initialize VFX
msg_init_effects(false);

// vvv LIBRARY DEFINES AND MACROS vvv
// DANGER File below this point will be overwritten! Generated defines and macros below.
// Write NO-INJECT in a comment above this area to disable injection.
#define msg_init_effects(is_missingno) // Version 0
    // =========================================================
    // initializes structures for all glitch VFX
    // NOTE: anything in here derives from inherently client-side data
    //       instant desync if used anywhere near gameplay stuff

    //MissingNo's own init.gml has already initialized everything here.
    //else, another MissingNo's other_init.gml might already have run through.
    if ("msg_unsafe_handler_id" in self) return;
    msg_is_missingno = is_missingno; //easier identification later

    //random value calculated by handler Missingno.
    msg_unsafe_random = current_time;
    msg_unsafe_handler_id = (is_missingno ? self : noone);

    //only relevant for Missingno
    msg_unsafe_paused_timer = 0;

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