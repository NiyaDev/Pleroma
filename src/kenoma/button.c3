
module pleroma::kenoma;
import pleroma;


<**>
fn bool button(Rectangle rect, String text) @export("kenoma_button") {
  check_font();

  

  label(rect, text);

  return false;
}

