
/*
var str = get_player_name(player);
var out = "out: ";

for (var i = 0; i <= string_length(str); i++)
{
  out  += string_char_at(str, i) + " - " + string(ord(string_char_at(str, i))) + " ; "
}*/
//get_string(out, out);

// out: あ - 12354 ; あ - 12354 ; い - 12356 ; う - 12358 ; え - 12360 ; お - 12362 ; ぁ - 12353 ; 
// out: み - 12415 ; み - 12415 ; ま - 12414 ; む - 12416 ; め - 12417 ; も - 12418 ; ァ - 12449 ; 

//     numbers     characters (need GHJMS)    kanji (exclude)
var str = "0123456789 ABCDEFGHIJKLMNOPQRSTUVWXYZ あァル"
var out = "";
var array = [0,0,0,0,0,0,0,0,0,1, //important spots in the array (map to GHJMS) (and space)
             1,0,1,0,0,1,0,0,0,0,
             0,1,0,0,0,0,0,0,0,0,
             0,0,0,0,0,0,0,0,0,0 ]

for (var i = 1; i <= string_length(str); i++)
{
    var o = ord(string_char_at(str, i));
    out  += o < 12000 ? string(array[ (o + 18) % 40 ]) : "x" // (ord + 18) % 40 maps to array neatly
}


print(str);
print(out);

