// NOTE:
// Missingno article come in pairs.
// master handles update logic
// clone only exists at a different depth to let master do two draw passes
if (master != self) exit;



if (string_pos("*", keyboard_string) > 0)
{
    depth++;
}
if (string_pos("/", keyboard_string) > 0)
{
    depth--;
}

//increment/decrement FPS
var delta_fps = string_count("+", keyboard_string) 
              - string_count("-", keyboard_string);
if (delta_fps != 0) 
{
    
    clone.depth += delta_fps;
}

keyboard_string = "";

print(current_time);