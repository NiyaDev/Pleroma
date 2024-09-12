module pleroma;


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

fn void init() {
	//* Init Raylib
	set_trace_log_level(7);
	init_window(1280, 720, "Default");
	set_target_fps(60);
	
	set_window_icon(load_image("resources/icon.png"));
	
	RenderTexture rt_val = load_render_texture(640, 360);
	RenderTexture* rt = malloc($sizeof(rt_val));
	*rt = rt_val;
	
	data = {
		.initialized = true,
		.screen_size = {
			.width  = 1280,
			.height =  720,
		},
		.render_size = {
			.width  = 640,
			.height = 360,
		},
		.framerate = 60,
		.window_flags = 0,
		
		.render_texture = rt,
		.is_rendering = false,
		.background_color = color::DARKGRAY,
		.line_spacing = 1,
		
		.default_texture = sprite::from_image(gen_image_checked(8,8,2,2,color::PURPLE,color::BLACK)),
	};
}

fn void close() {
	close_window();
}

fn void begin_drawing() {
	//* Music
	
	//* Make sure render texture exists
	if (data.render_texture == null) {
		// TODO log error
		return;
	}
	
	//* Start drawing to render texture
	data.render_texture.begin();
	clear_background(data.background_color);
	data.is_rendering = true;
}

fn void end_drawing() {
	//* Debug info
	//* Draw log
	if (debug::debug_state) { debug::draw_debug_log(); }
	
	//* Draw render texture
	data.render_texture.end();
	
	begin_drawing_rl();
	data.render_texture.texture.draw_pro(
		{
			.x = 0,
			.y = 0,
			.width = (float)data.render_size.width,
			.height = (float)-data.render_size.height,
		},
		{
			.x = 0,
			.y = 0,
			.width = (float)data.screen_size.width,
			.height = (float)data.screen_size.height,
		},
		{.x = 0, .y = 0},
		0,
		color::WHITE,
	);
	end_drawing_rl();
}

//TODO set_icon that takes in an array of images but uses singular if len == 1



/// Misc. functions
extern fn void set_trace_log_level(int logLevel) @extern("SetTraceLogLevel");

/// Input-related functions: keyboard
//extern "C" { fn SetExitKey(key: i32); }

/// Text font info functions
//extern "C" { fn SetTextLineSpacing(spacing: i32); }

//extern "C" { fn SetWindowTitle(title: *const i8); }
//extern "C" { fn SetWindowSize(width: i32, height: i32); }
//extern "C" { fn SetWindowState(flags: i32); }
