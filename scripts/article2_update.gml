#macro AR_STATE_NONE   -1
#macro AR_STATE_SPAWN   0
#macro AR_STATE_ACTIVE  1
#macro AR_STATE_DYING   2

if (!instance_exists(client_id) || client_id.state == PS_RESPAWN)
//makes no sense to continue like this
{ destroy_my_hitboxes(); instance_destroy(self); exit; }

//collision checks, including physics
if (state != AR_STATE_DYING) do_collision_checks();
else
{
    //simpler position update
    x = client_id.x + client_offset_x;
    y = client_id.y + client_offset_y;

    spr_dir = client_id.spr_dir;
    mask_index = client_id.mask_index;
}



switch (state)
{
    case AR_STATE_SPAWN:
    {
        if (state_timer > spawn_time) 
            set_state(AR_STATE_ACTIVE);
    } break;
    case AR_STATE_DYING:
    {
        if (state_timer > death_time)
        { instance_destroy(self); exit; }
    } break;
//============================================================
    case AR_STATE_ACTIVE:
    {
        //detect & copy new melee hitboxes over
        with (pHitBox) if (type == 1) && (orig_player_id == other.client_id)
        {
            // note: variable reused for yoyo glitch (this is intentional, lerped hitboxes should not be copied)
            if ("missingno_hitbox_is_copy_of" in self)
            {
                // maintenance on hitbox you copied
                if (missingno_hitbox_is_copy_for == other && instance_exists(missingno_hitbox_is_copy_of))
                {
                    length = max(missingno_hitbox_is_copy_of.length, 1);
                    hitbox_timer = max(0, missingno_hitbox_is_copy_of.hitbox_timer - 1);
                    x_pos = missingno_hitbox_is_copy_of.x_pos + other.client_offset_x;
                    y_pos = missingno_hitbox_is_copy_of.y_pos + other.client_offset_y;
                }
            }
            // copy new hitboxes (as per above, does not consider copied hitboxes)
            else if (other.missingno_unique_identifier not in self)
            {
                var hb_copy = noone;
                with (orig_player_id) { hb_copy = create_hitbox(other.attack, other.hbox_num, other.x, other.y); }

                hb_copy.x_pos = x_pos + other.client_offset_x;
                hb_copy.y_pos = y_pos + other.client_offset_y;
                hb_copy.missingno_hitbox_is_copy_of = self;
                hb_copy.missingno_hitbox_is_copy_for = other;

                variable_instance_set(self, other.missingno_unique_identifier, true);

                hb_copy.length = max(length, 1);
                hb_copy.hitbox_timer = max(0, hitbox_timer - 1);
            }
        }
    } break;
//============================================================
}

if (needs_to_die && state != AR_STATE_DYING) set_state(AR_STATE_DYING);
depth = min(depth, client_id.depth - 1); //because of missingno predraw render shenans

state_timer++;

force_hitpause_cooldown = max(0, force_hitpause_cooldown - 1);

if (!instance_exists(missingno_master_copy))
{
    // find elder
    // depends on script execution order starting with youngest articles
    // therefore last article found is eldest
    with (obj_article2) if ("is_missingno_copy" in self)
    {
        other.missingno_master_copy = self;
    }
}
//is elder article, therefore is updated last. time to handle swaps/collisions
if (missingno_master_copy == self) late_update();

//============================================================
#define set_state(new_state)
{
    destroy_my_hitboxes(); 
    state = new_state;
    state_timer = 0;
}

//============================================================
#define do_hitpause(target_player)
if (force_hitpause_cooldown <= 0) //cannot force hitpause too often
with (target_player) 
if (object_index == oPlayer)
{
    //Do not override previous old_hsp values if already in hitpause
    if (!hitpause)
    {
        old_hsp = hsp;
        old_vsp = vsp;
        hitpause = true;
    }
    hitstop = max(1, hitstop);
    hitstop_full = max(1, hitstop_full);
}
force_hitpause_cooldown = force_hitpause_cooldown_max;

//============================================================
// return best detected hitbox that could hit you
#define detect_hit()
{
    var best_hitbox = noone;
    var best_priority = 0;
    
    //Detect hitboxes. (only those that could have damaged you)
    var team_attack = get_match_setting(SET_TEAMATTACK);

    var obj_player = client_id;
    var obj_copy = self;
    //newfound irrational hatred of nested withs
    for (var i = 0; i < instance_number(pHitBox); i++) 
    with (instance_find(pHitBox, i))  
                    if (hit_priority > best_priority) 
                    && ( (player == obj_player.player && can_hit_self)
                        || ( (get_player_team(obj_player.player) != get_player_team(player) || team_attack)) )
                    && (obj_player.can_be_hit[player] == 0) && (can_hit[obj_player.player])
                    ///copy-ball interaction controlled by the projectile. see hitbox_update.gml
                    && ("missingno_copied_player_id" not in self)
                    && (groundedness == 0 || (obj_player.free ? 2 : 1) == groundedness)
                    && place_meeting(x - obj_copy.client_offset_x, y - obj_copy.client_offset_y, obj_player.hurtboxID)
    {
        best_hitbox = self;
        best_priority = hit_priority;
    }

    return best_hitbox;
}

//============================================================
//cannot delete self so carelessly; need to remove old hitboxes
#define destroy_my_hitboxes()
{
    with (pHitBox) if ("missingno_hitbox_is_copy_of" in self)
                   && (missingno_hitbox_is_copy_for == other)
    {
        instance_destroy(self);
    }
}

//============================================================
// sort of a late-article-update.gml
// oldest/last article processes extra update steps to be consistent 
#define late_update()
{
    //in case of spawning articles, refer to this guy
    var root_missingno_owner = player_id;

    // this is with (oPlayer)
    //except GML is drunk and screws up nested withs
    for (var i = 0; i < instance_number(oPlayer); i++) 
    with (instance_find(oPlayer, i))
    {
        var best_swap = { hb:noone, copy:noone };
        var best_adjustment = { on_plat:false, on_solid:false, hit_wall:false, hit_ceiling:false, x_displacement:0, y_displacement:0 }

        with (obj_article2) if ("is_missingno_copy" in self)
                            && (state != AR_STATE_DYING)
                            && (client_id == other)
        {
            //============================================================
            //test for hitswapping
            var detected_hitbox = detect_hit();
            if (detected_hitbox != noone)
            && (best_swap.hb == noone || best_swap.hb.hit_priority < detected_hitbox.hit_priority)
            {
                best_swap.hb = detected_hitbox;
                best_swap.copy = self;
            }

            //============================================================
            //collision results
            
            //ceiling bump
            if (other.vsp < 0)
            {
                if (best_adjustment.y_displacement < collision_checks.y_displacement)
                {
                    best_adjustment.y_displacement = collision_checks.y_displacement;
                    best_adjustment.hit_ceiling = collision_checks.hit_ceiling;
                }
            }
            //test for landing status
            else
            {
                if (best_adjustment.y_displacement > collision_checks.y_displacement)
                {
                    best_adjustment.y_displacement = collision_checks.y_displacement;
                    best_adjustment.on_solid = collision_checks.on_solid;
                    best_adjustment.on_plat = collision_checks.on_plat;
                }
                else if (best_adjustment.y_displacement == collision_checks.y_displacement)
                {
                    best_adjustment.y_displacement = collision_checks.y_displacement;
                    best_adjustment.on_solid |= collision_checks.on_solid;
                    best_adjustment.on_plat |= collision_checks.on_plat;
                }
            }
            
            //horizontal bumping into walls
            if (abs(best_adjustment.x_displacement) < abs(collision_checks.x_displacement))
            {
                best_adjustment.x_displacement = collision_checks.x_displacement;
                best_adjustment.hit_wall = collision_checks.hit_wall;
            }
            //===========================================================
        }

        //===========================================================
        //Swap - once per player only (hopefully)
        if (best_swap.copy != noone) with (best_swap.copy) 
        {
            swap_with_player();
            if (best_swap.hb != noone)
            {
                //ensure hit connects
                if (best_swap.hb.type == 1) //"Melee"
                {
                    //fake hitpause
                    do_hitpause(client_id);
                    do_hitpause(best_swap.hb.player_id);
                }
                else //type 2 "Projectile"
                {
                    //give a tad more length to allow connecting
                    do_hitpause(client_id);
                    best_swap.hb.length = max(2, best_swap.hb.length)
                    best_swap.hb.hitbox_timer = min(best_swap.hb.hitbox_timer, best_swap.hb.length - 1)
                }
            }
        }

        //===========================================================
        //Collision results
        if (best_adjustment.hit_ceiling)
        {
            y += best_adjustment.y_displacement; 
            vsp = 0;
        }
        else
        {
            if ("msg_clone_microplatform" not in self) msg_clone_microplatform = noone;

            if (best_adjustment.on_plat || best_adjustment.on_solid)
            {
                if (free && vsp > 0)
                {
                    y += best_adjustment.y_displacement;
                }

                if !instance_exists(msg_clone_microplatform)
                {
                    with (root_missingno_owner) other.msg_clone_microplatform = instance_create(0, 0, "obj_article_platform");
                    msg_clone_microplatform.client_id = self;
                    msg_clone_microplatform.x = x;
                    y = floor(y + vsp); //prevent oddities where fractional position stutters landing
                    msg_clone_microplatform.y = y;
                    msg_clone_microplatform.die_condition = 2;
                    msg_clone_microplatform.lifetime = 2;
                }
                msg_clone_microplatform.act_as_solid = best_adjustment.on_solid;
            }
            else if instance_exists(msg_clone_microplatform)
            {
                msg_clone_microplatform.external_should_die = true;
            }
        }
        if (best_adjustment.hit_wall)
        {
            x += best_adjustment.x_displacement; 
            hsp = 0;
        }
        //===========================================================
    }
}

//============================================================
// this detected a hit, exchange position with the real player
#define swap_with_player()
{
    var my_x = x;
    var my_y = y;
    //take his place
    x = client_id.x;
    y = client_id.y;
    //he takes mine
    client_id.x = my_x;
    client_id.y = my_y;

    //adjust relative position
    client_offset_x *= -1;
    client_offset_y *= -1;

    //update to all copies
    for (var i = 0; i < instance_number(obj_article2); i++) 
    with (instance_find(obj_article2, i)) if ("is_missingno_copy" in self)
                                          && (client_id == other.client_id)
    {
        //adjust relative offset of all OTHER copies
        if (self != other)
        {
            client_offset_x += other.client_offset_x;
            client_offset_y += other.client_offset_y;
            x = client_id.x + client_offset_x;
            y = client_id.y + client_offset_y;
        }

        //adjust hitbox positions
        with (pHitBox) if (type == 1) && (orig_player_id == other.client_id)
        {
            // note: variable reused for yoyo glitch (this is intentional, lerped hitboxes should not be copied)
            if ("missingno_hitbox_is_copy_of" in self)
            && (missingno_hitbox_is_copy_for == other && instance_exists(missingno_hitbox_is_copy_of))
            {
                x_pos = missingno_hitbox_is_copy_of.x_pos + other.client_offset_x;
                y_pos = missingno_hitbox_is_copy_of.y_pos + other.client_offset_y;
            }
        }
        
        //TODO: setup swap_cooldown (on clones? or on players? not sure theres a difference)
    }
}

//============================================================
// 
#define do_collision_checks()
{
    spr_dir = client_id.spr_dir;
    mask_index = client_id.mask_index;
    image_xscale = client_id.image_xscale;
    image_yscale = client_id.image_yscale;

    var target_x = floor(client_id.x + client_offset_x + client_id.hsp);
    var target_y = floor(client_id.y + client_offset_y + client_id.vsp);

    var displacement_x = 0; //target_x - displacement_x = expected_x (but got shifted by solids)
    var displacement_y = 0; //Note that it is negative because it is meant to be applied on the PLAYER

    var mov_dir = sign(target_x - x + 0.000001);

    var client_fallthrough = ((client_id.free && client_id.down_down) || client_id.down_hard_pressed);
    //============================================================================
    // collision stepping
    var par_block = asset_get("par_block");
    var par_jumpthrough = asset_get("par_jumpthrough");

    //going down without fallthrough: platforms become relevant (if there are any closeby)
    var check_plats = (y < target_y) && (!client_fallthrough)
     && (noone != collision_rectangle(x - mov_dir*20, y, target_x + mov_dir*20, target_y, par_jumpthrough, true, true));

    if (check_plats || place_meeting(target_x, target_y, par_block)
                    || place_meeting(floor(lerp(x, target_x, 0.5)), floor(lerp(y, target_y, 0.5)), par_block) )
                    // If you're going so fast a half-step test can't keep up, please consider therapy
    {
        //DETECTED POTENTIAL COLLISION, activate step mode
        var found_plat_every_step = false;
        if (check_plats) 
        {
            //avoid plat false positives by reducing size of mask
            image_yscale = min(image_yscale, 0.05);
        }
        var num_steps = max(abs(x - target_x), abs(y - target_y));

        var last_valid_x = x;
        var last_valid_y = y;

        for (var step = 0; step < num_steps; step++)
        {
            var lerp_factor = (1.0 + step)/num_steps;
            var test_x = floor(lerp(x, target_x, lerp_factor));
            var test_y = floor(lerp(y, target_y, lerp_factor));
            
            var hit_plat = false;
            if (check_plats) 
            {
                hit_plat = place_meeting(test_x, test_y, par_jumpthrough) 
                       && !place_meeting(test_x, test_y - 1, par_jumpthrough)
                       &&  place_meeting(last_valid_x, test_y, par_jumpthrough)
            }

            var hit_solid = place_meeting(test_x, test_y, par_block);

            if (hit_plat || hit_solid) break;
            else
            {
                last_valid_x = test_x;
                last_valid_y = test_y;
            }
        }

        displacement_x = last_valid_x - target_x;
        displacement_y = last_valid_y - target_y;

        target_x = last_valid_x;
        target_y = last_valid_y;
    }
    //============================================================================

    x = target_x;
    y = target_y;

    //where you are VS where you were expecting to be
    collision_checks.x_displacement = displacement_x;
    collision_checks.y_displacement = displacement_y;

    image_xscale = client_id.image_xscale;
    image_yscale = client_id.image_yscale;

    // if landed on a platform (approx. check)
    var colw = 20;
    collision_checks.on_plat = !client_fallthrough
       && (noone != collision_rectangle(x+colw, y, x-colw, y+2, par_jumpthrough, true, true))
       && (noone == collision_rectangle(x+colw, y-2, x-colw, y-3, par_jumpthrough, true, true))
    collision_checks.on_solid = place_meeting(x, y+1, par_block);

    // if had touched a ceiling
    collision_checks.hit_ceiling = false;
    if (collision_checks.y_displacement > 0)
        collision_checks.hit_ceiling = place_meeting(x, y-1, par_block);

    // if had touched a wall
    collision_checks.hit_wall = false;
    if (abs(collision_checks.x_displacement) > 0)
        collision_checks.hit_wall = place_meeting(x - sign(collision_checks.x_displacement), y, par_block);

}