
module pleroma::raylib;


<* Render Texture *>
struct RenderTexture {
	uint id;
	Texture texture, depth;
}
<* Texture faults *>
fault RenderTextureFault {
	FAILED_CREATE_RENDERTEXTURE,
}

<* Unload RenderTexture from VRAM *>
fn void RenderTexture.unload(&self) {
	raylib::unload_render_texture(*self);
	free(self);
}
<* Checks if RenderTexture is ready to be used *>
fn bool RenderTexture.ready(&self) {
	return raylib::is_render_texture_ready(*self);
}
<* Starts rendering to RenderTexture *>
fn void RenderTexture.begin(&self) {
	raylib::begin_texture_mode(*self);
}
<* Stops rendering to RenderTexture *>
fn void RenderTexture.end(&self) {
	raylib::end_texture_mode();
}



module pleroma::raylib::rendertexture;
import std::io;


<* Creates a new RenderTexture
  @param width "Width of render texture"
  @param height "Height of render texture"
 *>
fn RenderTexture* load(int width, int height) {
	RenderTexture* result = mem::new(RenderTexture);
	
	*result = raylib::load_render_texture(width, height);

	return result;
}

