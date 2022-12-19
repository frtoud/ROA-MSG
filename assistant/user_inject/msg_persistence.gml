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