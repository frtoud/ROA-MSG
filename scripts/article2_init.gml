//pseudoclone init

//article standard variables
visible = true;
uses_shader = false;
sprite_index = asset_get("empty_sprite");
mask_index = asset_get("empty_sprite");
through_platforms = true;
can_be_grounded = false;
ignores_walls = true;


//custom variables
client_id = noone; //which player object do we need to follow
client_offset_x = 0; //Relative distance to keep from player
client_offset_y = 0; //should stay constant