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
#macro PERS_UNKNOWN      0
#macro PERS_MENUS        1
#macro PERS_MILESTONES   2
#macro PERS_CSS          3
#macro PERS_SSS          4
#macro PERS_MATCH        5
#macro PERS_RESULTS      6

