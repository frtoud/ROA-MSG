//microplatform update

var should_die = false;

if (instance_exists(client_id))
{
    switch (die_condition)
    {
        //=======================================================
        case 1: //Exist for Hitstun
            should_die = (!client_id.hitpause) 
                      && (client_id.state_cat != SC_HITSTUN);
        break;
        //=======================================================
        default:
        case 0: //None. uses lifetime only.
            should_die = !(lifetime > 0);
        break;
        //=======================================================
    }
}
else
{
    should_die = !(lifetime > 0);
}


if (should_die && !(lifetime > 0))
{
    instance_destroy(); exit;
}
lifetime--;