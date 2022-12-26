
//(R,G,B) - (H,S,V)
//NB. needs to overlap slightly so ordering is important

// 30: 30: 30 -   0:  0: 11 - Ghost (Sprite)
// 24: 24: 31 - 240: 22: 12 - Ghost (Portrait)
// 47: 47: 59 - 240: 20: 23 - Ghost Hightlight (Portrait)
set_color_profile_slot(0, 0,  24,  24, 31);
set_color_profile_slot_range(0, 180, 100, 15);

//122:122:153 - 240: 20: 60 - Lavender
//158:155:171 - 251:  9: 67 - Light Lavender (Portrait)
set_color_profile_slot(0, 1, 122, 122, 153);
set_color_profile_slot_range(1, 180, 100, 35);

//229:174:135 -  24: 41: 89 - Flesh
//219:183:162 -  22: 26: 85 - Light Flesh (Portrait)
set_color_profile_slot(0, 2, 229, 174, 135);
set_color_profile_slot_range(2, 180, 100, 20);

//255:255:230 -  60:  9:100 - Bone
set_color_profile_slot(0, 3, 255, 255, 230);
set_color_profile_slot_range(3, 180, 100, 10);

// 64:255: 64 -  120: 75:100 - undefined
//  0:255:128 -  150:100:100 - uNDEfiNED
//128:255:  0 -   90:100:100 - undEFinEd
//  0:255:  0 -  120:100:100 - uNdEfiNEd
set_color_profile_slot(0, 4,  64, 255,  64);
set_color_profile_slot(0, 5,   0, 255, 128);
set_color_profile_slot(0, 6, 128, 255,   0);
set_color_profile_slot(0, 7,   0, 255,   0);
set_color_profile_slot_range(4,   1,   1, 1);
set_color_profile_slot_range(5,   1,   1, 1);
set_color_profile_slot_range(6,   1,   1, 1);
set_color_profile_slot_range(7,   1,   1, 1);

var num_colors = 16
set_num_palettes(num_colors);

//0x726E8
set_color_profile_slot(1, 0,  30,  30,  30);
set_color_profile_slot(1, 1, 111, 151, 199);
set_color_profile_slot(1, 2, 167, 199, 231);
set_color_profile_slot(1, 3, 255, 255, 230);

//0x726F0
set_color_profile_slot(2, 0,  30,  30,  30);
set_color_profile_slot(2, 1, 207,  79,  47);
set_color_profile_slot(2, 2, 247, 159,  79);
set_color_profile_slot(2, 3, 255, 255, 230);

//0x72710
set_color_profile_slot(3, 0,  30,  30,  30);
set_color_profile_slot(3, 1,  71, 159,  87);
set_color_profile_slot(3, 2, 159, 207, 127);
set_color_profile_slot(3, 3, 255, 255, 230);

//0x72728
set_color_profile_slot(4, 0,  30,  30,  30);
set_color_profile_slot(4, 1, 129, 129, 129);
set_color_profile_slot(4, 2, 170, 170, 170);
set_color_profile_slot(4, 3, 255, 255, 230);

//0x72720
set_color_profile_slot(5, 0,  30,  30,  30);
set_color_profile_slot(5, 1, 207, 159,   0);
set_color_profile_slot(5, 2, 247, 223, 111);
set_color_profile_slot(5, 3, 255, 255, 230);

//0x72718
set_color_profile_slot(6, 0,  30,  30,  30);
set_color_profile_slot(6, 1, 223, 119, 167);
set_color_profile_slot(6, 2, 239, 175, 191);
set_color_profile_slot(6, 3, 255, 255, 230);

//0x72660
set_color_profile_slot(7, 0,  35,  67,  49);
set_color_profile_slot(7, 1,  83, 122,  62);
set_color_profile_slot(7, 2, 167, 186,  74);
set_color_profile_slot(7, 3, 211, 226, 154);

//negative colors
for (var k = 0; k < 7; k++)
{
   steal_color_profile_slot(8+k, 0, k, 3);
   steal_color_profile_slot(8+k, 1, k, 2);
   steal_color_profile_slot(8+k, 2, k, 1);
   steal_color_profile_slot(8+k, 3, k, 0);
}

//for low-fps mode undefined (doesnt affect slot zero)
for (var i = 1; i < num_colors; i++)
{
   steal_color_profile_slot(i, 4, i, 0);
   steal_color_profile_slot(i, 5, i, 1);
   steal_color_profile_slot(i, 6, i, 2);
   steal_color_profile_slot(i, 7, i, 3);
}

#define steal_color_profile_slot(target_color, target_shade, source_color, source_shade)
{
   set_color_profile_slot(target_color, target_shade,  
        get_color_profile_slot_r(source_color, source_shade),  
        get_color_profile_slot_g(source_color, source_shade),
        get_color_profile_slot_b(source_color, source_shade));
}