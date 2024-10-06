
module pleroma;

import pleroma::keybindings;
import raylib;
import std::io;


Pleroma data;


struct Pleroma {
	bool initialized;
	
	//* Settings
	Resolution screen_size;
	Resolution render_size;
	int framerate;
	int window_flags;
	
	//* Screen
	RenderTexture* render_texture;
	bool is_rendering;
	Color background_color;
	float line_spacing;
	
	//* Camera
	
	//* Input
	
	//* Audio
	
	//* Debug
	
	//* General
	Sprite* default_texture;
}

/**
 * Initialize Pleroma
 * @param title				"Window title"
 * @param screen_resolution	"Resolution of window"
 * @param render_resolution	"Resolution rendered at"
 * @param framerate			"Framerate"
 * @param keybindings		"Decides if keybindings are initialized"
 * @param debug_mode		"Turns on Debugging"
 * @param debug_level		"Sets Screen display for Errors above the inputted level"
 **/
fn void init(
		String title = "Default",
		Resolution screen_resolution = {1280, 720},
		Resolution render_resolution = {1280, 720},
		int framerate = 60,
		bool keybindings = true,
		
		//* Debug
		bool debug_mode = true,
		PlErrorLevel debug_level = NONE,
) {
	//* Init Raylib
	raylib::set_trace_log_level(7);
	raylib::init_window(screen_resolution.width, screen_resolution.height, title);
	raylib::set_target_fps(framerate);
	
	//* Debug
	debug::debug_state = debug_mode;
	debug::lowest = debug_level;
	
	//* Icon
	Image*! icon = image::load("resources/icon.png");
	if (try icon) icon.set_icon().unload();
	
	//* Keybindings
	if (keybindings) keybindings::init();
	
	//* Render textures
	RenderTexture* rt = malloc(RenderTexture.sizeof);
	*rt = raylib::load_render_texture(render_resolution.width, render_resolution.height);
	
	data = {
		.initialized = true,
		.screen_size = {
			.width  = screen_resolution.width,
			.height = screen_resolution.height,
		},
		.render_size = {
			.width  = render_resolution.width,
			.height = render_resolution.height,
		},
		.framerate = framerate,
		.window_flags = 0,
		
		.render_texture = rt,
		.is_rendering = false,
		.background_color = color::DARKGRAY,
		.line_spacing = 1,
		
		.default_texture = sprite::from_image(raylib::gen_image_checked(8,8,2,2,color::PURPLE,color::BLACK)),
		//.default_texture = image::gen_checker(8,8,2,2,color::PURPLE,color::BLACK).texture(),
	};
}
/**
 * Closing Pleroma
 **/
fn void close() {
	data.render_texture.unload();
	raylib::close_window();
}

/**
 * Starts the process of drawing the next frame
 **/
fn void begin_drawing() {
	//* Music
	
	//* Make sure render texture exists
	if (data.render_texture == null) {
		debug::log("Attempted to start drawing while not having a RenderTexture.", HIGH);
		return;
	}
	
	//* Start drawing to render texture
	data.render_texture.begin();
	raylib::clear_background(data.background_color);
	data.is_rendering = true;
}
/**
 * Finishes the process of drawing the next frame
 **/
fn void end_drawing() {
	//* Debug info
	//* Draw log
	if (debug::debug_state) { debug::draw_debug_log(); }
	
	//* Draw render texture
	data.render_texture.end();
	
	raylib::begin_drawing_rl();
	data.render_texture.texture.draw_pro(
		{0, 0, (float)data.render_size.width, (float)-data.render_size.height},
		{0, 0, (float)data.screen_size.width, (float)data.screen_size.height},
		{0, 0},
		0,
		color::WHITE,
	);
	raylib::end_drawing_rl();
}

//= Settings
/**
 * Change debug mode
 **/
fn void set_debug(
		bool debug_mode = true,
		PlErrorLevel debug_level = NONE,
) {
	debug::debug_state = debug_mode;
	debug::lowest = debug_level;
}
/**
 * Change screen resolution
 **/
fn void set_screen_resolution(
		Resolution screen_resolution = {1280, 720},
) {
	data.screen_size = screen_resolution;
	raylib::set_window_size(screen_resolution.width, screen_resolution.height);
}
/**
 * Change render resolution
 **/
fn void set_render_resolution(
		Resolution render_resolution = {1280, 720},
) {
	data.render_size = render_resolution;
	data.render_texture.unload();
	
	RenderTexture rt_val = raylib::load_render_texture(render_resolution.width, render_resolution.height);
	*data.render_texture = rt_val;
}

//TODO set_icon that takes in an array of images but uses singular if len == 1


