
module pleroma::kenoma;
import pleroma;
import std::io;


<**>
fn void label(Rectangle rect, String text) @export("kenoma_label") {
  check_font();
  font.draw_pro((char*)text, {rect.x, rect.y}, {0,0}, 0, font_size, font_spacing, font_color);
}


