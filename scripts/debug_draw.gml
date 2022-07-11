//TODO: remove if it's still empty

var line = 0;
var offset = 15;

exit;
draw_debug_text(x-20, y+(offset*line++), "bbt " + string(bbox_right));
draw_debug_text(x-20, y+(offset*line++), "get_bbr " + string(sprite_get_bbox_right(sprite_index)));
draw_debug_text(x-20, y+(offset*line++), "bbl " + string(bbox_left));
draw_debug_text(x-20, y+(offset*line++), "get_bbl " + string(sprite_get_bbox_left(sprite_index)));

draw_debug_text(x-20, y+(offset*line++), "hsp " + string(hsp));
draw_debug_text(x-20, y+(offset*line++), "vsp " + string(vsp));


//var obj = instance_place( x, y+1, all);
draw_debug_text(x-20, y+(offset*line++), "hsp " + string(hsp));
draw_debug_text(x-20, y+(offset*line++), "state " + get_state_name(state));
draw_debug_text(x-20, y+(offset*line++), "state_timer " + string(state_timer));
draw_debug_text(x-20, y+(offset*line++), "crawl? " + string(msg_crawlintro_timer));
//draw_debug_text(x-20, y+(offset*line++), get_state_name(state));
//draw_debug_text(x-20, y+(offset*line++), "timer " + string(state_timer));
//draw_debug_text(x-20, y+(offset*line++), "window_timer " + string(window_timer));
//draw_debug_text(x-20, y+(offset*line++), "prev_dir " + string(at_prev_dir_buffer));