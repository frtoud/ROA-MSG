//B - Reversals
if (attack == AT_NSPECIAL || attack == AT_FSPECIAL || attack == AT_DSPECIAL || attack == AT_USPECIAL)
{
    trigger_b_reverse();
}

switch (attack)
{
//=============================================================
    case AT_FTILT:
    {
        off_edge = true;
        var held_dir = (right_down - left_down);

        //walking logic
        if (window == 1)
        || (window == 2 && window_timer < get_window_value(AT_FTILT, 2, AG_WINDOW_CANCEL_FRAME))
        || (window == 5 && abs(hsp) > 0.25)
        {
            var actual_frict = free ? air_friction : ground_friction;
            var actual_accel = actual_frict + (free ? air_accel : walk_accel);
            var actual_max = max(abs(hsp), free ? air_max_speed : walk_speed);

            //friction can kick in (if direction not held)
            if (left_down == right_down) 
            { 
                hsp -= sign(hsp) * min(abs(hsp), actual_frict);
            }

            else if (held_dir == spr_dir)
            {
                //walking forward
                hsp = clamp(hsp + spr_dir*actual_accel, -actual_max, actual_max);
            }
        }

        switch (window)
        {
            case 1: //STARTUP
            {
                set_attack_value(AT_FTILT, AG_NO_PARRY_STUN, 1);
                if (attack_down)
                && (window_timer == get_window_value(AT_FTILT, 1, AG_WINDOW_LENGTH))
                {
                    window = 2;
                    window_timer = 0;

                    msg_ntilt_origin.x = x;
                    msg_ntilt_origin.y = y;
                }
            } break;
            case 2: // DRAG
            {
                if (window_timer < get_window_value(AT_FTILT, 2, AG_WINDOW_CANCEL_FRAME))
                {
                    if (!attack_down) { window = 4; window_timer = 0; }
                }
                else
                {
                    if (!attack_down) { window = 3; window_timer = 0; }
                    else
                    {
                        if (held_dir != spr_dir) //not holding forward
                        && (abs(hsp) < walk_speed) //point of no return
                        {
                            hsp *= 0.90;
                        }
                        else if (abs(hsp) > 1.2 * walk_speed) || (held_dir == spr_dir)
                        {
                            //accelerate
                            hsp = clamp(hsp * msg_ntilt_accel, -msg_ntilt_maxspeed, msg_ntilt_maxspeed);
                        }
                    }
                }
            } break;
            case 3: // DRAG END
            {
                set_attack_value(AT_FTILT, AG_NO_PARRY_STUN, 0);
                if (window_timer == 2)
                {
                    //setup interpolation & teleport
                    if (point_distance(x, y, msg_ntilt_origin.x, msg_ntilt_origin.y) > 20)
                    {
                        msg_dstrong_yoyo.active = true;
                        msg_dstrong_yoyo.visible = false;
                        msg_dstrong_yoyo.y = y - 40; msg_dstrong_yoyo.x = x;

                        x = msg_ntilt_origin.x;
                        y = msg_ntilt_origin.y;
                    }
                }
            } break;
            case 4: // HIT
            {
                hsp = held_dir * walk_speed;

            }
        }
    } break;
//=============================================================
    case AT_DSTRONG:
    {
        if (window == 2 && has_hit && !free && strong_charge > 0)
        && (shield_pressed && (right_down - left_down) != 0)
        {
            //yoyo activated, rolling out
            msg_dstrong_yoyo.active = true;
            msg_dstrong_yoyo.visible = true;
            msg_dstrong_yoyo.x = x; msg_dstrong_yoyo.y = y;

            set_state( (right_down - left_down)*spr_dir > 0 ? PS_ROLL_FORWARD : PS_ROLL_BACKWARD);
        }
    } break;
//=============================================================
    case AT_USTRONG:
    {
        if (window == 2 && window_timer == 1 && !hitpause)
        {
            var hsp_base = 3*(right_down - left_down);
            var vsp_base = 2*(right_down or left_down);
            for (var n = 0; n < 8; n++)
            {
                var hb = create_hitbox(AT_USTRONG, 3, x, y-20);
                hb.hsp += hsp_base + random_func_2(2*n, 4, false) - 2;
                hb.vsp += vsp_base + random_func_2(2*n + 1, 4, false) - 2;
            }
        }
    } break;
//=============================================================
    case AT_DAIR:
    {
        can_move = window == 1;
        if (window == 1)
        {
            msg_dair_earthquake_counter = 0;
        }
        else if (window == 3 && window_timer == 1 && !hitpause)
        {
            sound_play(asset_get("sfx_kragg_rock_shatter"));
            //spawn_dust_fx(x, y)
            shake_camera(8, 5);
            
            //landed: try finding an edge
            var depth_check = 5;
            var length_check = 12;
            //landed on leftmost side?
            var left_test = (noone == collision_line(x-length_check, y, x-length_check, y+depth_check, 
                                      asset_get("par_block"), true, true))
                         && (noone == collision_line(x-length_check, y, x-length_check, y+depth_check, 
                                      asset_get("par_jumpthrough"), true, true));
                                          
            //landed on rightmost side?
            var right_test = (noone == collision_line(x+length_check, y, x+length_check, y+depth_check, 
                                       asset_get("par_block"), true, true))
                          && (noone == collision_line(x+length_check, y, x+length_check, y+depth_check, 
                                       asset_get("par_jumpthrough"), true, true));
                                       
            if (msg_dair_earthquake_counter < msg_dair_earthquake_max)
            && (left_test xor right_test)
            {
                window = 2;
                window_timer = 3;
                msg_dair_earthquake_counter++;
                y -= 8;

                msg_unsafe_effects.shudder.timer = 12;
                msg_unsafe_effects.shudder.horz_max = 24;
            }
        }
    } break;
//=============================================================
    case AT_FSPECIAL: // Charge & Water Gun
    {
        if (window == 2)
        {
            can_wall_jump = true;
            can_shield = true;
            if (msg_fspecial_ghost_arrow_active)
            {
                window = 5;
                window_timer = 0;
                msg_fspecial_ghost_arrow_active = false;
            }
            else if (window_timer == get_window_value(AT_FSPECIAL, 2, AG_WINDOW_LENGTH) - 1)
            && (msg_fspecial_charge < 2) && special_down
            {
                msg_fspecial_charge++;
                sound_play(asset_get("sfx_may_arc_cointoss"));
            }
            else if (!special_down)
            {
                if (msg_fspecial_charge == 0)
                {
                    window = 3;
                    window_timer = 0;
                }
                else if (msg_fspecial_charge == 1)
                {
                    set_attack(AT_FSPECIAL_2);
                }
                else
                {
                    set_attack(AT_FSPECIAL_AIR);
                }
                msg_fspecial_charge = 0;
                state_timer = 0;
            }
        }
        else if (window == 5 && window_timer == get_window_value(AT_FSPECIAL, 5, AG_WINDOW_LENGTH) - 1)
        {
            //try to find a projectile to steal
            var closest_dist = -1;
            var found_proj = noone;
            
            with (pHitBox) if (type == 2) && (hsp != 0 || vsp != 0)
            && (closest_dist < 0 || closest_dist > distance_to_point(other.x, other.y))
            {
                found_proj = self;
            }
            
            if (found_proj != noone)
            {
                //steal it: cannot hit me anymore
                found_proj.can_hit_self = true;
                found_proj.can_hit[found_proj.player_id.player] = true;
                found_proj.can_hit[player] = false;
                
                // and throw it (sort of like water gun)
                found_proj.x = x + spr_dir*get_hitbox_value(AT_FSPECIAL, 1, HG_HITBOX_X);
                found_proj.y = y + get_hitbox_value(AT_FSPECIAL, 1, HG_HITBOX_Y);
                
                found_proj.hsp = spr_dir * max(msg_fspecial_ghost_arrow_min_speed, 
                                 point_distance(0, 0, found_proj.hsp, found_proj.vsp));
                found_proj.vsp = -found_proj.grav * 
                                 (1.0 * msg_fspecial_ghost_arrow_target_distance/found_proj.hsp);
                
                sound_play(asset_get("sfx_watergun_fire"));

                set_window_value(AT_FSPECIAL, 5, AG_WINDOW_GOTO, 6);
            }
            else //return to water gun
            {
                set_window_value(AT_FSPECIAL, 5, AG_WINDOW_GOTO, 4);
            }
        }
    } break;
//=============================================================
    case AT_FSPECIAL_2: // Bubblebeam
    {
        if (window == 2)
        {
            var hitbox = create_hitbox(AT_FSPECIAL_2, 1, x+(spr_dir*20), y-30);
            hitbox.hsp += spr_dir * msg_fspecial_bubble_random_hsp_boost 
                                  * (0.5 - random_func(0, 100, true)/ 100.0);
            hitbox.image_index = 2 * random_func(1, 6, true);
        }
    } break;
//=============================================================
    case AT_FSPECIAL_AIR: // Hydro Pump
    {
        if (window == 2)
        {
            hsp *= 0.8;
            vsp *= 0.5;
        }
    } break;
//=============================================================
    case AT_NTHROW:
    {
        can_fast_fall = false;
        can_move = false;
        if (window == 3)
        {
            //grab failure
            //TODO: allow swapping of an index on whiff
        }
        else if (window == 4) 
        {
            //grab-success
            destroy_hitboxes();
            if (window_timer > get_window_value(AT_NTHROW, window, AG_WINDOW_LENGTH) - 1)
            {
                //last frame of window. release grab
                var current_outcome = msg_grab_rotation[msg_grab_selected_index];
                
                window_timer = 0;
                window = current_outcome.window;
                    
                sound_stop(msg_grab_sfx);
                msg_grab_sfx = noone;
                
                //release grabbed victims
                with (oPlayer) if (msg_handler_id == other && msg_grabbed_timer > 0)
                {
                    msg_grab_immune_timer = other.msg_grab_immune_timer_max;
                }
                
                ///rotate grab outcome selection
                msg_grab_rotation[msg_grab_selected_index] = msg_grab_queue[msg_grab_queue_pointer];
                msg_grab_queue[msg_grab_queue_pointer] = current_outcome;
                msg_grab_queue_pointer = (msg_grab_queue_pointer + 1) % array_length(msg_grab_queue)
                
                msg_grab_selected = noone;
            }
            else
            {
                //refresh grab on victims
                with (oPlayer) if (msg_handler_id == other && msg_grabbed_timer > 0)
                {
                    msg_grabbed_timer = 5;
                }
                
                //figure out which direction is being held
                var selected = floor((joy_dir + 45)/90.0) % 4;
                //RIGHT: 0
                //UP:    1
                //LEFT:  2
                //DOWN:  3
                //TODO: adjust math to take into account spr_dir?
                
                if (msg_grab_selected_index != selected)
                {
                    sound_stop(msg_grab_sfx);
                    msg_grab_sfx = sound_play(msg_grab_rotation[selected].sound, true, 0, 1, 1);
                    msg_grab_selected_index = selected;
                }
            }
        }

        //Grab outcomes
        //Note: window_timer 0 is accessible and occurs right after the detected end of window 4 above
        //=============================================================
        if (window == MSG_GRAB_FROSTBURN_WINDOW)
        {
            if (window_timer == 0 && !hitpause)
            with (oPlayer) if (msg_handler_id == other && msg_grabbed_timer > 0)
            {
                //victims need to be considered grounded to be properly frozen
                free = false;
                with (other) //back to Missingno
                {
                    var a = instance_create(other.x, other.y, "obj_article_platform");
                    a.client_id = other;
                    a.die_condition = 1; //Hitstun
                }
            }
        }
        else if (window == MSG_GRAB_EXPLOSION_WINDOW)
        {
            visible = false;
            if (window_timer == 0 && !hitpause)
            {
                spawn_hit_fx( x, y -35, 143 );
                sound_play(sfx_sd);
                sound_play(asset_get("sfx_death1"));

                msg_exploded_damage += get_player_damage( player ) + msg_grab_explode_penalty;
                set_player_damage( player, 0 );
                msg_exploded_respawn = true;
            }
            else if (window_timer == 3)
            {
                x = room_width / 2;
                y = room_height / 2;
                set_state(PS_RESPAWN);
                state_timer = 30;
            }
        }
        else if (window == MSG_GRAB_NEGATIVE_WINDOW)
        {
            if (window_timer == 0 && !hitpause)
            {
                sound_play(sfx_error);
                //turn damage into negatives (and amplify it)
                var dmg = abs(floor(get_player_damage(player) * msg_grab_negative_multiplier));
                set_player_damage(player, clamp(-dmg, -999, 999));
                msg_negative_dmg_timer = msg_grab_negative_duration;

                //Need to handle self as "debuffed"
                msg_handler_id = self;
            }
        }
    } break;
//=============================================================
    case AT_DSPECIAL:
    {
        can_fast_fall = (window == 2 && window_timer > 16);
        if (window == 1) vsp *= 0.85;
        hsp *= 0.85;

        if (window == 1 && window_timer == get_window_value(attack, window, AG_WINDOW_LENGTH) - 1)
        {
            /*if (joy_pad_idle)
            {

            }
            else
            {
                (joy_dir > 90 && joy_dir < 270) 
            }*/
            var angle = joy_pad_idle ? 0 //flip joy_dir to cancel out spr_dir
                                     : (spr_dir > 0 ? joy_dir : 90 - (joy_dir - 90) );

            angle = (angle + 360) % 360;

            //deadzones
                 if (angle <  270 && angle >=  230) angle = 230;
            else if (angle <  310 && angle >=  270) angle = 310;
            else if (angle <= 120 && angle >   90) angle = 120;
            else if (angle <=  90 && angle >   60) angle = 60;

            var lenx = lengthdir_x(16, angle);
            var leny = lengthdir_y(4, angle);

            set_hitbox_value(AT_DSPECIAL, 1, HG_HITBOX_X, lenx);
            set_hitbox_value(AT_DSPECIAL, 1, HG_HITBOX_Y, leny - 30);
            set_hitbox_value(AT_DSPECIAL, 1, HG_PROJECTILE_HSPEED, lenx / 3);
            set_hitbox_value(AT_DSPECIAL, 1, HG_PROJECTILE_VSPEED, min(3, leny) - 4);
        }
    } break;
//=============================================================
    default: break;
}


if (attack == AT_USPECIAL){
    if (window == 1 && window_timer == 1){
        times_through = 0;
    }
    if (window == 2){
        if (window_timer == get_window_value(attack, 2, AG_WINDOW_LENGTH)){
            if (times_through < 10){
                times_through++;
                window_timer = 0;
            }
        }
        if (!joy_pad_idle){
            hsp += lengthdir_x(1, joy_dir);
            vsp += lengthdir_y(1, joy_dir);
        } else {
            hsp *= .6;
            vsp *= .6;
        }
        var fly_dir = point_direction(0,0,hsp,vsp);
        var fly_dist = point_distance(0,0,hsp,vsp);
        var max_speed = 12;
        if (fly_dist > max_speed){
            hsp = lengthdir_x(max_speed, fly_dir);
            vsp = lengthdir_y(max_speed, fly_dir);
        }
        if (special_pressed && times_through > 0){
            window = 4;
            window_timer = 0;
        }
        if (shield_pressed){
            window = 3;
            window_timer = 0;
        }
    }
    if (window > 3 && window < 6 && window_timer == get_window_value(attack, window, AG_WINDOW_LENGTH)){
        window++;
        window_timer = 0;
    }
}
/*
if (attack == AT_DSPECIAL && window_timer == 12 && window == 2 && false) {
    //set_player_damage(player, -500);
    var target = noone;
    with (oPlayer)
    {
        if (self != other)
        target = self;
    }
    //crashes when used with base cast
    //damage also switches
    var temp_player = self.player;
    self.player = target.player;
    self.hurtboxID.player = player;
    target.player = temp_player;
    target.hurtboxID.player = temp_player;
    
    
}
*/