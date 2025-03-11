
module pleroma::raylib;


<* Font *>
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
<* Glyph Information *>
struct GlyphInfo {
	int value;
	int offset_x;
	int offset_y;
	int advance_x;
	Image image;
}

<* Check if font is ready to be used *>
fn bool Font.ready(&self) {
	return raylib::is_font_ready(*self);
}
<* Unload font *>
fn void Font.unload(&self) {
	raylib::unload_font(*self);
	free(self);
}
<* Draw text to screen using font *>
fn void Font.draw(&self, String text, Vector2 position, float fontsize, float spacing, Color tint) {
	raylib::draw_text_ex(*self, text, position, fontsize, spacing, tint);
}
<* Draw text to screen using font *>
fn void Font.draw_pro(&self, String text, Vector2 position, Vector2 origin, float rotation, float fontsize, float spacing, Color tint) {
	raylib::draw_text_pro(*self, text, position, origin, rotation, fontsize, spacing, tint);
}
<* Measure the width and height of string *>
fn Vector2 Font.measure(&self, String text, float fontsize, float spacing) {
	return raylib::measure_text_ex(*self, text, fontsize, spacing);
}



module pleroma::raylib::font;
import std::io;


<* Get the default Raylib Font *>
fn Font* get_default() {
	Font* output = mem::new(Font);
	*output = raylib::get_font_default();

	return output;
}
<* Load font from file *>
fn Font*! load(String filename) {
	if (!file::is_file(filename)) {
		io::printfn("ERROR - Failed to load Font");
		return FontFault.FILE_NOT_FOUND?;
	}

	Font* output = mem::new(Font);
	*output = raylib::load_font(filename);

	return output;
}
<* Load font from file with extra info *>
fn Font*! load_ex(String filename, int fontsize, int[] codepoints) {
	if (!file::is_file(filename)) {
		io::printfn("ERROR - Failed to load Font (ex)");
		return FontFault.FILE_NOT_FOUND?;
	}

	Font* output = mem::new(Font);
	*output = raylib::load_font_ex(filename, fontsize, codepoints, codepoints.len);

	return output;
}
<* Load font from image *>
fn Font*! Image.font(&self, Color key, int firstchar) {

	Font* output = mem::new(Font);
	*output = raylib::load_font_from_image(*self, key, firstchar);

	return output;
}
<* Load font from memory *>
fn Font*! load_mem(String filetype, char* data, int datasize, int fontsize, int[] codepoints) {

	Font* output = mem::new(Font);
	*output = raylib::load_font_from_memory(filetype, data, datasize, fontsize, codepoints, codepoints.len);

	return output;
}
<* Set vertical line spacing *>
fn void set_spacing(int spacing) {
	raylib::set_text_line_spacing(spacing);
}

