//css_draw.gml

exit;
var found = noone;
with (asset_get("obj_article3")) if ("missingno" == num)
{
    found = self;
    break;
}

if !instance_exists(found)
{
    found = instance_create(0, 0, "obj_article3");
    found.num = "missingno";
    found.persistent = true;
    found.uses_shader = false;
}

//show_debug_message("Variables for " + object_get_name(object_index) + string(id));