
module pleroma::raylib;
import std::io;


<* Texture stored in VRAM *>
struct Texture {
	uint id;
	int width, height, mipmaps;
	PixelFormat format;
}
<* Texture faults *>
fault TextureFault {
	FAILED_FIND_FILE,
}

<* Data to tile image *>
struct NPatchInfo {
	Rectangle source;
	int left;
	int top;
	int right;
	int bottom;
	NPatchLayout layout;
}

<* N-patch layout *>
enum NPatchLayout {
    NINE_PATCH,              // Npatch layout: 3x3 tiles
    THREE_PATCH_VERTICAL,    // Npatch layout: 1x3 tiles
    THREE_PATCH_HORIZONTAL   // Npatch layout: 3x1 tiles
}

<* Texture filter modes *>
enum TextureFilter {
	// No filter, just pixel approximation
	FILTER_POINT,
	// Linear filtering
	FILTER_BILINEAR,
	// Trilinear filtering (linear with mipmaps)
	FILTER_TRILINEAR,
	// Anisotropic filtering 4x
	FILTER_ANISOTROPIC_4X,
	// Anisotropic filtering 8x
	FILTER_ANISOTROPIC_8X,
	// Anisotropic filtering 16x
	FILTER_ANISOTROPIC_16X,
}
<* Texture wrapping modes *>
enum TextureWrap {
	// Repeats texture in tiled mode
	WRAP_REPEAT,
	// Clamps texture to edge pixel in tiled mode
    WRAP_CLAMP,
	// Mirrors and repeats the texture in tiled mode
    WRAP_MIRROR_REPEAT,
	// Mirrors and clamps to border the texture in tiled mode
    WRAP_MIRROR_CLAMP
}

<* Unloads texture from VRAM *>
fn void Texture.unload(&self) {
	raylib::unload_texture(*self);
	free(self);
}
<* Checks if texture is ready to be used *>
fn bool Texture.ready(&self) {
	return raylib::is_texture_ready(*self);
}
<* Update Texture with new data *>
fn void Texture.update(&self, void* pixels) {
	raylib::update_texture(*self, pixels);
}
<* Update Texture with new data in a rectangle *>
fn void Texture.update_rec(&self, Rectangle rec, void* pixels) {
	raylib::update_texture_rec(*self, rec, pixels);
}
<* Generate mipmaps for a Texture *>
fn void Texture.gen_mipmaps(&self) {
	raylib::gen_texture_mipmaps(self);
}
<* Set Texture scaling filter mode *>
fn void Texture.set_filter(&self, TextureFilter filter) {
	raylib::set_texture_filter(*self, filter.ordinal);
}
<* Set texture wrapping mode *>
fn void Texture.set_wrap(&self, TextureWrap wrap) {
	raylib::set_texture_wrap(*self, wrap.ordinal);
}

<* Draws Texture to screen
  @param pos_x "X position to draw at"
  @param pos_y "Y position to draw at"
  @param tint "Color to tint texture"
  @return "Self"
 *>
fn void Texture.draw(&self, int pos_x, int pos_y, Color tint) @export("texture_draw") {
	raylib::draw_texture(*self, pos_x, pos_y, tint);
}
<* Draws Texture to screen
  @param position "Vector position to draw at"
  @param tint "Color to tint texture"
  @return "Self"
 *>
fn void Texture.draw_v(&self, Vector2 position, Color tint) {
	raylib::draw_texture_v(*self, position, tint);
}
<* Draws Texture to screen
  @param position "Vector position to draw at"
  @param rotation "Rotation of Texture"
  @param scale "Scale of Texture"
  @param tint "Color to tint texture"
 *>
fn void Texture.draw_ex(&self, Vector2 position, float rotation, float scale, Color tint) {
	raylib::draw_texture_ex(*self, position, rotation, scale, tint);
}
<* Draws Texture to screen
  @param source "Source rectangle of Texture"
  @param position "Vector position to draw at"
  @param tint "Color to tint texture"
  @return "Self"
 *>
fn void Texture.draw_rec(&self, Rectangle source, Vector2 position, Color tint) {
	raylib::draw_texture_rec(*self, source, position, tint);
}
<* Draws Texture to screen
  @param source "Source rectangle of Texture"
  @param dest "Destination rectangle for Texture"
  @param origin "Vector origin of Texture"
  @param rotation "Rotation of Texture"
  @param tint "Color to tint texture"
 *>
fn void Texture.draw_pro(&self, Rectangle source, Rectangle dest, Vector2 origin, float rotation, Color tint) {
	raylib::draw_texture_pro(*self, source, dest, origin, rotation, tint);
}
<* Draws Texture to screen
  @param dest "Destination rectangle for Texture"
  @param origin "Vector origin of Texture"
  @param rotation "Rotation of Texture"
  @param tint "Color to tint texture"
 *>
fn void Texture.draw_npatch(&self, NPatchInfo npat, Rectangle dest, Vector2 origin, float rotation, Color tint) {
	raylib::draw_texture_npatch(*self, npat, dest, origin, rotation, tint);
}
<* Draw Texture as billboard
  @param camera
  @param position
  @param scale
  @param tint
 *>
fn void Texture.draw_billboard(&self, Camera3D camera, Vector3 position, float scale, Color tint) {
	raylib::draw_billboard(camera, *self, position, scale, tint);
}
<* Draw Texture as billboard using rectangle
  @param camera
  @param source
  @param position
  @param size
  @param tint
 *>
fn void Texture.draw_billboard_rec(&self, Camera3D camera, Rectangle source, Vector3 position, Vector2 size, Color tint) {
	raylib::draw_billboard_rec(camera, *self, source, position, size, tint);
}
<* Draw Texture as billboard using rectangle and rotation
  @param camera
  @param source
  @param position
  @param up
  @param size
  @param origin
  @param rotation
  @param tint
 *>
fn void Texture.draw_billboard_pro(&self, Camera3D camera, Rectangle source, Vector3 position, Vector3 up, Vector2 size, Vector2 origin, float rotation, Color tint) {
	raylib::draw_billboard_pro(camera, *self, source, position, up, size, origin, rotation, tint);
}

<* Create NPatch for use *>
fn NPatchInfo Texture.npatch(&self) {
	return {
		.source = {0, 0, self.width, self.height},
		.left = self.width / 3,
		.top = self.height / 3,
		.right = self.width / 3,
		.bottom = self.height / 3,
		.layout = NINE_PATCH,
	};
}
<* Prints information of texture *>
fn void Texture.print(&self) {
	io::printfn(
		"%d - %dx%d - m:%d - f:%s",
		self.id,
		self.width, self.height,
		self.mipmaps,
		self.format,
	);
}



module pleroma::raylib::texture;
import std::io;


<* Loads texture from file
  Unneeded due to bulk loading, but exists jic.
  @param filename "Name of file to be loaded"
 *>
fn Texture*! load(String filename) {
	if (!file::is_file(filename)) {
		io::printfn("ERROR - Failed to load texture {%s}", filename);
		return TextureFault.FAILED_FIND_FILE?;
	}

	Texture* result = mem::new(Texture);
	*result = raylib::load_texture(filename);
	return result;
}
