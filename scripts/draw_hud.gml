//TODO: remove if it's still empty
if ("msg_grab_rotation" not in self) exit;

var grabnames = "0x";
for (var i = 0; i < 4; i++)
{
    grabnames += (msg_grab_last_outcome == i) ? msg_grab_broken_outcome.name
                                              : msg_grab_rotation[i].name;
}

draw_debug_text(temp_x-4, temp_y-12, grabnames);


if !get_match_setting(SET_HITBOX_VIS) exit;

var h = 20;
var keys = variable_instance_get_names(msg_unsafe_effects);
for (var k = 0; k < array_length(keys); k++)
{
    if (keys[k] == "effects_list") continue;
    var fx = variable_instance_get(msg_unsafe_effects, keys[k]);
    var fx_str = keys[k] + ":{";
    fx_str += "g" + string(fx.gameplay_timer);
    fx_str +=",f" + string(fx.freq);
    fx_str +=",t" + string(fx.timer);
    fx_str +=",i" + string(fx.impulse);
    fx_str +=",z" + string(fx.frozen);
    fx_str += "}";
    draw_debug_text(temp_x-4, h, fx_str); h+=20;

    var fx_str = "";
    var fxkeys = variable_instance_get_names(fx);
    for (var fk = 0; fk < array_length(fxkeys); fk++)
    {
        var param = fxkeys[fk];
        if (param == "gameplay_timer") or (param == "gameplay_timer")or (param == "freq") 
        or (param == "timer") or (param == "impulse") or (param == "frozen") continue;

        fx_str += param + ":" + string(variable_instance_get(fx, param)) + ",";
    }
    draw_debug_text(temp_x-4, h, fx_str); h+=20;
}