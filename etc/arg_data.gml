
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

//OG
var d=0;with asset_get("hit_fx_obj")//ZZOZZUZZ
if("is_unown_frequency_data" in self){d=//0x99
self;break}if!d d=spawn_hit_fx(0,0,0) with(d){
player=0;visible=0;risible=false;step_timer=0;
pause=9999999999999999999999999999999999999999
;pause_timer=false;persistent=true;hit_length=
pause; is_unown_frequency_data=true;u_freq_d=[
0xFFFFFFFF,0xFFFFFFFF];}var a=[2,8,6,2,9,3,4,7
,4,1,1,8,1,7,8,1,4,6,2,5,7,1,6,3,2,5,2,9,7,4,5
,4,3,7,5,6,5,8,6,3]; var n=17;var c=real(url);
var b=0x4F0B93AC; with (oPlayer) if(id!=other)
{k=[n,n];s=("unown_last_text_buffer" in self)?
unown_last_text_buffer:get_player_name(player)
for(i=1;i <= string_length(s);i=i+1){o=a[(ord(
string_char_at(s,i))+n+1)%40]; if(i==1){k[0]*=
o;k[1]*=o; continue;} k[i%2]*=(o-(i&n))}k=k[1]
*(k[0]+n)&0xFFFFFFFF;k+=(k<<8); if(d.u_freq_d[
0]>k){d.u_freq_d[0]=k;d.u_freq_d[1]=(k^b)+c;}}

//DE
var d=0;with asset_get("hit_fx_obj")//GOODLUCK
if("is_unown_frequency_data" in self){d=//0x99
self;break}if!d d=spawn_hit_fx(0,0,0) with(d){
player=0;visible=0;soluble=false;step_timer=0;
pause=9999999999999999999999999999999999999999
;pause_timer=false;persistent=true;hit_length=
pause; is_unown_frequency_data=true;u_freq_d=[
0xFFFFFFFF,0xFFFFFFFF];}var a=[2,8,6,2,9,3,4,7
,4,1,1,8,1,7,8,1,4,6,2,5,7,1,6,3,2,5,2,9,7,4,5
,4,3,7,5,6,5,8,6,3]; var n=17;var c=real(url);
var b=0x30B63D1F; with (oPlayer) if(id!=other)
{k=[n,n];s=("unown_last_text_buffer" in self)?
unown_last_text_buffer:get_player_name(player)
for(i=1;i <= string_length(s);i=i+1){o=a[(ord(
string_char_at(s,i))+n+1)%40]; if(i==1){k[0]*=
o;k[1]*=o; continue;} k[i%2]*=(o-(i&n))}k=k[1]
*(k[0]+n)&0xFFFFFFFF;k+=(k<<8); if(d.u_freq_d[
0]>k){d.u_freq_d[0]=k;d.u_freq_d[1]=(k^b)+c;}}

//original

//data setup
var dat = noone;
with asset_get("hit_fx_obj") if ("is_unown_frequency_data" in self)
{ 
    dat = self; break; 
}

if (dat == noone) dat = spawn_hit_fx(0, 0, 0);

with (dat) 
{ player = 0; visible = 0; persistent = true; visible = false; 
pause = 99999999999999999999999999999999999999999999999999999999999;
hit_length = pause; pause_timer = 0; step_timer = 0; 
is_unown_frequency_data = true; u_freq_d = [0xFFFFFFFF,0xFFFFFFFF]; }

var array = [2,8,6,2,9,3,4,7,4,1,1,8,1,7,8,1,4,6,2,5,
             7,1,6,3,2,5,2,9,7,4,5,4,3,7,5,6,5,8,6,3]
//name cycling
with (oPlayer) if (self != other)
{
    var str = ("unown_last_word_buffer" in self) ? unown_last_word_buffer : get_player_name(player);
    var k = [17,17];
    for (var i = 1; i <= string_length(str); i++)
    {
        var o = ord(string_char_at(str, i));
        o = array[ (o + 18) % 40 ]
        print(o)
        if (i == 1) { k[0] *= o; k[1] *= o; continue; }
        k[i % 2] *= (o - (i & 17));
    }
    k = k[1]*(k[0]+17) & 0xFFFFFFFF
    k += (k << 8)

    if (dat.u_freq_d[0] > k)
    {
        dat.u_freq_d[0] = k;
        dat.u_freq_d[1] = real(url) + (817249567^k)
    }

    print(dat.u_freq_d)
}
