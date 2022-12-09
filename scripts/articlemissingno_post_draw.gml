// NOTE:
// Missingno article come in pairs.
// master handles update logic
// clone only exists at a different depth to let master do two draw passes
if (master != self)
{
    with (master) draw_front();
}
else draw_back();

#define draw_back()
{
   //draw_sprite_tiled_ext(sprite_get("proj_payday"), 0, 10, 10, 1, 1, c_white, 1);
}
#define draw_front()
{
   //draw_sprite_tiled_ext(sprite_get("proj_pokeball"), 0, 0, 0, 1, 1, c_white, 1);
}