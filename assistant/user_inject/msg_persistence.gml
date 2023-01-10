//====================================================================
#define msg_get_persistent_article()
{
    missingno_requested_persistent_article = noone;
    user_event(7); //sets missingno_requested_persistent_article 
    var article = missingno_requested_persistent_article;
    missingno_requested_persistent_article = noone;
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

//====================================================================
#define msg_draw_achievements(persistence)
    var spr = sprite_get("achievement");
    if instance_exists(persistence) with (persistence) msg_draw_achievement(spr);
//====================================================================
#define msg_draw_achievement(spr)
{
    if (achievement.end_time < current_time) return;
    //assumed called from the perspective of the master article holding the required information
    //bottom corner of screen: (960, 540)
    //size of achievement block: 240x94
    var popup_down = 540;
    var popup_up = popup_down - 94;
    var popup_x = 720;
    var popup_y = popup_up;

    //THX-UHC2
    if (current_time < achievement.rise_time)
    {
        popup_y = ease_linear(popup_down, popup_up, 
                              current_time - achievement.start_time, 
                              achievement.rise_time - achievement.start_time);
    }
    else if (current_time > achievement.fall_time)
    {
        popup_y = ease_linear(popup_up, popup_down, 
                              achievement.fall_time - current_time, 
                              achievement.fall_time - achievement.end_time);
    }

    draw_sprite(spr, achievement.id, popup_x, popup_y);
}

