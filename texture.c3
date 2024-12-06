
module pleroma;
import std::io;
import raylib;
import pleroma::debug;


/** Texture stored in VRAM
 **/
struct Texture {
	uint id;
	int width, height, mipmaps;
	PixelFormat format;
}
/** Texture faults
 **/
fault TextureFault {
	FAILED_FIND_FILE,
}

/** Data to tile image
 **/
struct NPatchInfo {
	Rectangle source;
	int left;
	int top;
	int right;
	int bottom;
	int layout;
}

/** Texture filter modes
 **/
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
/** Texture wrapping modes
 **/
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

/** Unloads texture from VRAM
 **/
fn void Texture.unload(&self) {
	raylib::unload_texture(*self);
	free(self);
}
/** Checks if texture is ready to be used
 @return "Is ready"
 **/
fn bool Texture.ready(&self) {
	return raylib::is_texture_ready(*self);
}
/** Update Texture with new data
 @param pixels "Pixel data to apply"
 @return "Self"
 **/
fn Texture* Texture.update(&self, void* pixels) {
	raylib::update_texture(*self, pixels);

	return self;
}
/** Update Texture with new data in a rectangle
 @param rec "Rectangle to change"
 @param pixels "Pixel data to apply"
 @return "Self"
 **/
fn Texture* Texture.update_rec(&self, Rectangle rec, void* pixels) {
	raylib::update_texture_rec(*self, rec, pixels);

	return self;
}
/** Generate mipmaps for a Texture
 @return "Self"
 **/
fn Texture* Texture.gen_mipmaps(&self) {
	raylib::gen_texture_mipmaps(self);

	return self;
}
/** Set Texture scaling filter mode
 @param filter "Filter to apply"
 @return "Self"
 **/
fn Texture* Texture.set_filter(&self, TextureFilter filter) {
	raylib::set_texture_filter(*self, (int)filter);

	return self;
}
/** Set texture wrapping mode
 @param wrap "Wrapping mode to apply"
 @return "Self"
 **/
fn Texture* Texture.set_wrap(&self, TextureWrap wrap) {
	raylib::set_texture_wrap(*self, (int)wrap);

	return self;
}

/** Draws Texture to screen
 @param pos_x "X position to draw at"
 @param pos_y "Y position to draw at"
 @param tint "Color to tint texture"
 @return "Self"
 **/
fn Texture* Texture.draw(&self, int pos_x, int pos_y, Color tint) {
	if (camera::main.texture_rendered({pos_x, pos_y, self.width, self.height})) return self;
	textures_rendered += 1;

	raylib::draw_texture(*self, pos_x, pos_y, tint);

	return self;
}
/** Draws Texture to screen
 @param position "Vector position to draw at"
 @param tint "Color to tint texture"
 @return "Self"
 **/
fn Texture* Texture.draw_v(&self, Vector2 position, Color tint) {
	if (camera::main.texture_rendered({position.x, position.y, self.width, self.height})) return self;
	textures_rendered += 1;

	raylib::draw_texture_v(*self, position, tint);

	return self;
}
/** Draws Texture to screen
 @param position "Vector position to draw at"
 @param rotation "Rotation of Texture"
 @param scale "Scale of Texture"
 @param tint "Color to tint texture"
 @return "Self"
 **/
fn Texture* Texture.draw_ex(&self, Vector2 position, float rotation, float scale, Color tint) {
	if (camera::main.texture_rendered({position.x, position.y, self.width * scale, self.height * scale})) return self;
	textures_rendered += 1;

	raylib::draw_texture_ex(*self, position, rotation, scale, tint);

	return self;
}
/** Draws Texture to screen
 @param source "Source rectangle of Texture"
 @param position "Vector position to draw at"
 @param tint "Color to tint texture"
 @return "Self"
 **/
fn Texture* Texture.draw_rec(&self, Rectangle source, Vector2 position, Color tint) {
	if (camera::main.texture_rendered({position.x, position.y, source.width, source.height})) return self;
	textures_rendered += 1;

	raylib::draw_texture_rec(*self, source, position, tint);

	return self;
}
/** Draws Texture to screen
 @param source "Source rectangle of Texture"
 @param dest "Destination rectangle for Texture"
 @param origin "Vector origin of Texture"
 @param rotation "Rotation of Texture"
 @param tint "Color to tint texture"
 @return "Self"
 **/
fn Texture* Texture.draw_pro(&self, Rectangle source, Rectangle dest, Vector2 origin, float rotation, Color tint) {
	if (camera::main.texture_rendered(dest)) return self;
	textures_rendered += 1;
	
	raylib::draw_texture_pro(*self, source, dest, origin, rotation, tint);

	return self;
}
/** Draws Texture to screen
 @param dest "Destination rectangle for Texture"
 @param origin "Vector origin of Texture"
 @param rotation "Rotation of Texture"
 @param tint "Color to tint texture"
 @return "Self"
 **/
fn Texture* Texture.draw_npatch(&self, Rectangle dest, Vector2 origin, float rotation, Color tint) {
	if (camera::main.texture_rendered(dest)) return self;
	textures_rendered += 1;
	
	NPatchInfo npat = self.npatch();

	raylib::draw_texture_npatch(*self, npat, dest, origin, rotation, tint);

	return self;
}
/** Force draw to screen
 @param source "Source rectangle of Texture"
 @param dest "Destination rectangle for Texture"
 @param origin "Vector origin of Texture"
 @param rotation "Rotation of Texture"
 @param tint "Color to tint texture"
 @return "Self"
 **/
fn Texture* Texture.draw_forced(&self, Rectangle source, Rectangle dest, Vector2 origin, float rotation, Color tint) {
	raylib::draw_texture_pro(*self, source, dest, origin, rotation, tint);

	return self;
}
/** Draw Texture as billboard
 @param camera
 @param position
 @param scale
 @param tint
 **/
fn Texture* Texture.draw_billboard(&self, Camera3D camera, Vector3 position, float scale, Color tint) {
	raylib::draw_billboard(camera, *self, position, scale, tint);

	return self;
}
/** Draw Texture as billboard using rectangle
 @param camera
 @param source
 @param position
 @param size
 @param tint
 **/
fn Texture* Texture.draw_billboard_rec(&self, Camera3D camera, Rectangle source, Vector3 position, Vector2 size, Color tint) {
	raylib::draw_billboard_rec(camera, *self, source, position, size, tint);

	return self;
}
/** Draw Texture as billboard using rectangle and rotation
 @param camera
 @param source
 @param position
 @param up
 @param size
 @param origin
 @param rotation
 @param tint
 **/
fn Texture* Texture.draw_billboard_pro(&self, Camera3D camera, Rectangle source, Vector3 position, Vector3 up, Vector2 size, Vector2 origin, float rotation, Color tint) {
	raylib::draw_billboard_pro(camera, *self, source, position, up, size, origin, rotation, tint);

	return self;
}

/** Create NPatch for use
 @return "NPatchInfo to use"
 **/
fn NPatchInfo Texture.npatch(&self) {
	return {
		.source = {0, 0, self.width, self.height},
		.left = self.width / 3,
		.top = self.height / 3,
		.right = self.width / 3,
		.bottom = self.height / 3,
		.layout = 0,
	};
}
/** Prints information of texture
 **/
fn void Texture.print(&self) {
	io::printfn(
		"%d - %dx%d - m:%d - f:%s",
		self.id,
		self.width, self.height,
		self.mipmaps,
		self.format,
	);
}



module pleroma::texture;
import std::io;
import raylib;
import pleroma::debug;


/** Loads texture from file
 Unneeded due to bulk loading, but exists jic.
 @param filename "Name of file to be loaded"
 @return "Pointer to loader Texture"
 **/
fn Texture*! load(String filename) {
	if (!file::is_file(filename)) {
		debug::log("Failed to load Texture", NONE, filename);
		return TextureFault.FAILED_FIND_FILE?;
	}

	Texture* result = mem::new(Texture);
	*result = raylib::load_texture(filename);
	return result;
}