
#define msg_init_effects(is_missingno)
//initializes structures for all glitch VFX

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

msg_unsafe_effects = 
{
    master_effect_timer: 0, //resets all frequencies to zero if zero

//===========================================================
    shudder:         //type: PARAMETER
    {
        //Standard
        master_flag: false, //controlled by master_effect_timer
        freq:0,      //chance per frame of activating, from 0 to 16
        timer:0,     //time of effect duration
        impulse:0,   //if not zero, timer * impulse * Params is used
        
        //Params
        horz_max:8,  //strengths of effect
        vert_max:8
    },

//===========================================================
    bad_vsync:       //type: REDRAW
    {
        //Standard
        master_flag: false, //true if controlled by master_effect_timer
        freq:0,      //chance per frame of activating, from 0 to 16
        timer:0,     //time of effect duration
        impulse:0,   //if not zero, timer * impulse * Params is used
        
        //Params
        horz_max:8,  //strength of middle segment's displacement
        
        //Output
        cliptop:0, 
        clipbot:0, 
        horz:0
    },
//===========================================================
    bad_axis:        //type: REDRAW
    {
        //Standard
        master_flag: false, //controlled by master_effect_timer
        freq:0,      //chance per frame of activating, from 0 to 16
        timer:0      //time of effect duration
    },
//===========================================================
    bad_crop:        //type: REDRAW
    {
        //Standard0
        master_flag: false, //controlled by master_effect_timer
        freq:0,      //chance per frame of activating, from 0 to 16
        timer:0      //time of effect duration
    }
//===========================================================
}
