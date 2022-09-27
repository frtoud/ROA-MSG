//B - Reversals
if (attack == AT_NSPECIAL || attack == AT_FSPECIAL || attack == AT_DSPECIAL || attack == AT_USPECIAL)
{
    trigger_b_reverse();
}

//=============================================================
// BSPECIAL: propagate inputs to relevant variable
// only affects this frame because these input flags will get reset anyways
if (msg_is_bspecial) switch (attack)
{
    case AT_FTILT: case AT_DTILT: case AT_UTILT:
    case AT_NAIR: case AT_FAIR: case AT_DAIR: case AT_BAIR: case AT_UAIR:
        attack_down = special_down;
        attack_pressed = special_pressed;
    break;
    case AT_FSTRONG: case AT_USTRONG: case AT_DSTRONG:
        strong_down = special_down;
        strong_pressed = special_pressed;
    break;
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
                set_window_value(AT_FTILT, 4, AG_WINDOW_ANIM_FRAME_START, 2);
                set_window_value(AT_FTILT, 5, AG_WINDOW_LENGTH, 8);
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
                set_window_value(AT_FTILT, 5, AG_WINDOW_LENGTH, 12);
                if (window_timer == 2)
                {
                    //setup interpolation & teleport
                    var distance = point_distance(x, y, msg_ntilt_origin.x, msg_ntilt_origin.y);
                    if (distance > 20)
                    {
                        if (distance > 60)
                            set_window_value(AT_FTILT, 4, AG_WINDOW_ANIM_FRAME_START, 1);

                        msg_dstrong_yoyo.active = true;
                        msg_dstrong_yoyo.visible = false;
                        msg_dstrong_yoyo.y = y - 48; msg_dstrong_yoyo.x = x + spr_dir * 40;

                        x = msg_ntilt_origin.x;
                        y = msg_ntilt_origin.y;
                    }
                }
            } break;
            case 4: // HIT
            {
                if (!hitpause) hsp = held_dir * walk_speed;
                move_cooldown[attack] = 16;
            }
        }
    } break;
//=============================================================
    case AT_DTILT:
    {
        var dmg = abs(get_player_damage(player)) % 10;
        if (attack_down && window == 3 && window_timer == 6)
        && (dmg == 7 || dmg == 1)
        {
            window = 2;
            window_timer = 0;
            sound_play(get_window_value(attack, 1, AG_WINDOW_SFX));
        }
        else if (window == 5 && has_hit && !was_parried)
        {
            can_jump = true;
        }
    } break;
//=============================================================
    case AT_DATTACK:
    {
        if (window > 2) && (window < 5) && !free
        {
            window = 5;
            window_timer = 0;
            sound_play(get_window_value(attack, 5, AG_WINDOW_SFX));
            destroy_hitboxes();
        }
        else if (window == 4) && (window_timer > get_window_value(attack, window, AG_WINDOW_CANCEL_FRAME))
        {
            window_timer--;
            can_jump = true;
        }
        else if (window == 5 && (window_timer >= get_window_value(attack, window, AG_WINDOW_LENGTH) - 1)
             && !free)
        {
            set_state(PS_CROUCH);
            state_timer += 2;
        }
        else if (has_hit && vsp > 0)
        {
            can_jump = true;
        }
    } break;
//=============================================================
    case AT_FSTRONG:
    {
        if (window == 1 && strong_charge > 0)
        {
            //fstrong's bug potentially active, check for collisions with projectiles?
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
        if (window == 1)
        {
            if (right_down - left_down) != 0
               spr_dir = (right_down - left_down);
        }
        else if (window == 3 && window_timer == 1 && !hitpause)
        {
            var hsp_base = hsp/3 + (2 + (strong_charge/60.0)) * (right_down - left_down);
            var vsp_base = vsp/3 + 1 * (right_down or left_down) - 2 * (strong_charge/60.0);

            var num_coins = 8 + (strong_charge/10);

            for (var i = 0; i < num_coins; i++)
            {
                var hb = create_hitbox(AT_USTRONG, 3, x, y-20);
                hb.hsp += hsp_base;
                hb.vsp += vsp_base;
                if (i != 0)
                {
                    var spread = (i < 6 ? 1 : 1.5);
                    hb.x += (random_func_2(2*i, 10, false) - 5);
                    hb.hsp += (random_func_2(2*i, spread*2, false) - spread);
                    hb.vsp += (random_func_2(2*i + 1, spread*2, false) - spread);
                }
            }
        }
    } break;
//=============================================================
    case AT_NAIR:
    {
        if (window == 1 && window_timer == 1 && !hitpause)
        {
            set_num_hitboxes(AT_NAIR, 1);
        }
        else if (has_hit)
        {
            set_num_hitboxes(AT_NAIR, 3);
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
        else if (window == 2)
        {
            window_timer = 1;
            if (!free) //manual looping due to strong_charge window incompatibility
            {
                window = 3; 
                window_timer = 0;
            }
            else if (!was_parried && !hitpause)
            {
                if (shield_pressed) set_state(PS_PRATFALL)
                else if (has_hit) can_jump = true;
            }
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
    case AT_BAIR:
    {
        if (window == 1 && window_timer == 2 && !hitpause)
        {
            //find target for BAIR's copying
            //closest thing to "next player" you can find
            var best_target = self;
            var best_player = player + 30; // simplifies subsequent checks
            with (oPlayer)
            {
                //want "next" player, but if there is none, wrap around from zero
                //this makes it so player 1 appears "after" player 4 in the ordering
                var corrected_player = (player > other.player ? player : player + 30);
                if (corrected_player < best_player)
                {
                    best_target = self;
                    best_player = corrected_player;
                }
            }
            msg_construct_bair(best_target);
        }
    } break;
//=============================================================
    case AT_UAIR:
    {
        if (window == 1 && window_timer == 1)
        {
            //apply current stack of bonuses
            var psn = false, prat = false;
            var bkb = 0, kbs = 0, dmg = 0;
            msg_uair_ace_coins = 0;
            reset_hitbox_value(AT_UAIR, 1, HG_DAMAGE);
            reset_hitbox_value(AT_UAIR, 1, HG_BASE_KNOCKBACK);
            reset_hitbox_value(AT_UAIR, 1, HG_KNOCKBACK_SCALING);
            for (var i = 0; i < array_length(msg_uair_ace_buffer); i++)
            {
                switch(msg_uair_ace_buffer[i])
                {
                    case AT_USPECIAL: prat = true; break;
                    //case AT_NSPECIAL: break;
                    //case AT_FSPECIAL: break;
                    case AT_NTHROW: take_damage(player, player, 4); break;
                    case AT_UTILT: y -= 80; break;
                    case AT_DTILT: kbs -= 0.2; break;
                    case AT_FTILT: bkb -= 2; break;
                    case AT_DATTACK: hsp += 5 * spr_dir; break;
                    case AT_USTRONG: msg_uair_ace_coins += 2; break;
                    case AT_DSTRONG: bkb += 2; break;
                    case AT_FSTRONG: kbs += 0.3; break;
                    case AT_NAIR: psn = true; break;
                    case AT_DAIR: vsp += 5; break;
                    case AT_FAIR: dmg += 3; break;
                    case AT_BAIR: hsp -= 4 * spr_dir; break;
                    case AT_UAIR:
                    default: break; //NO-OP
                    case AT_DSPECIAL_2: take_damage(player, player, 
                                       -get_attack_value(AT_DSPECIAL_2, AG_NUM_WINDOWS)); break; //???
                }
            }

            set_hitbox_value(AT_UAIR, 1, HG_EFFECT, (psn ? 10 : 0) );
            set_window_value(AT_UAIR, 3, AG_WINDOW_TYPE, (prat ? 7 : 0) );

            set_hitbox_value(AT_UAIR, 1, HG_DAMAGE, 
                             dmg + get_hitbox_value(AT_UAIR, 1, HG_DAMAGE));
            set_hitbox_value(AT_UAIR, 1, HG_BASE_KNOCKBACK, 
                             bkb + get_hitbox_value(AT_UAIR, 1, HG_BASE_KNOCKBACK));
            set_hitbox_value(AT_UAIR, 1, HG_KNOCKBACK_SCALING, 
                             kbs + get_hitbox_value(AT_UAIR, 1, HG_KNOCKBACK_SCALING));

            //activate write mode (on hit: UAIR will get saved)
            msg_uair_ace_activated = true;
        }
        //Coin effect (mostly copied from UStrong)
        else if (window == 2 && window_timer == 1 && !hitpause)
        {
            for (var i = 0; i < msg_uair_ace_coins; i++)
            {
                var hb = create_hitbox(AT_USTRONG, 3, x+spr_dir*35, y-20);
                hb.hsp += hsp;
                hb.vsp -= abs(vsp/3);
                if (i != 0)
                {
                    hb.x += (random_func_2(2*i, 10, false) - 5);
                    hb.hsp += (random_func_2(2*i, 3, false) - spread);
                    hb.vsp += (random_func_2(2*i + 1, 3, false) - spread);
                }
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
                window_timer = 0;  //manual looping due to strong_charge window incompatibility
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
            
            with (pHitBox) if (type == 2) && (hit_priority > 0) && (hsp != 0 || vsp != 0)
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

        if (window == 1)
        {
            msg_grab_selection_timer = 0;
        }
        else if (window == 3)
        {
            //grab failure
            //TODO: allow swapping of an index on whiff?
        }
        else if (window == 4) 
        {
            //grab-success
            destroy_hitboxes();
            if (msg_grab_selection_timer >= 40)
            || (window_timer > get_window_value(AT_NTHROW, window, AG_WINDOW_LENGTH) - 1)
            {
                //last frame of window. release grab
                var current_outcome = msg_grab_rotation[msg_grab_selected_index];
                
                //proceed with outcome
                window_timer = 0;
                window = current_outcome.window;
                    
                sound_stop(msg_grab_sfx);
                msg_grab_sfx = noone;
                
                //release grabbed victims
                with (oPlayer) if (msg_handler_id == other && msg_grabbed_timer > 0)
                {
                    msg_grab_immune_timer = other.msg_grab_immune_timer_max;
                }
                
                //rotate grab outcome selection
                msg_grab_pointer++;
                move_cooldown[AT_NTHROW] = msg_grab_immune_timer_max;
            }
            else 
            {
                //refresh grab on victims
                with (oPlayer) if (msg_handler_id == other && msg_grabbed_timer > 0)
                {
                    msg_grabbed_timer = 5;
                }

                if (window_timer < get_window_value(AT_NTHROW, window, AG_WINDOW_CANCEL_FRAME))
                {
                    //figure out which direction is being held
                    var temp_joydir = (spr_dir > 0) ? joy_dir : (180 - joy_dir);
                    if (joy_pad_idle) temp_joydir = 0;

                    var selected = floor((temp_joydir + 405)/90.0) % 4;
                    //FRONT: 0
                    //UP:    1
                    //BACK:  2
                    //DOWN:  3
                    selected = (msg_grab_pointer + selected) % array_length(msg_grab_rotation);

                    if (msg_grab_selected_index != selected)
                    {
                        sound_stop(msg_grab_sfx);
                        msg_grab_sfx = sound_play(msg_grab_rotation[selected].sound, true, 0, 1, 1);
                        msg_grab_selected_index = selected;

                        msg_grab_selection_timer = 0;
                    }
                }
            }
            msg_grab_selection_timer++;
        }

        //Grab outcomes
        //Note: window_timer 0 is accessible and occurs right after the detected end of window 4 above
        //=============================================================
        if (window == MSG_GRAB_FROSTBURN_WINDOW)
        {
            if (window_timer == 0 && !hitpause)
            with (oPlayer) if (msg_handler_id == other && msg_grabbed_timer > 0)
            {
                //victims need to be considered grounded to get properly frozen
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
                var curr_damage = get_player_damage(player);
                if (curr_damage > 0)
                {
                    var dmg = abs(floor(curr_damage * msg_grab_negative_multiplier));
                    set_player_damage(player, clamp(-dmg, -999, 999));
                }
                msg_negative_dmg_timer = msg_grab_negative_duration;
                //Need to handle self as "debuffed"
                msg_handler_id = self;
            }
        }
        else if (window == MSG_GRAB_GLITCHTIME_WINDOW)
        {
            if (window_timer == 0 && !hitpause)
            {
                //apply Glitch Time (to self)
                msg_doubled_time_timer = msg_grab_glitchtime_duration;
                //Need to handle self as "debuffed"
                msg_handler_id = self;
                msg_prev_status.x = x;
                msg_prev_status.y = y;
                msg_prev_status.hsp = hsp;
                msg_prev_status.vsp = vsp;
                msg_prev_status.state = state;
            }
        }
        else if (window == MSG_GRAB_ANTIBASH_WINDOW)
        {
            if (window_timer < get_window_value(AT_NTHROW, window, AG_WINDOW_CANCEL_FRAME))
            {
                var target_x = 0;
                var target_y = 0;

                with (oPlayer) if (msg_handler_id == other && msg_grabbed_timer > 0)
                {
                    msg_grabbed_timer = 10; //still technically in grab
                    if (!joy_pad_idle)
                    {
                        target_x += lengthdir_x(max(30, get_player_damage(player)), joy_dir);
                        target_y += lengthdir_y(max(30, get_player_damage(player)), joy_dir);
                    }
                }

                if (target_x == 0 && target_y == 0)
                {
                    if (joy_pad_idle) target_y  = -1;
                    else
                    {
                        target_x = lengthdir_x(1, joy_dir);
                        target_y = lengthdir_y(1, joy_dir);
                    }
                }

                msg_antibash_direction = point_direction(0,0,target_x,target_y);

                set_hitbox_value(AT_NTHROW, MSG_GRAB_ANTIBASH_HITBOX, HG_ANGLE, 
                    ( (spr_dir > 0) ? msg_antibash_direction : (180 - msg_antibash_direction) ) + 180);
            }
            else if (window_timer > get_window_value(AT_NTHROW, window, AG_WINDOW_LENGTH) - 1)
            {
                //eject MissingNo
                hsp = lengthdir_x(msg_grab_antibash_force, msg_antibash_direction);
                vsp = lengthdir_y(msg_grab_antibash_force, msg_antibash_direction);
                old_hsp = hsp;
                old_vsp = vsp;
                set_state(PS_PRATFALL)
            }
        }

    } break;
//=============================================================
    case AT_NSPECIAL:
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

            set_hitbox_value(AT_NSPECIAL, 1, HG_HITBOX_X, lenx);
            set_hitbox_value(AT_NSPECIAL, 1, HG_HITBOX_Y, leny - 30);
            set_hitbox_value(AT_NSPECIAL, 1, HG_PROJECTILE_HSPEED, lenx / 3);
            set_hitbox_value(AT_NSPECIAL, 1, HG_PROJECTILE_VSPEED, min(3, leny) - 4);
        }
    } break;
//=============================================================
    case AT_USPECIAL:
    {
        can_move = (window == 2 || window == 5);
        can_wall_jump = (window > 2);
        if (window == 3) && window_timer == get_window_value(attack, window, AG_WINDOW_CANCEL_FRAME)
        {
            can_wall_jump = true;
            var new_dir = (right_down - left_down);
            if (new_dir != 0) 
            {
                spr_dir = new_dir;
            }

            if (!special_down || msg_is_bspecial)
            {
                window = 5;
                window_timer = 0;
                if (msg_is_bspecial) 
                {
                    msg_uspecial_wraparound = true;
                    window_timer = 90;

                    msg_unsafe_effects.shudder.impulse = 20;
                    msg_unsafe_effects.shudder.horz_max = 6;
                    msg_unsafe_effects.shudder.vert_max = 6;
                }
                sound_play(msg_is_bspecial ? sound_get("079"): asset_get("sfx_mobile_gear_jump"))
            }
        }
        else if (window == 4)
        {

            if (!free)
            {
                window = 6;
                window_timer = 0;
                destroy_hitboxes();
            }
            else if (shield_down) && window_timer > 12
            {
                //hsp *= 0.4;
                //vsp *= 0.4;
                window = 5;
                window_timer = 0;
            }
            /*else if (window_timer == get_window_value(attack, window, AG_WINDOW_LENGTH) - 1)
            {
                window_timer = 1;
            }*/
        }
        else if (window == 5 && window_timer < 5)
        {
            hsp *= 0.4; 
            vsp *= 0.4; vsp -= 1;
        }
    } break;
//=============================================================
    case AT_TAUNT:
    {
        //clears saved attack index
        msg_bspecial_last_move.target = noone;
    } break;
    default: break;
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


//==============================================================
//passive charge glitch
if (msg_fstrong_interrupted_timer > 0)
{
    strong_charge = msg_fstrong_interrupted_timer;
    msg_fstrong_interrupted_timer = 0;

    //"diminishing returns" above 60 for two extra seconds worth of charge
    if (strong_charge > 60)
        strong_charge = 60 + min((strong_charge - 60)/2, 60);
}

if (strong_charge > 60) && window == get_attack_value(attack, AG_STRONG_CHARGE_WINDOW)
                        && window_timer == get_window_value(attack, window, AG_WINDOW_LENGTH) -1
{
    //skip strong charge frame to avoid resetting it
    var next_window = get_window_value(attack, window, AG_WINDOW_GOTO);
    window = (next_window == 0) ? window + 1 : next_window;
    window_timer = 0;
}

// #region vvv LIBRARY DEFINES AND MACROS vvv
// DANGER File below this point will be overwritten! Generated defines and macros below.
// Write NO-INJECT in a comment above this area to disable injection.
#define msg_construct_bair(target) // Version 0
    // steals physical statistics to dynamically determine BAIR's stats


    set_hitbox_value(AT_BAIR, 1, HG_DAMAGE, target.walljump_hsp);
    set_hitbox_value(AT_BAIR, 1, HG_ANGLE, target.char_height);
    set_hitbox_value(AT_BAIR, 1, HG_BASE_KNOCKBACK, target.initial_dash_speed);
    set_hitbox_value(AT_BAIR, 1, HG_KNOCKBACK_SCALING, target.gravity_speed);
    set_hitbox_value(AT_BAIR, 1, HG_BASE_HITPAUSE, target.max_jump_hsp);
    set_hitbox_value(AT_BAIR, 1, HG_HITPAUSE_SCALING, target.dash_stop_percent);
// DANGER: Write your code ABOVE the LIBRARY DEFINES AND MACROS header or it will be overwritten!
// #endregion