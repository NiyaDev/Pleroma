module pleroma;


import std::io;


enum PixelFormat : int {
	GRAYSCALE,
    GRAYALPHA,
    R5G6B5,
    R8G8B8,
    R5G5B5A1,
    R4G4B4A4,
    R8G8B8A8,
    R32,
    R32G32B32,
    R32G32B32A32,
    R16,
    R16G16B16,
    R16G16B16A16,
    DXT1RGB,
    DXT1RGBA,
    DXT3RGBA,
    DXT5RGBA,
    ETC1RGB,
    ETC2RGB,
    ETC2EACRGBA,
    PVRTRGB,
    PVRTRGBA,
    ASTC4X4RGBA,
    ASTC8X8RGBA,
	UNKNOWN,
}


struct Texture {
	uint id;
	int width;
	int height;
	int mipmaps;
	PixelFormat format;
}


struct RenderTexture {
	uint id;
	Texture texture;
	Texture depth;
}


struct NPatchInfo {
	Rectangle source;
	int left;
	int top;
	int right;
	int bottom;
	int layout;
}


//= Texture
fn void Texture.print(&self) {
	io::printf(
		"%d - %dx%d - m:%d - f:%s",
		self.id,
		self.width, self.height,
		self.mipmaps,
		self.format,
	);
}

/// Wrapper for Raylib::UnloadTexture()
fn void Texture.unload(&self) {
	unload_texture(*self);
}
/// Wrapper for Raylib::IsTextureReady()
fn bool Texture.ready(&self) {
	return is_texture_ready(*self);
}
/// Wrapper for Raylib::UpdateTexture()
fn Texture* Texture.update(&self, void* pixels) {
	update_texture(*self, pixels);
	
	return self;
}
/// Wrapper for Raylib::UpdateTextureRec()
fn Texture* Texture.update_rec(&self, Rectangle rec, void* pixels) {
	update_texture_rec(*self, rec, pixels);
	
	return self;
}
/// Wrapper for Raylib::GenTextureMipmaps()
fn Texture* Texture.gen_mipmaps(&self) {
	gen_texture_mipmaps(self);
	
	return self;
}
/// Wrapper for Raylib::SetTextureFilter()
fn Texture* Texture.set_filter(&self, int filter) {
	set_texture_filter(*self, filter);
	
	return self;
}
/// Wrapper for Raylib::SetTextureWrap()
fn Texture* Texture.set_wrap(&self, int wrap) {
	set_texture_wrap(*self, wrap);
	
	return self;
}
/// Wrapper for Raylib::DrawTexture()
fn Texture* Texture.draw(&self, int pos_x, int pos_y, Color tint) {
	draw_texture(*self, pos_x, pos_y, tint);
	
	return self;
}
/// Wrapper for Raylib::DrawTextureV()
fn Texture* Texture.draw_v(&self, Vector2 position, Color tint) {
	draw_texture_v(*self, position, tint);
	
	return self;
}
/// Wrapper for Raylib::DrawTextureEx()
fn Texture* Texture.draw_ex(&self, Vector2 position, float rotation, float scale, Color tint) {
	draw_texture_ex(*self, position, rotation, scale, tint);
	
	return self;
}
/// Wrapper for Raylib::DrawTextureRec()
fn Texture* Texture.draw_rec(&self, Rectangle source, Vector2 position, Color tint) {
	draw_texture_rec(*self, source, position, tint);
	
	return self;
}
/// Wrapper for Raylib::DrawTexturePro()
fn Texture* Texture.draw_pro(&self, Rectangle source, Rectangle dest, Vector2 origin, float rotation, Color tint) {
	draw_texture_pro(*self, source, dest, origin, rotation, tint);
	
	return self;
}
/// Wrapper for Raylib::DrawTextureNPatch()
fn Texture* Texture.draw_npatch(&self, NPatchInfo npatch_info, Rectangle dest, Vector2 origin, float rotation, Color tint) {
	draw_texture_npatch(*self, npatch_info, dest, origin, rotation, tint);
	
	return self;
}


//= RenderTexture
/// Wrapper for Raylib::UnloadRenderTexture()
fn void RenderTexture.unload(&self) {
	unload_render_texture(*self);
}
/// Wrapper for Raylib::IsRenderTextureReady()
fn bool RenderTexture.ready(&self) {
	return is_render_texture_ready(*self);
}
/// Wrapper for Raylib::BeginTextureMode()
fn RenderTexture* RenderTexture.begin(&self) {
	begin_texture_mode(*self);
	
	return self;
}
/// Wrapper for Raylib::EndTextureMode()
fn RenderTexture* RenderTexture.end(&self) {
	end_texture_mode();
	
	return self;
}


//= PixelFormat
/// Wrapper for Raylib::GetPixelDataSize().
fn PixelFormat PixelFormat.fade(&self, int width, int height) {
	return get_pixel_data_size(width, height, *self);
}


//= Extern
/// Texture loading functions
extern fn Texture load_texture(char* filename) @extern("LoadTexture");
extern fn bool is_texture_ready(Texture texture) @extern("IsTextureReady");
extern fn void unload_texture(Texture texture) @extern("UnloadTexture");
extern fn void update_texture(Texture texture, void* pixels) @extern("UpdateTexture");
extern fn void update_texture_rec(Texture texture, Rectangle rec, void* pixels) @extern("UpdateTextureRec");
extern fn RenderTexture load_render_texture(int width, int height) @extern("LoadRenderTexture");
extern fn bool is_render_texture_ready(RenderTexture target) @extern("IsRenderTextureReady");
extern fn void unload_render_texture(RenderTexture target) @extern("UnloadRenderTexture");

/// Texture configuration functions
extern fn void gen_texture_mipmaps(Texture* texture) @extern("GenTextureMipmaps");
extern fn void set_texture_filter(Texture texture, int filter) @extern("SetTextureFilter");
extern fn void set_texture_wrap(Texture texture, int wrap) @extern("SetTextureWrap");

/// Texture drawing functions
extern fn void draw_texture(Texture texture, int pos_x, int pos_y, Color tint) @extern("DrawTexture");
extern fn void draw_texture_v(Texture texture, Vector2 position, Color tint) @extern("DrawTextureV");
extern fn void draw_texture_ex(Texture texture, Vector2 position, float rotation, float scale, Color tint) @extern("DrawTextureEx");
extern fn void draw_texture_rec(Texture texture, Rectangle source, Vector2 position, Color tint) @extern("DrawTextureRec");
extern fn void draw_texture_pro(Texture texture, Rectangle source, Rectangle dest, Vector2 origin, float rotation, Color tint) @extern("DrawTexturePro");
extern fn void draw_texture_npatch(Texture texture, NPatchInfo npatch_info, Rectangle dest, Vector2 origin, float rotation, Color tint) @extern("DrawTextureNPatch");

/// Drawing-related functions
extern fn void begin_texture_mode(RenderTexture target) @extern("BeginTextureMode");
extern fn void end_texture_mode() @extern("EndTextureMode");

// TODO find out where this func was
extern fn PixelFormat get_pixel_data_size(int width, int height, PixelFormat format) @extern("GetPixelDataSize");