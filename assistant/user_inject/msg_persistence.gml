//====================================================================
#define msg_find_persistent_article()
{
    var ret = noone;
    with (asset_get("obj_article3")) if ("missingno" == num)
    {
        ret = master; break;
    }

    if !instance_exists(ret)
    {
        ret = instance_create(0, 0, "obj_article3");
        ret.num = "missingno";
        ret.persistent = true;
        ret.uses_shader = false;

        //only exists as an extra hook for master article
        var clone = instance_create(0, 0, "obj_article3");
        clone.num = "missingno";
        clone.persistent = true;
        clone.uses_shader = false;

        ret.master = ref;
        clone.master = ret;
        ret.clone = clone;
        clone.clone = clone;
    }

    if !instance_exists(ret)  
       print("MSG: Could not find or create persistent articles");

    return ret;
}

//NOTES:
//what if multiple masters? what if multiple clones? (unlikely)
//what if clone but no master? master but no clone? (more likely)
//naive implementation enough for now