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


/// Window-related functions
extern fn void init_window(int width, int height, char* title) @private @extern("InitWindow");
extern fn void close_window() @private @extern("CloseWindow");
extern fn bool window_should_close() @extern("WindowShouldClose");
extern fn bool window_is_ready() @private @extern("IsWindowReady");
extern fn bool set_window_icon(Image image) @private @extern("SetWindowIcon");
//extern "C" { fn SetWindowPosition(x: i32, y: i32); }
//extern "C" { fn SetWindowMonitor(monitor: i32); }
//extern "C" { fn SetWindowMinSize(width: i32, height: i32); }
//extern "C" { fn SetWindowMaxSize(width: i32, height: i32); }
//extern "C" { fn SetWindowOpacity(opacity: f32); }
//extern "C" { fn GetMonitorCount() -> i32; }
//extern "C" { fn GetCurrentMonitor() -> i32; }
//extern "C" { fn GetMonitorWidth(monitor: i32) -> i32; }
//extern "C" { fn GetMonitorHeight(monitor: i32) -> i32; }
//extern "C" { fn GetMonitorPhysicalWidth(monitor: i32) -> i32; }
//extern "C" { fn GetMonitorPhysicalHeight(monitor: i32) -> i32; }
//extern "C" { fn GetMonitorRefreshRate(monitor: i32) -> i32; }
//extern "C" { fn GetWindowPosition() -> Vector2; }
//extern "C" { fn GetWindowScaleDPI() -> Vector2; }
//extern "C" { fn GetMonitorName(monitor: i32) -> *const i8; }
//extern "C" { fn SetClipboardText(text: *const i8); }
//extern "C" { fn GetClipboardText() -> *const i8; }

/// Cursor-related functions
//extern "C" { fn ShowCursor(); }
//extern "C" { fn HideCursor(); }
//extern "C" { fn IsCursorHidden() -> bool; }
//extern "C" { fn EnableCursor(); }
//extern "C" { fn DisableCursor(); }
//extern "C" { fn IsCursorOnScreen() -> bool; }

/// Drawing-related functions
extern fn void clear_background(Color color) @private @extern("ClearBackground");
extern fn void begin_drawing_rl() @private @extern("BeginDrawing");
extern fn void end_drawing_rl() @private @extern("EndDrawing");
//extern "C" { fn BeginMode2D(camera: Camera2DRl); }
//extern "C" { fn EndMode2D(); }
//extern "C" { fn BeginMode3D(camera: Camera3DRl); }
//extern "C" { fn EndMode3D(); }

/// Timing-related functions
extern fn void set_target_fps(int fps) @extern("SetTargetFPS");

/// Misc. functions
extern fn void set_trace_log_level(int logLevel) @extern("SetTraceLogLevel");

/// Input-related functions: keyboard
//extern "C" { fn SetExitKey(key: i32); }

/// Text font info functions
//extern "C" { fn SetTextLineSpacing(spacing: i32); }

//extern "C" { fn SetWindowTitle(title: *const i8); }
//extern "C" { fn SetWindowSize(width: i32, height: i32); }
//extern "C" { fn SetWindowState(flags: i32); }
