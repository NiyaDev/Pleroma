
module pleroma;
import raylib;


/** Font
 **/
struct Font {
	int base_size;
	int glyph_count;
	int glyph_padding;
	Texture texture;
	Rectangle* recs;
	GlyphInfo* glyphs;
}
fault FontFault {
	FILE_NOT_FOUND,
}
/** Glyph Information
 **/
struct GlyphInfo {
	int value;
	int offset_x;
	int offset_y;
	int advance_x;
	Image image;
}

/** Check if font is ready to be used
 **/
fn bool Font.ready(&self) {
	return raylib::is_font_ready(*self);
}
/** Unload font
 **/
fn void Font.unload(&self) {
	raylib::unload_font(*self);
}
/** Draw text to screen using font
 @param text "Text to draw"
 @param position "Position on screen to draw at"
 @param fontsize "Size to draw font"
 @param spacing "Space between characters"
 @param tint "Color to draw font"
 @return "Self"
 **/
fn Font* Font.draw(&self, String text, Vector2 position, float fontsize, float spacing, Color tint) {
	raylib::draw_text_ex(*self, text, position, fontsize, spacing, tint);

	return self;
}
/** Draw text to screen using font
 @param text "Text to draw"
 @param position "Position on screen to draw at"
 @param origin "Origin point of text"
 @param rotation "Amount in _ to rotate text"
 @param fontsize "Size to draw font"
 @param spacing "Space between characters"
 @param tint "Color to draw font"
 @return "Self"
 **/
fn Font* Font.draw_pro(&self, String text, Vector2 position, Vector2 origin, float rotation, float fontsize, float spacing, Color tint) {
	raylib::draw_text_pro(*self, text, position, origin, rotation, fontsize, spacing, tint);

	return self;
}
/** Measure the width and height of string
 @param text "Text to measure"
 @param fontsize "Size of font"
 @param spacing "Spacing in between characters"
 @return "Width and height as Vector2"
 **/
fn Vector2 Font.measure(&self, String text, float fontsize, float spacing) {
	return raylib::measure_text_ex(*self, text, fontsize, spacing);
}



module pleroma::font;
import std::io;
import raylib;
import pleroma::debug;


/** Get the default Raylib Font
 **/
fn Font* get_default() {
	Font* output = malloc(Font.sizeof);
	*output = raylib::get_font_default();

	return output;
}
/** Load font from file
 Unneeded due to bulk loading, but exists jic.
 @param filename "Name of file to be loaded"
 @return "Pointer to loaded Font"
 **/
fn Font*! load(String filename) {
	if (!file::is_file(filename)) {
		debug::log("Failed to load Font");
		return FontFault.FILE_NOT_FOUND?;
	}

	Font* output = malloc(Font.sizeof);
	*output = raylib::load_font(filename);

	return output;
}
/** Load font from file with extra info
 Unneeded due to bulk loading, but exists jic.
 @param filename "Name of file to be loaded"
 @param fontsize "The size of the font"
 @param codepoints
 @return "Pointer to loaded Font"
 **/
fn Font*! load_ex(String filename, int fontsize, int[] codepoints) {
	if (!file::is_file(filename)) {
		debug::log("Failed to load Font");
		return FontFault.FILE_NOT_FOUND?;
	}

	Font* output = malloc(Font.sizeof);
	*output = raylib::load_font_ex(filename, fontsize, codepoints, codepoints.len);

	return output;
}
/** Load font from image
 @param key "Color key"
 @param firstchar
 @return "Pointer to loaded Font"
 **/
fn Font*! Image.font(&self, Color key, int firstchar) {

	Font* output = malloc(Font.sizeof);
	*output = raylib::load_font_from_image(*self, key, firstchar);

	return output;
}
/** Load font from memory
 @param filetype "File extension as string"
 @param data "Pointer to data"
 @param datasize "Length of data"
 @param fontsize "Size of font"
 @param codepoints
 @return "Pointer to loaded Font"
 **/
fn Font*! load_memory(String filetype, char* data, int datasize, int fontsize, int[] codepoints) {

	Font* output = malloc(Font.sizeof);
	*output = raylib::load_font_from_memory(filetype, data, datasize, fontsize, codepoints, codepoints.len);

	return output;
}
/** Set vertical line spacing
 @param spacing "Space between lines"
 **/
fn void set_spacing(int spacing) {
	raylib::set_text_line_spacing(spacing);
}
