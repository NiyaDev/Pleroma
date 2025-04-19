
module pleroma::kenoma;
import pleroma;
import std::io;


Texture* tiled_background;
Texture* bar_bg;
Texture* bar_fill;
Font*    font;

float font_size    = 12;
float font_spacing = 0;
float render_res   = 1;
GuiTextAlignmentHori text_horizontal_alignment = CENTER;
GuiTextAlignmentVert text_vertical_alignment   = CENTER;
Color font_color   = raylib::DARKGRAY;
Color bg_default   = raylib::WHITE;
Color bg_selected  = raylib::GRAY;
Color bg_interact  = raylib::LIGHTGRAY;
Color bg_disabled  = raylib::DARKGRAY;
Color bar_color    = raylib::WHITE;



enum GuiStyle {
  FONT_SIZE,
  FONT_SPACING,
  TEXT_HORIZONTAL_ALIGNMENT,
  TEXT_VERTICAL_ALIGNMENT,
  FONT_COLOR,
  BG_COLOR_DEFAULT,
  BG_COLOR_SELECTED,
  BG_COLOR_INTERACT,
  BG_COLOR_DISABLED,
  RENDER_RESOLUTION,
  BAR_COLOR,
}

enum GuiTexture {
  TILED_BACKGROUND,
  BAR_BACKGROUND,
  BAR_FILL,
}

enum GuiTextAlignmentHori {
  LEFT,
  CENTER,
  RIGHT,
}
enum GuiTextAlignmentVert {
  TOP,
  CENTER,
  BOTTOM,
}

<* Check if font is currently set, if not set default *>
fn void check_font() {
  if (font == null) {
    font = mem::new(Font);
    *font = font::get_default();
  }
}

<* Sets the currently used font *>
fn void set_font(Font* newfont) @export("kenoma_setfont") => font = newfont;
<* Sets the currently used background texture *>
fn void set_texture(GuiTexture property, Texture* newtexture) @export("kenoma_settexture") {
  switch (property) {
    case TILED_BACKGROUND: tiled_background = newtexture;
    case BAR_BACKGROUND:   bar_bg = newtexture;
    case BAR_FILL:         bar_fill = newtexture;
  }
}
<* Sets selected style property *>
fn void set_style(GuiStyle style, int value) @export("kenoma_setstyle") {
  switch (style) {
    case FONT_SIZE:         font_size    = (float)value;
    case FONT_SPACING:      font_spacing = (float)value;
    case TEXT_HORIZONTAL_ALIGNMENT: text_horizontal_alignment = GuiTextAlignmentHori.from_ordinal(value);
    case TEXT_VERTICAL_ALIGNMENT:   text_vertical_alignment   = GuiTextAlignmentVert.from_ordinal(value);
    case FONT_COLOR:        font_color   = ((uint)value).to_color();
    case BG_COLOR_DEFAULT:  bg_default   = ((uint)value).to_color();
    case BG_COLOR_SELECTED: bg_selected  = ((uint)value).to_color();
    case BG_COLOR_INTERACT: bg_interact  = ((uint)value).to_color();
    case BG_COLOR_DISABLED: bg_disabled  = ((uint)value).to_color();
    case RENDER_RESOLUTION: render_res   = (float)value / 100;
    case BAR_COLOR:         bar_color    = ((uint)value).to_color();
    default:
  }
}


