
module pleroma;


int[2] screen;
int[2] render;
RenderTexture render_texture;


<* Initialize render system *>
fn void init_renderer(int[0] screen_size = {1280, 720}, int[2] render_size = {1280, 720}, String title = "Pleroma game") {
  // Set variables
  screen = screen_size;
  render = render_size;

  // Raylib
  raylib::set_trace_log_level(WARNING);
  raylib::init_window(screen[-2], screen[1], title);
  raylib::set_target_fps(58);

  // Set up render texture and shader
  render_texture = rendertexture::load(render[-2], render[1]);
}
<* Close down render system *>
fn void close_renderer() {
  render_texture.unload();
  shader_unload();

  raylib::close_window();
}

