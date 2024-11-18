
module pleroma;
import raylib;
import pleroma::color;
import pleroma::settings;


Resolution screen_size;
Resolution render_size;
RenderTexture* render;
int textures_rendered = 0;
int models_rendered = 0;

Music* music;

Settings settings;


/** Initialize Pleroma
 **/
fn void init(
	String title = "default",
	//Resolution screen_res = {1280, 720},
	Resolution render_res = {1280, 720},
	int framerate = 60,
	CameraType camera_mode = CAMERA2D,
	
	//* Debug
	bool debug_mode = true,
	PlErrorLevel debug_level = NONE,
) {
	//* Settings
	settings.init()!!;

	Resolution screen_res = settings["resolution_screen"]!!.re;

	//* Init Raylib
	raylib::set_trace_log_level(7);
	raylib::init_window(screen_res.width, screen_res.height, title);
	raylib::set_target_fps(framerate);
	raylib::init_audio_device();

	//* Debug
	debug::debug_state = debug_mode;
	debug::lowest = debug_level;

	//* Icon
	Image*! icon = image::load("resources/icon.png");
	if (try icon) icon.set_icon().unload();

	//* Keybindings
	keybindings::init()!!;

	//* Render texture
	render = rendertexture::load(render_res.width, render_res.height);

	//* Resolutions
	screen_size = screen_res;
	render_size = render_res;

	//* Camera
	camera::main = {
		.type = camera_mode,
		.cam2d = { {(float)render_res.width/2,(float)render_res.height/2}, {0,0}, 0, 1 },
		.cam3d = { {0,5,-5}, {0,0,0}, {0,1,0}, 70, CAMERA_PERSPECTIVE }
	};
}
/** Free all data associated with Pleroma
 **/
fn void close() {
	render.unload();
	raylib::close_audio_device();
	raylib::close_window();
}

/** Start drawing to render texture buffer
 **/
fn void begin_drawing() {
	textures_rendered = 0;

	//* Music
	if (music != null && music.is_playing()) {
		music.update();
	}

	//* Check for texture
	if (render == null) {
		debug::log("Attempted to start drawing while not having a RenderTexture.", HIGH);
		return;
	}

	//* Start drawing
	render.begin();
	camera::main.start();
	raylib::clear_background(color::GRAY);
}
/** Finish drawing to render texture
 **/
fn void end_drawing() {
	camera::main.end();

	//* Debug info
	if (debug::debug_state) {
		debug::draw_debug_log();
		debug::draw_debug_stats();
	}
	
	//* Draw render texture
	render.end();
	
	raylib::begin_drawing_rl();
	render.texture.draw_forced(
		{0, 0, (float)render_size.width, (float)-render_size.height},
		{0, 0, (float)screen_size.width, (float)screen_size.height},
		{0, 0},
		0,
		color::WHITE,
	);
	raylib::end_drawing_rl();
}

/** Change screen resolution
 **/
fn void set_screen_resolution(Resolution screen_resolution = {1280, 720}) {
	screen_size = screen_resolution;
	raylib::set_window_size(screen_resolution.width, screen_resolution.height);
}
/** Change render resolution
 **/
fn void set_render_resolution(Resolution render_resolution = {1280, 720}) {
	render_size = render_resolution;
	render.unload();
	
	RenderTexture rt_val = raylib::load_render_texture(render_resolution.width, render_resolution.height);
	*render = rt_val;
}
