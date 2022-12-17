//persistence initialization

//we want to ensure these three things exist
var msg_master = noone; //persistent article, to run code where we shouldn't >:]
var msg_clone = noone; //master's partner in crime, to draw at two different depths at once
var msg_core = noone; //persistent hitfx, to hold more long-term data

//find existing hitfx data
with asset_get("hit_fx_obj") if ("missingno_persistence_cookie_token_thing" in self)
{
    if (msg_core == noone) msg_core = self;
    else instance_destroy(self);
}

//find existing articles
with asset_get("obj_article3") if (num == "missingno")
{
    if (msg_master == noone) && (self == self.master) msg_master = self;
    else if (msg_clone == noone) && (self == self.clone) msg_clone = self;
    else instance_destroy(self);
}

//something not found? create it
if (msg_master == noone)
{
    msg_master = instance_create(0, 0, "obj_article3");
    msg_master.num = "missingno";
    msg_master.persistent = true;
    msg_master.uses_shader = false;
}
if (msg_clone == noone)
{
    msg_clone = instance_create(0, 0, "obj_article3");
    msg_clone.num = "missingno";
    msg_clone.persistent = true;
    msg_clone.uses_shader = false;
}
if (msg_core == noone)
{
    with (msg_master) msg_core = spawn_hit_fx(0, 0, 0);
    msg_core.missingno_persistence_cookie_token_thing = true;
    msg_core.persistent = true;
    msg_core.visible = false;
    msg_core.player = 0;

    // initialize persistent data
    msg_init_core(msg_core);

    // longevity
    msg_refresh_core(msg_core);
}

//link them
if instance_exists(msg_master)
&& instance_exists(msg_clone)
&& instance_exists(msg_core)
{
    msg_master.master = self;
    msg_master.clone = msg_clone;
    msg_master.core = msg_core;

    msg_clone.master = msg_master;
    msg_clone.clone = self;
    msg_clone.core = msg_core;
}
else print("SEGFAULT!! could not create persistence");

//return by setting missingno_requested_persistent_article as output
missingno_requested_persistent_article = msg_master;

// #region vvv LIBRARY DEFINES AND MACROS vvv
// DANGER File below this point will be overwritten! Generated defines and macros below.
// Write NO-INJECT in a comment above this area to disable injection.
#define msg_init_core(hitfx_core) // Version 0
    with (hitfx_core)
    {
        achievement_fame = false;
        achievement_combo = false;
        achievement_matrix = false;
    }

#define msg_refresh_core(hitfx_core) // Version 0
    // making data last "forever"
    msb_data.pause = IMPOSSIBLY_LONG_TIME;
    msb_data.hit_length = IMPOSSIBLY_LONG_TIME;
    msb_data.pause_timer = 0;
    msb_data.step_timer = 0;

#macro IMPOSSIBLY_LONG_TIME 999999999999999999999999999999999999999999999
// DANGER: Write your code ABOVE the LIBRARY DEFINES AND MACROS header or it will be overwritten!
// #endregion