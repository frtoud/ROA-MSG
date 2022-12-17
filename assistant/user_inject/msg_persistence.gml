#macro IMPOSSIBLY_LONG_TIME 999999999999999999999999999999999999999999999
//====================================================================
#define msg_get_persistent_article()
{
    msg_requested_persistent_article = noone;
    user_event(7); //sets msg_requested_persistent_article 
    var article = msg_requested_persistent_article;
    msg_requested_persistent_article = noone;
    return article;
}
//====================================================================
#define msg_init_core(hitfx_core)
{
    with (hitfx_core)
    {
        achievement_fame = false;
        achievement_combo = false;
        achievement_matrix = false;
    }
}
//====================================================================
#define msg_refresh_core(hitfx_core)
{
    //making data last "forever"
    msb_data.pause = IMPOSSIBLY_LONG_TIME;
    msb_data.hit_length = IMPOSSIBLY_LONG_TIME;
    msb_data.pause_timer = 0;
    msb_data.step_timer = 0;
}
