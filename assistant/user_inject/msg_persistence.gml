//====================================================================
#define msg_find_persistent_article()
{
    var ret = noone;
    with (asset_get("obj_article3")) if ("missingno" == num)
    {
        ret = self; break;
    }

    if !instance_exists(ret)
    {
        ret = instance_create(0, 0, "obj_article3");
        ret.num = "missingno";
        ret.persistent = true;
        ret.uses_shader = false;
    }

    if !instance_exists(ret)  
       print("MSG: Could not find or create persistent article");

    return ret;
}