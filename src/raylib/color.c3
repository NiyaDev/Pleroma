
module pleroma::raylib;
import std::io;
import std::math;


const Color LIGHTGRAY		= {200, 200, 200, 255};
const Color GRAY		  	= {130, 130, 130, 255};
const Color DARKGRAY		= { 80,  80,  80, 255};
const Color YELLOW			= {253, 249,   0, 255};
const Color GOLD		  	= {255, 203,   0, 255};
const Color ORANGE	 		= {255, 161,   0, 255};
const Color PINK 				= {255, 109, 194, 255};
const Color RED 				= {230,  41,  55, 255};
const Color MAROON 			= {190,  33,  55, 255};
const Color GREEN 			= {  0, 228,  48, 255};
const Color LIME				= {  0, 158,  47, 255};
const Color DARKGREEN		= {  0, 117,  44, 255};
const Color SKYBLUE			= {102, 191, 255, 255};
const Color BLUE				= {  0, 121, 241, 255};
const Color DARKBLUE		= {  0,  82, 172, 255};
const Color PURPLE			= {200, 122, 255, 255};
const Color VIOLET			= {135,  60, 190, 255};
const Color DARKPURPLE	= {112,  31, 126, 255};
const Color BEIGE				= {211, 176, 131, 255};
const Color BROWN				= {127, 106,  79, 255};
const Color DARKBROWN		= { 76,  63,  47, 255};
const Color WHITE				= {255, 255, 255, 255};
const Color BLACK				= {  0,   0,   0, 255};
const Color BLANK				= {  0,   0,   0,   0};
const Color MAGENTA			= {255,   0, 255, 255};
const Color RAYWHITE		= {245, 245, 245, 255};
const Color PALETTE_30	= { 48,  56,  67, 255};


<* Color *>
struct Color {
  char r, g, b, a;
}

<* Apply alpha to color
  @param alpha "Value to change alpha to"
  @require alpha <= 1, alpha >= 0 : "Alpha not within proper range of 0 -> 1"
 *>
fn void Color.fade(&self, float alpha) @export("color_fade") {
	self.a = (char)(255 * alpha);
}
<* Converts color to hexadecimal representation *>
fn uint Color.to_int(self) @export("color_toint") {
	return self.r << 24 | self.g << 16 | self.b << 8 | self.a;
}
fn Color uint.to_color(self) @export("color_fromint") {
	return { (char)(self >> 24), (char)(self >> 16), (char)(self >> 8), (char)self };
}
<* Converts color into Vector4 representation *>
fn Vector4 Color.normalize(self) @export("color_normalize") {
	return {
		.x = (float)self.r / 255,
		.y = (float)self.g / 255,
		.z = (float)self.b / 255,
		.w = (float)self.a / 255,
	};
}
<* Converts color into HSV *>
fn Vector3 Color.hsv(self) @export("color_hsv") {
	float r = (float)self.r / 255;
	float g = (float)self.g / 255;
	float b = (float)self.b / 255;
	float cmax = math::max(r, math::max(g, b));
	float cmin = math::min(r, math::min(g, b));
	float delta = cmax - cmin;

	float hue;
	if (delta == 0.0) { hue = 0; }
	else if (cmax == r) { hue = (60 * (((g - b) / delta) + 360)) % 360; }
	else if (cmax == g) { hue = (60 * (((b - r) / delta) + 120)) % 360; }
	else if (cmax == b) { hue = (60 * (((r - g) / delta) + 240)) % 360; }
	else { hue = -1; };

	float sat = (cmax == 0 ? 0 : delta / cmax);

	return {
		.x = hue,
		.y = sat,
		.z = cmax,
	};
}
<* Multiplies color by input *>
fn Color Color.tint(self, Color tint) @export("color_tint") {
	Color result = self;

	float cr = (float)tint.r / 255;
	float cg = (float)tint.g / 255;
	float cb = (float)tint.b / 255;
	float ca = (float)tint.a / 255;

	result.r = (char)(((float)self.r / 255 * cr) * 255);
	result.g = (char)(((float)self.g / 255 * cg) * 255);
	result.b = (char)(((float)self.b / 255 * cb) * 255);
	result.a = (char)(((float)self.a / 255 * ca) * 255);

	return result;
}
<* Corrects color for brightness
  @param factor "Percentage to increase brightness"
  @require factor <= 1, factor >= -1 : "Brightness factor not within range"
 *>
fn Color Color.brightness(self, float factor) @export("color_brightness") {
	Color result = self;

	float red	= (float)self.r;
	float green	= (float)self.g;
	float blue	= (float)self.b;

	if (factor < 0) {
		factor	 = 1 + factor;
		red		*= factor;
		green	*= factor;
		blue	*= factor;
	} else {
		red		= (255 - red)	* factor + red;
		green	= (255 - green)	* factor + green;
		blue	= (255 - blue)	* factor + blue;
	}

	result.r = (char)red;
	result.g = (char)green;
	result.b = (char)blue;

	return result;
}
<* Corrects color for contrast
  @param contrast "Percentage to change brightness"
  @require contrast <= 1, contrast >= -1 : "Contrast not within proper range"
 *>
fn Color Color.contrast(self, float contrast) @export("color_contrast") {
	Color result = self;

	contrast += 1;
	contrast *= contrast;

	float pr = (float)self.r / 255;
	pr -= 0.5;
	pr *= contrast;
	pr += 0.5;
	pr *= 255;
	if (pr < 0) { pr = 0; }
	else if (pr > 255) { pr = 255; }

	float pg = (float)self.g / 255;
	pg -= 0.5;
	pg *= contrast;
	pg += 0.5;
	pg *= 255;
	if (pg < 0) { pg = 0; }
	else if (pg > 255) { pg = 255; }

	float pb = (float)self.b / 255.0;
	pb -= 0.5;
	pb *= contrast;
	pb += 0.5;
	pb *= 255;
	if (pb < 0) { pb = 0; }
	else if (pb > 255) { pb = 255; }

	result.r = (char)pr;
	result.g = (char)pg;
	result.b = (char)pb;

	return result;
}
<* Get color with alpha applied
  @param alpha "Alpha to apply to color"
  @require alpha >= 0, alpha <= 1 : "Alpha not within proper range"
 *>
fn Color Color.alpha(self, float alpha) @export("color_alpha") {
	Color result = self;

	result.a = (char)(255 * alpha);

	return result;
}
<**>
fn Color Color.multiply(self, float factor) @export("color_multiply") {
	Color output = self;

	output.r = (char)(output.r * factor);
	output.g = (char)(output.g * factor);
	output.b = (char)(output.b * factor);

	return output;
}
<* Get src alpha-blended into dst color with tint
  @param src
  @param tint
 *>
fn Color Color.alpha_blend(self, Color src, Color tint) @export("color_alphablend") {
	return raylib::color_alpha_blend(self, src, tint);
}
<* Convert hexcode into color *>
fn Color hex(uint hex_value) @export("color_hex") {
	return {
		.r = (char)((hex_value >> 24) & 0xFF),
		.g = (char)((hex_value >> 16) & 0xFF),
		.b = (char)((hex_value >> 8 ) & 0xFF),
		.a = (char)( hex_value        & 0xFF),
	};
}

