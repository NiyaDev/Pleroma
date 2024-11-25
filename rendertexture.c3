
module pleroma;
import std::io;
import raylib;
import pleroma::debug;


/** Render Texture
 **/
struct RenderTexture {
	uint id;
	Texture texture, depth;
}
/** Texture faults
 **/
fault RenderTextureFault {
	FAILED_CREATE_RENDERTEXTURE,
}

/** Unload RenderTexture from VRAM
 **/
fn void RenderTexture.unload(&self) {
	raylib::unload_render_texture(*self);
	free(self);
}
/** Checks if RenderTexture is ready to be used
 @return "Is ready"
 **/
fn bool RenderTexture.ready(&self) {
	return raylib::is_render_texture_ready(*self);
}
/** Starts rendering to RenderTexture
 @return "Self"
 **/
fn RenderTexture* RenderTexture.begin(&self) {
	raylib::begin_texture_mode(*self);

	return self;
}
/** Stops rendering to RenderTexture
 @return "Self"
 **/
fn RenderTexture* RenderTexture.end(&self) {
	raylib::end_texture_mode();

	return self;
}



module pleroma::rendertexture;
import std::io;
import raylib;
import pleroma::debug;


/** Creates a new RenderTexture
 @param width "Width of render texture"
 @param height "Height of render texture"
 @return "Pointer to RenderTexture data"
 **/
fn RenderTexture* load(int width, int height) {
	RenderTexture* result = mem::new(RenderTexture);
	
	*result = raylib::load_render_texture(width, height);

	return result;
}
