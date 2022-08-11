//TODO: remove if it's still empty
if ("msg_grab_rotation" not in self) exit;

var grabnames = "0x";
grabnames += msg_grab_rotation[(msg_grab_pointer)     % array_length(msg_grab_rotation)].name;
grabnames += msg_grab_rotation[(msg_grab_pointer + 1) % array_length(msg_grab_rotation)].name;
grabnames += msg_grab_rotation[(msg_grab_pointer + 2) % array_length(msg_grab_rotation)].name;
grabnames += msg_grab_rotation[(msg_grab_pointer + 3) % array_length(msg_grab_rotation)].name;

draw_debug_text(temp_x-4, temp_y-12, grabnames);