//pseudoclone init

//article standard variables
visible = true;
uses_shader = false;
sprite_index = asset_get("empty_sprite");
mask_index = asset_get("empty_sprite");
can_be_grounded = false;
ignores_walls = false;

//standard logic
state = 0; //spawning
state_timer = 0;
needs_to_die = false; //kills the article

spawn_time = 15; //time it takes for copy to begin acting like player
max_lifetime = 8*60; //maximum time before a copy despawns
death_time = 30; //time it takes for copy to fade out


is_missingno_copy = true; //identifiable variable for elsewhere
//unique variable on a hitbox to check if it has been copied already
//needs to exist because could have multiple clones of a single player ergo multiple independent copies of hitboxes to manage
//WARNING: UNCERTAIN ABOUT THIS WORKING ONLINE. CHECK FOR DESYNCS
missingno_unique_identifier = "missingno_hitbox_was_copied_by" + string(self.id);

//copies have to swap with player in a specific way to make it more consistent
//logic is better if this swapping mechanic is only handled by one copy on behalf of all others
missingno_master_copy = noone;

//custom variables
client_id = noone; //which player object do we need to follow
client_offset_x = 0; //Relative distance to keep from player
client_offset_y = 0; //should stay constant

force_hitpause_cooldown = 0; //cannot attempt to force hitpause so that a move connects for this long after triggering it
force_hitpause_cooldown_max = 15;

//collision check data storage
collision_checks = 
{
    //if bumping into walls, ceilings, or ground, note difference between expected and current position

    x_displacement:0,
    y_displacement:0,

    on_plat:false,
    on_solid:false,

    hit_ceiling:false,
    hit_wall:false
}