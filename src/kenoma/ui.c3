
module pleroma::kenoma;
import pleroma;
import std::io;


Texture* tiled_background;
Font*    font;

float font_size    = 12;
float font_spacing = 0;
Color font_color   = raylib::DARKGRAY;
Color bg_default   = raylib::WHITE;
Color bg_selected  = raylib::GRAY;
Color bg_disabled  = raylib::DARKGRAY;


enum GuiStyle {
  FONT_SIZE,
  FONT_SPACING,
  FONT_COLOR,
  BG_COLOR_DEFAULT,
  BG_COLOR_SELECTED,
  BG_COLOR_DISABLED,
}

<**>
fn void check_font() {
  if (font == null) {
    font = mem::new(Font);
    *font = font::get_default();
  }
}

<**>
fn void set_font(Font* newfont) @export("kenoma_setfont") => font = newfont;
<**>
fn void set_style(GuiStyle style, int value) @export("kenoma_setstyle") {
  switch (style) {
    case FONT_SIZE:    font_size    = value;
    case FONT_SPACING: font_spacing = value;
    case FONT_COLOR:   font_color   = ((uint)value).to_color();
    default:
  }
}


