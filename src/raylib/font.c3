
module pleroma::raylib;
import std::io;


<* Font *>
struct Font {
	int base_size;
	int glyph_count;
	int glyph_padding;
	Texture texture;
	Rectangle* recs;
	GlyphInfo* glyphs;
}
<* Glyph Information *>
struct GlyphInfo {
	int value;
	int offset_x;
	int offset_y;
	int advance_x;
	Image image;
}


module pleroma::raylib::font;
import std::io;


<* Load font from file with extra info *>
fn Font load_ex(String filename, int fontsize, int[] codepoints) @export("font_loadex") {
	return raylib::load_font_ex(filename, fontsize, codepoints, codepoints.len);
}
<* Load font from memory *>
fn Font load_mem(String filetype, char[] data, int fontsize, int[] codepoints) @export("font_loadmem") {
	return raylib::load_font_from_memory(filetype, data, data.len, fontsize, codepoints, codepoints.len);
}

<**>
fn void Font.print(&self) @export("font_print") {
	io::printf(
		"{\n\tbase_size: %d\n\tglyph_count: %d\n\tglyph_padding: %d\n}",
		self.base_size,
		self.glyph_count,
		self.glyph_padding,
	);
}
