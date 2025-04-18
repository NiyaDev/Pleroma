
module pleroma::kenoma;
import pleroma;


<* Drawing and logic for Buttons *>
fn bool button(Rectangle rect, String text, bool active) @export("kenoma_button") {
  check_font();

  bool clicked = false;

  Color col = bg_default;
  Vector2 mouse = raylib::get_mouse_position().mul_f(render_res);
  if ((mouse.x > rect.x && mouse.x < rect.x + rect.width) && (mouse.y > rect.y && mouse.y < rect.y + rect.height)) {
    col = bg_selected;
    if (raylib::is_mouse_button_down(LEFT))  col = bg_interact;
    if (raylib::is_mouse_button_released(LEFT)) clicked = true;
  }
  if (!active) col = bg_disabled;
  

  tiled_texture(rect, col);
 
  Rectangle label_rect = rect;
  Vector2 textsize = font.measure(text, font_size, font_spacing);
  label_rect.x += (rect.width / 2) - (textsize.x / 2);
  label_rect.y += (rect.height / 2) - (textsize.y / 2);
  label(label_rect, text);

  return clicked;
}

<* Drawing for tiled textures *>
fn void tiled_texture(Rectangle rect, Color tint) @export("kenoma_tiletexture") {
  tiled_background.draw_npatch(tiled_background.npatch(), rect, {0,0}, 0, tint);
}

