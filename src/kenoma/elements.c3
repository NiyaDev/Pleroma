
module pleroma::kenoma;
import pleroma;
import std::io;


<* Drawing and logic for Buttons *>
fn bool button(Rectangle rect, String text, bool active) @export("kenoma_button") {
  check_font();

  bool clicked = false;

  Color col = bg_default;
  Vector2 mouse = raylib::get_mouse_position() * render_res;
  if ((mouse.x > rect.x && mouse.x < rect.x + rect.width) && (mouse.y > rect.y && mouse.y < rect.y + rect.height)) {
    col = bg_selected;
    if (raylib::is_mouse_button_down(LEFT))  col = bg_interact;
    if (raylib::is_mouse_button_released(LEFT)) clicked = true;
  }
  if (!active) col = bg_disabled;

  tiled_texture(rect, col);
 
  Rectangle label_rect = rect;
  Vector2 textsize = font.measure(text.zstr_tcopy(), font_size, font_spacing);
  label_rect.x += (rect.width / 2) - (textsize.x / 2);
  label_rect.y += (rect.height / 2) - (textsize.y / 2);
  label(label_rect, text);

  return clicked;
}
<* Drawing for tiled textures *>
fn void tiled_texture(Rectangle rect, Color tint) @export("kenoma_tiledtexture") {
  tiled_background.draw_npatch(tiled_background.npatch(), rect, {0,0}, 0, tint);
}
<* Drawing for Labels *>
fn void label(Rectangle rect, String text) @export("kenoma_label") {
  check_font();
  font.draw_pro(text.zstr_tcopy(), {rect.x, rect.y}, {0,0}, 0, font_size, font_spacing, font_color);
}
<* Drawing for Bars *>
fn void bar(Rectangle rect, float* current, float* max) @export("kenoma_bar") {
  float percentage = *current / *max;
  NPatchInfo np = {{0, 0, bar_bg.width, bar_bg.height}, bar_bg.width / 3, bar_bg.height, bar_bg.width / 3, bar_bg.height, THREE_PATCH_HORIZONTAL};
  Rectangle fillrect = rect;
  fillrect.width *= percentage;

  bar_bg.draw_npatch(np, rect, {0,0}, 0, bar_color);
  bar_fill.draw_npatch(np, fillrect, {0,0}, 0, bar_color);
}
<* Drawing for Dropdown menus *>
fn bool dropdown(Rectangle rect, String text, int* value, bool open) @export("kenoma_dropdown") {
  check_font();

  bool clicked = false;

  Color col = bg_default;
  Vector2 mouse = raylib::get_mouse_position() * render_res;
  if ((mouse.x > rect.x && mouse.x < rect.x + rect.width) && (mouse.y > rect.y && mouse.y < rect.y + rect.height)) {
    col = bg_selected;
    if (raylib::is_mouse_button_down(LEFT))  col = bg_interact;
    if (raylib::is_mouse_button_released(LEFT)) clicked = true;
  }

  // Draw background and text
  tiled_texture(rect, col);

  String[] split = text.split(allocator::heap(),"\n");
  defer free(split);

  Rectangle label_rect = rect;
  Vector2 textsize = font.measure(split[*value].zstr_tcopy(), font_size, font_spacing);
  label_rect.x += (rect.width / 2) - (textsize.x / 2);
  label_rect.y += (rect.height / 2) - (textsize.y / 2);
  label(label_rect, split[*value]);

  if (open) {
    Rectangle dropdown_rect = rect;
    dropdown_rect.y += dropdown_rect.height;
    dropdown_rect.height *= split.len;
    tiled_texture(dropdown_rect, bg_default);

    for (int i; i < split.len; i++) {
      Rectangle temp = rect;
      temp.y += (i * rect.height) + rect.height;
      if (button(temp, split[i], true)) {
        *value = i;
        return true;
      }
    }
  }

  return clicked;
}

