module raylib;


import pleroma;


//= Raylib v5.0.0

//= Window-related functions
// Initialize window and OpenGL context
extern fn void init_window(int width, int height, char* title) @extern("InitWindow");
// Close window and unload OpenGL context
extern fn void close_window() @extern("CloseWindow");
// Check if application should close (KEY_ESCAPE pressed or windows close icon clicked)
extern fn bool window_should_close() @extern("WindowShouldClose");
// Check if window has been initialized successfully
extern fn bool window_is_ready() @extern("IsWindowReady");
/* Covered by variables in pleroma data
	// Check if window is currently fullscreen
	extern fn bool is_window_fullscreen() @extern("IsWindowFullscreen");
	// Check if window is currently hidden (only PLATFORM_DESKTOP)
	extern fn bool is_window_hidden() @extern("IsWindowHidden");
	// Check if window is currently minimized (only PLATFORM_DESKTOP)
	extern fn bool is_window_minimized() @extern("IsWindowMinimized");
	// Check if window is currently maximized (only PLATFORM_DESKTOP)
	extern fn bool is_window_maximized() @extern("IsWindowMaximized");
	// Check if window is currently focused (only PLATFORM_DESKTOP)
	extern fn bool is_window_focused() @extern("IsWindowFocused");
	// Check if window has been resized last frame
	extern fn bool is_window_resized() @extern("IsWindowResized");
	// Check if one specific window flag is enabled
	extern fn bool is_window_state(uint flag) @extern("IsWindowState");
*/
// Set window configuration state using flags (only PLATFORM_DESKTOP)
extern fn void set_window_state(uint flag) @extern("SetWindowState");
/* Covered by set_window_state, but kept here if needed
	// Clear window configuration state flags
	extern fn void clear_window_state(uint flag) @extern("ClearWindowState");
	// Toggle window state: fullscreen/windowed (only PLATFORM_DESKTOP)
	extern fn void toggle_fullscreen() @extern("ToggleFullscreen");
	// Toggle window state: borderless windowed (only PLATFORM_DESKTOP)
	extern fn void toggle_borderless() @extern("ToggleBorderlessWindowed");
	// Set window state: maximized, if resizable (only PLATFORM_DESKTOP)
	extern fn void maximize_window() @extern("MaximizeWindow");
	// Set window state: minimized, if resizable (only PLATFORM_DESKTOP)
	extern fn void minimize_window() @extern("MinimizeWindow");
	// Set window state: not minimized/maximized (only PLATFORM_DESKTOP)
	extern fn void restore_window() @extern("RestoreWindow");
*/
// Set icon for window (single image, RGBA 32bit, only PLATFORM_DESKTOP)
extern fn void set_window_icon(Image image) @extern("SetWindowIcon");
// Set icon for window (multiple images, RGBA 32bit, only PLATFORM_DESKTOP)
extern fn void set_window_icons(Image* image, int count) @extern("SetWindowIcons");
// Set title for window (only PLATFORM_DESKTOP and PLATFORM_WEB)
extern fn void set_window_title(char* title) @extern("SetWindowTitle");
// Set window position on screen (only PLATFORM_DESKTOP)
extern fn void set_window_position(int x, int y) @extern("SetWindowPosition");
// Set monitor for the current window
extern fn void set_window_monitor(int monitor) @extern("SetWindowMonitor");
// Set window minimum dimensions (for FLAG_WINDOW_RESIZABLE)
extern fn void set_window_min(int height, int width) @extern("SetWindowMinSize");
// Set window maximum dimensions (for FLAG_WINDOW_RESIZABLE)
extern fn void set_window_max(int height, int width) @extern("SetWindowMaxSize");
// Set window dimensions
extern fn void set_window_size(int height, int width) @extern("SetWindowSize");
// Set window opacity [0.0f..1.0f] (only PLATFORM_DESKTOP)
extern fn void set_window_opacity(float opacity) @extern("SetWindowOpacity");
// Set window focused (only PLATFORM_DESKTOP)
extern fn void set_window_focused() @extern("SetWindowFocused");
// Get native window handle
extern fn void* get_window_handle() @extern("GetWindowHandle");
/* Values held by Pleroma data
	// Get current screen width
	extern fn int get_screen_width() @extern("GetScreenWidth");
	// Get current screen height
	extern fn int get_screen_height() @extern("GetScreenHeight");
	// Get current render width (it considers HiDPI)
	extern fn int get_render_width() @extern("GetRenderWidth");
	// Get current render height (it considers HiDPI)
	extern fn int get_render_height() @extern("GetRenderHeight");
*/
// Get number of connected monitors
extern fn int get_monitor_count() @extern("GetMonitorCount");
// Get current connected monitor
extern fn int get_current_monitor() @extern("GetCurrentMonitor");
// Get specified monitor position
extern fn Vector2 get_monitor_position(int monitor) @extern("GetMonitorPosition");
// Get specified monitor width (current video mode used by monitor)
extern fn int get_monitor_width(int monitor) @extern("GetMonitorWidth");
// Get specified monitor height (current video mode used by monitor)
extern fn int get_monitor_height(int monitor) @extern("GetMonitorHeight");
// Get specified monitor physical width in millimetres
extern fn int get_monitor_physical_width(int monitor) @extern("GetMonitorPhysicalWidth");
// Get specified monitor physical height in millimetres
extern fn int get_monitor_physical_height(int monitor) @extern("GetMonitorPhysicalHeight");
// Get specified monitor refresh rate
extern fn int get_monitor_refresh(int monitor) @extern("GetMonitorRefreshRate");
// Get window position XY on monitor
extern fn Vector2 get_window_position() @extern("GetWindowPosition");
// Get window scale DPI factor
extern fn Vector2 get_window_scale_dpi() @extern("GetWindowScaleDPI");
// Get the human-readable, UTF-8 encoded name of the specified monitor
extern fn char* get_monitor_name(int monitor) @extern("GetMonitorName");
// Set clipboard text content
extern fn void set_clipboard(char* text) @extern("SetClipboardText");
// Get clipboard text content
extern fn char* get_clipboard() @extern("SetClipboardText");
// Enable waiting for events on EndDrawing(), no automatic event polling
extern fn void enable_event_waiting() @extern("EnableEventWaiting");
// Disable waiting for events on EndDrawing(), automatic events polling
extern fn void disable_event_waiting() @extern("EnableEventWaiting");

//= Cursor-related functions
// TODO Create module for just this
// Shows cursor
extern fn void show_cursor() @extern("ShowCursor");
// Hides cursor
extern fn void hide_cursor() @extern("HideCursor");
// Check if cursor is not visible
extern fn bool is_cursor_hidden() @extern("IsCursorHidden");
// Enables cursor (unlock cursor)
extern fn void enable_cursor() @extern("EnableCursor");
// Disables cursor (lock cursor)
extern fn void disable_cursor() @extern("DisableCursor");
// Check if cursor is on the screen
extern fn bool is_cursor_onscreen() @extern("IsCursorOnScreen");

//= Drawing-related functions
// Set background color (framebuffer clear color)
extern fn void clear_background(Color color) @extern("ClearBackground");
// Setup canvas (framebuffer) to start drawing
extern fn void begin_drawing_rl() @extern("BeginDrawing");
// End canvas drawing and swap buffers (double buffering)
extern fn void end_drawing_rl() @extern("EndDrawing");
// Begin 2D mode with custom camera (2D)
extern fn void begin_2d_mode(Camera2D camera) @extern("BeginMode2D");
// Ends 2D mode with custom camera
extern fn void end_2d_mode() @extern("EndMode2D");
// Begin 3D mode with custom camera (3D)
extern fn void begin_3d_mode(Camera3D camera) @extern("BeginMode3D");
// Ends 3D mode and returns to default 2D orthographic mode
extern fn void end_3d_mode() @extern("EndMode3D");
// Begin drawing to render texture
extern fn void begin_texture_mode(RenderTexture target) @extern("BeginTextureMode");
// Ends drawing to render texture
extern fn void end_texture_mode() @extern("EndTextureMode");
// Begin custom shader drawing
extern fn void begin_shader_mode(Shader shader) @extern("BeginShaderMode");
// End custom shader drawing (use default shader)
extern fn void end_shader_mode() @extern("EndShaderMode");
// Begin blending mode (alpha, additive, multiplied, subtract, custom)
extern fn void begin_blend_mode(int mode) @extern("BeginBlendMode");
// End blending mode (reset to default: alpha blending)
extern fn void end_blend_mode() @extern("EndDrawing");
// Begin scissor mode (define screen area for following drawing)
extern fn void begin_scissor_mode(int x, int y, int width, int height) @extern("BeginScissorMode");
// End scissor mode
extern fn void end_scissor_mode() @extern("EndScissorMode");
// TODO move this into module
// Begin stereo rendering (requires VR simulator)
extern fn void begin_vr_mode(VrStereoConfig config) @extern("BeginVrStereoMode");
// End stereo rendering (requires VR simulator)
extern fn void end_vr_mode() @extern("EndVrStereoMode");

//= VR stereo config functions for VR simulator
// Load VR stereo config for VR simulator device parameters
extern fn VrStereoConfig load_vr_config(VrDeviceInfo device) @extern("LoadVrStereoConfig");
// Unload VR stereo config

//= Shader management functions
//= NOTE: Shader functionality is not available on OpenGL 1.1
// Load shader from files and bind default locations
extern fn Shader load_shader(char* vsFilename, char* fsFilename) @extern("LoadShader");
// Load shader from code strings and bind default locations
extern fn Shader load_shader_memory(char* vsCode, char* fsCode) @extern("LoadShaderFromMemory");
// Check if a shader is ready
extern fn bool is_shader_ready(Shader shader) @extern("IsShaderReady");
// Get shader uniform location
extern fn int get_shader_location(Shader shader, char* uniformName) @extern("GetShaderLocation");
// Get shader attribute location
extern fn int get_shader_location_attribute(Shader shader, char* atttribName) @extern("GetShaderLocationAttrib");
// Set shader uniform value
extern fn void set_shader_value(Shader shader, int locIndex, void* value, int uniformType) @extern("SetShaderValue");
// Set shader uniform value vector
extern fn void set_shader_value_vec(Shader shader, int locIndex, void* value, int uniformType) @extern("SetShaderValueV");
// Set shader uniform value (matrix 4x4)
extern fn void set_shader_value_mat(Shader shader, int locIndex, Matrix mat) @extern("SetShaderValueMatrix");
// Set shader uniform value for texture (sampler2d)
extern fn void set_shader_value_texture(Shader shader, int locIndex, void* value, int uniformType) @extern("SetShaderValueTexture");
// Unload shader from GPU memory (VRAM)
extern fn void unload_shader(Shader shader) @extern("UnloadShader");

//= Screen-space-related functions
// Get a ray trace from mouse position
extern fn Ray get_mouse_ray(Vector2 mouse_position, Camera3D camera) @extern("GetMouseRay");
// Get camera transform matrix (view matrix)
extern fn Matrix get_camera_matrix(Camera3D camera) @extern("GetCameraMatrix");
// Get camera 2d transform matrix
extern fn Matrix get_camera_matrix_2d(Camera2D camera) @extern("GetCameraMatrix2D");
// Get the screen space position for a 3d world space position
extern fn Vector2 get_world_to_screen(Vector3 mouse_position, Camera3D camera) @extern("GetWorldToScreen");
// Get the world space position for a 2d camera screen space position
extern fn Vector2 get_screen_to_world_2d(Vector3 mouse_position, Camera2D camera) @extern("GetScreenToWorld2D");
// Get size position for a 3d world space position
extern fn Vector2 get_world_to_screen_ex(Vector3 mouse_position, Camera3D camera, int width, int height) @extern("GetWorldToScreenEx");
// Get the screen space position for a 2d camera world space position
extern fn Vector2 get_world_to_screen_2d(Vector2 mouse_position, Camera2D camera) @extern("GetWorldToScreen2D");

//= Timing-related functions
// Set target FPS (maximum)
extern fn void set_target_fps(int fps) @extern("SetTargetFPS");
// Get time in seconds for last frame drawn (delta time)
extern fn float get_frametime() @extern("GetFrameTime");
// Get elapsed time in seconds since InitWindow()
extern fn double get_time() @extern("GetTime");
// Get current FPS
extern fn int get_fps() @extern("GetFPS");

//= Custom frame control functions
//= NOTE: Those functions are intended for advance users that want full control over the frame processing
//= By default EndDrawing() does this job: draws everything + SwapScreenBuffer() + manage frame timing + PollInputEvents()
//= To avoid that behaviour and control frame processes manually, enable in config.h: SUPPORT_CUSTOM_FRAME_CONTROL
// Swap back buffer with front buffer (screen drawing)
extern fn void swap_screen_buffer() @extern("SwapScreenBuffer");
// Register all input events
extern fn void poll_input_events() @extern("PollInputEvents");
// Wait for some time (halt program execution)
extern fn void wait_time(double seconds) @extern("WaitTime");

//= Random values generation functions
// Set the seed for the random number generator
extern fn void set_seed(uint seed) @extern("SetRandomSeed");
// Get a random value between min and max (both included)
extern fn int get_value(int min, int max) @extern("GetRandomValue");
// Load random values sequence, no values repeated
extern fn int* load_sequence(uint count, int min, int max) @extern("LoadRandomSequence");
// Unload random values sequence
extern fn void unload_sequence(int* sequence) @extern("UnloadRandomSequence");

//= Misc. functions
// Takes a screenshot of current screen (filename extension defines format)
extern fn void take_screenshot(char* fileName) @extern("TakeScreenshot");
// Setup init configuration flags (view FLAGS)
extern fn void set_config_flags(uint flags) @extern("SetConfigFlags");
// Open URL with default system browser (if available)
extern fn void open_url(char* url) @extern("OpenURL");

//= Misc. functions
// Set custom trace log
extern fn void set_trace_log_level(int logLevel) @extern("SetTraceLogLevel");

//= File system functions
// Check if a file has been dropped into window
extern fn bool is_file_dropped() @extern("IsFileDropped");
// Load dropped filepaths
extern fn FilePathList load_dropped_files() @extern("LoadDroppedFiles");

//= Compression/Encoding functionality
// Compress data (DEFLATE algorithm), memory must be MemFree()
extern fn char* compress(char* data, int dataSize, int* compDataSize) @extern("CompressData");
// Decompress data (DEFLATE algorithm), memory must be MemFree()
extern fn char* decompress(char* compData, int compDataSize, int* dataSize) @extern("DecompressData");
// Encode data to Base64 string, memory must be MemFree()
extern fn char* encode_base64(char* data, int dataSize, int* outputSize) @extern("EncodeDataBase64");
// Decode Base64 string data, memory must be MemFree()
extern fn char* decode_base64(char* data, int* outputSize) @extern("DecodeDataBase64");

//= Input-related functions: keyboard
// Check if a key has been pressed once
extern fn bool is_key_pressed(int key) @extern("IsKeyPressed");
// Check if a key has been pressed again (Only PLATFORM_DESKTOP)
extern fn bool is_key_repeat(int key) @extern("IsKeyPressedRepeat");
// Check if a key is being pressed
extern fn bool is_key_down(int key) @extern("IsKeyDown");
// Check if a key has been released once
extern fn bool is_key_released(int key) @extern("IsKeyReleased");
// Check if a key is NOT being pressed
extern fn bool is_key_up(int key) @extern("IsKeyUp");
// Get key pressed (keycode), call it multiple times for keys queued, returns 0 when the queue is empty
extern fn int get_key_pressed() @extern("GetKeyPressed");
// Get char pressed (unicode), call it multiple times for chars queued, returns 0 when the queue is empty
extern fn int get_char_pressed() @extern("GetCharPressed");
// Set a custom key to exit program (default is ESC)
extern fn void set_exit_key(int key) @extern("SetExitKey");

//= Input-related functions: gamepads
// Check if a gamepad is available
extern fn bool is_gamepad_available(int gamepad) @extern("IsGamepadAvailable");
// Get gamepad internal name id
extern fn char* get_gamepad_name(int gamepad) @extern("GetGamepadName");
// Check if a gamepad button has been pressed once
extern fn bool is_gamepad_button_pressed(int gamepad, int button) @extern("IsGamepadButtonPressed");
// Check if a gamepad button is being pressed
extern fn bool is_gamepad_button_down(int gamepad, int button) @extern("IsGamepadButtonDown");
// Check if a gamepad button has been released once
extern fn bool is_gamepad_button_released(int gamepad, int button) @extern("IsGamepadButtonReleased");
// Check if a gamepad button is NOT being pressed
extern fn bool is_gamepad_button_up(int gamepad, int button) @extern("IsGamepadButtonUp");
// Get the last gamepad button pressed
extern fn int get_gamepad_button_pressed() @extern("GetGamepadButtonPressed");
// Get gamepad axis count for a gamepad
extern fn int get_gamepad_axis_count(int gamepad) @extern("GetGamepadAxisCount");
// Get axis movement value for a gamepad axis
extern fn float get_gamepad_axis_movement(int gamepad, int axis) @extern("GetGamepadAxisMovement");
// Set internal gamepad mappings (SDL_GameControllerDB)
extern fn int set_gamepad_mappings(char* mappings) @extern("SetGamepadMappings");

//= Input-related functions: mouse
// Check if a mouse button has been pressed once
extern fn bool is_mouse_button_pressed(int button) @extern("IsMouseButtonPressed");
// Check if a mouse button is being pressed
extern fn bool is_mouse_button_down(int button) @extern("IsMouseButtonDown");
// Check if a mouse button has been released once
extern fn bool is_mouse_button_released(int button) @extern("IsMouseButtonReleased");
// Check if a mouse button is NOT being pressed
extern fn bool is_mouse_button_up(int button) @extern("IsMouseButtonUp");
// Get mouse position X
extern fn int get_mouse_x() @extern("GetMouseX");
// Get mouse position Y
extern fn int get_mouse_y() @extern("GetMouseY");
// Get mouse position XY
extern fn Vector2 get_mouse_position() @extern("GetMousePosition");
// Get mouse delta between frames
extern fn Vector2 get_mouse_delta() @extern("GetMouseDelta");
// Set mouse position XY
extern fn void set_mouse_position(int x, int y) @extern("SetMousePosition");
// Set mouse offset
extern fn void set_mouse_offset(int offsetX, int offsetY) @extern("SetMouseOffset");
// Set mouse scaling
extern fn void set_mouse_scale(float scaleX, float scaleY) @extern("SetMouseScale");
// Get mouse wheel movement for X or Y, whichever is larger
extern fn float get_mouse_wheel_move() @extern("GetMouseWheelMove");
// Get mouse wheel movement for both X and Y
extern fn Vector2 get_mouse_wheel_move_vector() @extern("GetMouseWheelMoveV");
// Set mouse cursor
extern fn void set_mouse_cursor(int cursor) @extern("SetMouseCursor");

//= rShapes

//= rTextures
//= Image loading functions
// Load image from file into CPU memory (RAM)
extern fn Image load_image(char* filename) @extern("LoadImage");
// Load image from RAW file data
extern fn Image load_image_raw(char* filename, int width, int height, PixelFormat format, int header_size) @extern("LoadImageRaw");
// Load image from SVG file data or string with specified size
extern fn Image load_image_svg(char* filename, int width, int height) @extern("LoadImageSvg");
// Load image sequence from file (frames appended to image.data)
extern fn Image load_image_anim(char* fileName, int* frames) @extern("LoadImageAnim");
// Load image from memory buffer, fileType refers to extension: i.e. '.png'
extern fn Image load_image_from_memory(char* fileType, char* fileData, int dataSize) @extern("LoadImageFromMemory");
// Load image from GPU texture data
extern fn Image load_image_from_texture(Texture texture) @extern("LoadImageFromTexture");
// Load image from screen buffer and (screenshot)
extern fn Image load_image_from_screen() @extern("LoadImageFromScreen");
// Check if an image is ready
extern fn bool is_image_ready(Image image) @extern("IsImageReady");
// Unload image from CPU memory (RAM)
extern fn void unload_image(Image image) @extern("UnloadImage");
// Export image data to file, returns true on success
extern fn bool export_image(Image image, char* filename) @extern("ExportImage");
// Export image to memory buffer
extern fn char* export_image_to_memory(Image image, char* fileType, int* fileSize) @extern("ExportImageToMemory");
// Export image as code file defining an array of bytes, returns true on success
extern fn bool export_image_as_code(Image image, char* file) @extern("ExportImageAsCode");

//= Image generation functions
// Generate image: plain color
extern fn Image gen_image_color(int width, int height, Color color) @extern("GenImageColor");
// Generate image: linear gradient, direction in degrees [0..360], 0=Vertical gradient
extern fn Image gen_image_gradient_linear(int width, int height, int direction, Color start, Color end) @extern("GenImageGradientLinear");
// Generate image: radial gradient
extern fn Image gen_image_gradient_radial(int width, int height, float density, Color inner, Color outer) @extern("GenImageGradientRadial");
// Generate image: square gradient
extern fn Image gen_image_gradient_square(int width, int height, float density, Color inner, Color outer) @extern("GenImageGradientSquare");
// Generate image: checked
extern fn Image gen_image_checked(int width, int height, int checksX, int checksY, Color col1, Color col2) @extern("GenImageChecked");
// Generate image: white noise
extern fn Image gen_image_white_noise(int width, int height, float factor) @extern("GenImageWhiteNoise");
// Generate image: perlin noise
extern fn Image gen_image_perlin_noise(int width, int height, int offsetX, int offsetY, float scale) @extern("GenImagePerlinNoise");
// Generate image: cellular algorithm, bigger tileSize means bigger cells
extern fn Image gen_image_cellular(int width, int height, int tileSize) @extern("GenImageCellular");
// Generate image: grayscale image from text data
extern fn Image gen_image_text(int width, int height, char* text) @extern("GenImageText");

//= Image manipulation functions
// Create an image duplicate (useful for transformations)
extern fn Image image_copy(Image image) @extern("ImageCopy");
// Create an image from another image piece
extern fn Image image_from_image(Image image, Rectangle rec) @extern("ImageFromImage");
// Create an image from text (default font)
extern fn Image image_text(char* text, int fontSize, Color color) @extern("ImageText");
// Create an image from text (custom sprite font)
extern fn Image image_text_ex(Font font, char* text, float fontSize, float spacing, Color tint) @extern("ImageTextEx");
// Convert image data to desired format
extern fn void image_format(Image* image, int newFormat) @extern("ImageFormat");
// Convert image to POT (power-of-two)
extern fn void image_to_pot(Image* image, Color fill) @extern("ImageToPOT");
// Crop an image to a defined rectangle
extern fn void image_crop(Image* image, Rectangle crop) @extern("ImageCrop");
 // Crop image depending on alpha value
extern fn void image_alpha_crop(Image* image, float threshold) @extern("ImageAlphaCrop");
// Clear alpha channel to desired color
extern fn void image_alpha_clear(Image* image, Color color, float threshold) @extern("ImageAlphaClear");
// Apply alpha mask to image
extern fn void image_alpha_mask(Image* image, Image alphaMask) @extern("ImageAlphaMask");
// Premultiply alpha channel
extern fn void image_alpha_premultiply(Image* image) @extern("ImageAlphaPremultiply");
// Apply Gaussian blur using a box blur approximation
extern fn void image_blur_gaussian(Image* image, int blurSize) @extern("ImageBlurGaussian");
// Resize image (Bicubic scaling algorithm)
extern fn void image_resize(Image* image, int newWidth, int newHeight) @extern("ImageResize");
// Resize image (Nearest-Neighbor scaling algorithm)
extern fn void image_resize_nn(Image* image, int newWidth, int newHeight) @extern("ImageResizeNN");
// Resize canvas and fill with color
extern fn void image_resize_canvas(Image* image, int newWidth, int newHeight, int offsetX, int offsetY, Color fill) @extern("ImageResizeCanvas");
// Compute all mipmap levels for a provided image
extern fn void image_mipmaps(Image* image) @extern("ImageMipmaps");
// Dither image data to 16bpp or lower (Floyd-Steinberg dithering)
extern fn void image_dither(Image* image, int rBpp, int gBpp, int bBpp, int aBpp) @extern("ImageDither");
// Flip image vertically
extern fn void image_flip_vertical(Image* image) @extern("ImageFlipVertical");
// Flip image horizontally
extern fn void image_flip_horizontal(Image* image) @extern("ImageFlipHorizontal");
// Rotate image by input angle in degrees (-359 to 359)
extern fn void image_rotate(Image* image, int degrees) @extern("ImageRotate");
// Rotate image clockwise 90deg
extern fn void image_rotate_cw(Image* image) @extern("ImageRotateCW");
// Rotate image counter-clockwise 90deg
extern fn void image_rotate_ccw(Image* image) @extern("ImageRotateCCW");
// Modify image color: tint
extern fn void image_color_tint(Image* image, Color color) @extern("ImageColorTint");
// Modify image color: invert
extern fn void image_color_invert(Image* image) @extern("ImageColorInvert");
// Modify image color: grayscale
extern fn void image_color_grayscale(Image* image) @extern("ImageColorGrayscale");
// Modify image color: contrast (-100 to 100)
extern fn void image_color_contrast(Image* image, float contrast) @extern("ImageColorContrast");
// Modify image color: brightness (-255 to 255)
extern fn void image_color_brightness(Image* image, int brightness) @extern("ImageColorBrightness");
// Modify image color: replace color
extern fn void image_color_replace(Image* image, Color color, Color replace) @extern("ImageColorReplace");
// Load colors palette from image as a Color array (RGBA - 32bit)
extern fn Color* load_image_palette(Image image, int maxPaletteSize, int* colorCount) @extern("LoadImagePalette");
// Unload colors palette loaded with LoadImagePalette()
extern fn void unload_image_palette(Color* colors) @extern("UnloadImagePalette");
// Get image alpha border rectangle
extern fn Rectangle get_image_alpha_border(Image image, float threshold) @extern("GetImageAlphaBorder");
// Get image pixel color at (x, y) position
extern fn Color get_image_color(Image* image, int x, int y) @extern("GetImageColor");

//= Image drawing functions
// Clear image background with given color
extern fn void image_clear_background(Image* dst, Color color) @extern("ImageClearBackground");
// Draw pixel within an image
extern fn void image_draw_pixel(Image* dst, int posX, int posY, Color color) @extern("ImageDrawPixel");
// Draw pixel within an image (Vector version)
extern fn void image_draw_pixel_v(Image* dst, Vector2 position, Color color) @extern("ImageDrawPixelV");
// Draw line within an image
extern fn void image_draw_line(Image* dst, int startPosX, int startPosY, int endPosX, int endPosY, Color color) @extern("ImageDrawLine");
// Draw line within an image (Vector version)
extern fn void image_draw_line_v(Image* dst, Vector2 start, Vector2 end, Color color) @extern("ImageDrawLineV");
// Draw a line defining thickness within an image
// Draw a filled circle within an image
extern fn void image_draw_circle(Image* dst, int centerX, int centerY, int radius, Color color) @extern("ImageDrawCircle");
// Draw a filled circle within an image (Vector version)
extern fn void image_draw_circle_v(Image* dst, Vector2 center, int radius, Color color) @extern("ImageDrawCircleV");
// Draw circle outline within an image
extern fn void image_draw_circle_lines(Image* dst, int centerX, int centerY, int radius, Color color) @extern("ImageDrawCircleLines");
// Draw circle outline within an image (Vector version)
extern fn void image_draw_circle_lines_v(Image* dst, Vector2 center, int radius, Color color) @extern("ImageDrawCircleLinesV");
// Draw rectangle within an image
extern fn void image_draw_rectangle(Image* dst, int posX, int posY, int width, int height, Color color) @extern("ImageDrawRectangle");
// Draw rectangle within an image (Vector version)
extern fn void image_draw_rectangle_v(Image* dst, Vector2 position, Vector2 size, Color color) @extern("ImageDrawRectangleV");
// Draw rectangle within an image
extern fn void image_draw_rectangle_rec(Image* dst, Rectangle rec, Color color) @extern("ImageDrawRectangleRec");
// Draw rectangle lines within an image
extern fn void image_draw_rectangle_lines(Image* dst, Rectangle rec, int thick, Color color) @extern("ImageDrawRectangleLines");
// Draw triangle within an image
// Draw triangle with interpolated colors within an image
// Draw triangle outline within an image
// Draw a triangle fan defined by points within an image (first vertex is the center)
// Draw a triangle strip defined by points within an image
// Draw a source image within a destination image (tint applied to source)
extern fn void image_draw(Image* dst, Image src, Rectangle srcRec, Rectangle dstRec, Color tint) @extern("ImageDraw");
// Draw text (using default font) within an image (destination)
extern fn void image_draw_text(Image* dst, char* text, int posX, int posY, int fontSize, Color color) @extern("ImageDrawText");
// Draw text (custom sprite font) within an image (destination)
extern fn void image_draw_text_ex(Image* dst, Font font, char* text, Vector2 position, float fontSize, float spacing, Color tint) @extern("ImageDrawTextEx");

//= Texture loading functions
extern fn Texture load_texture(char* filename) @extern("LoadTexture");
extern fn Texture load_texture_from_image(Image image) @extern("LoadTextureFromImage");
extern fn Texture load_texture_cubemap(Image image, int layout) @extern("LoadTextureCubemap");
extern fn RenderTexture load_render_texture(int width, int height) @extern("LoadRenderTexture");
extern fn bool is_texture_ready(Texture texture) @extern("IsTextureReady");
extern fn void unload_texture(Texture texture) @extern("UnloadTexture");
extern fn bool is_render_texture_ready(RenderTexture target) @extern("IsRenderTextureReady");
extern fn void unload_render_texture(RenderTexture target) @extern("UnloadRenderTexture");
extern fn void update_texture(Texture texture, void* pixels) @extern("UpdateTexture");
extern fn void update_texture_rec(Texture texture, Rectangle rec, void* pixels) @extern("UpdateTextureRec");

//= Texture configuration functions
extern fn void gen_texture_mipmaps(Texture* texture) @extern("GenTextureMipmaps");
extern fn void set_texture_filter(Texture texture, int filter) @extern("SetTextureFilter");
extern fn void set_texture_wrap(Texture texture, int wrap) @extern("SetTextureWrap");

//= Texture drawing functions
extern fn void draw_texture(Texture texture, int pos_x, int pos_y, Color tint) @extern("DrawTexture");
extern fn void draw_texture_v(Texture texture, Vector2 position, Color tint) @extern("DrawTextureV");
extern fn void draw_texture_ex(Texture texture, Vector2 position, float rotation, float scale, Color tint) @extern("DrawTextureEx");
extern fn void draw_texture_rec(Texture texture, Rectangle source, Vector2 position, Color tint) @extern("DrawTextureRec");
extern fn void draw_texture_pro(Texture texture, Rectangle source, Rectangle dest, Vector2 origin, float rotation, Color tint) @extern("DrawTexturePro");
extern fn void draw_texture_npatch(Texture texture, NPatchInfo npatch_info, Rectangle dest, Vector2 origin, float rotation, Color tint) @extern("DrawTextureNPatch");

//= Color/pixel related functions
// Get src alpha-blended into dst color with tint
extern fn Color color_alpha_blend(Color dst, Color src, Color tint) @extern("ColorAlphaBlend");
// Get Color structure from hexadecimal value
extern fn Color get_color(uint hexValue) @extern("GetColor");
// Get Color from a source pixel pointer of certain format
extern fn Color get_pixel_color(void* srcPtr, int format) @extern("GetPixelColor");
// Set color formatted into destination pixel pointer
extern fn void set_pixel_color(void* dstPtr, Color color, int format) @extern("SetPixelColor");
// Get pixel data size in bytes for certain format
extern fn int get_pixel_data_size(int width, int height, int format) @extern("GetPixelDataSize");

//= Font
//= Font loading/unloading functions
extern fn Font get_font_default() @extern("GetFontDefault");
extern fn Font load_font(char* fileName) @extern("LoadFont");
extern fn Font load_font_ex(char* fileName, int fontSize, int* codepoints, int codepointCount) @extern("LoadFontEx");
extern fn Font load_font_from_image(Image image, Color key, int firstChar) @extern("LoadFontFromImage");
extern fn Font load_font_from_memory(char* fileType, char* fileData, int dataSize, int fontSize, int* codepoints, int codepointCount) @extern("LoadFontFromMemory");
extern fn bool is_font_ready(Font font) @extern("IsFontReady");
// Load font data for further use
extern fn GlyphInfo* load_font_data(char* fileData, int dataSize, int fontSize, int* codepoints, int codepointCount, int type) @extern("LoadFontData");
// Generate image font atlas using chars info
extern fn Image gen_font_atlas(GlyphInfo* glyphs, Rectangle** glyphRecs, int glyphCount, int fontSize, int padding, int packMethod) @extern("GenImageFontAtlas");
// Unload font chars info data (RAM)
extern fn void unload_font_data(GlyphInfo* glyphs, int glyphCount) @extern("UnloadFontData");
// Unload font from GPU memory (VRAM)
extern fn void unload_font(Font font) @extern("UnloadFont");
// Export font as code file, returns true on success
extern fn bool export_font_as_code(Font font, char* fileName) @extern("ExportFontAsCode");

//= Text drawing functions
extern fn void draw_fps(int posX, int posY) @extern("DrawFPS");
extern fn void draw_text(char* text, int posX, int posY, int fontSize, Color color) @extern("DrawText");
extern fn void draw_text_ex(Font font, char* text, Vector2 position, float font_size, float spacing, Color tint) @extern("DrawTextEx");
extern fn void draw_text_pro(Font font, char* text, Vector2 position, Vector2 origin, float rotation, float font_size, float spacing, Color tint) @extern("DrawTextPro");
extern fn void draw_text_codepoint(Font font, int codepoint, Vector2 position, float fontSize, Color tint) @extern("DrawTextCodepoint");
extern fn void draw_text_codepoints(Font font, int* codepoints, int codepointCount, Vector2 position, float fontSize, float spacing, Color tint) @extern("DrawTextCodepoints");

//= Text font info functions
// Set vertical line spacing when drawing with line-breaks
extern fn void set_text_line_spacing(int spacing) @extern("SetTextLineSpacing");
// Measure string width for default font
extern fn int measure_text(char* text, int fontSize) @extern("MeasureText");
// Measure string size for Font
extern fn Vector2 measure_text_ex(Font font, char* text, float fontSize, float spacing) @extern("MeasureTextEx");
// Get glyph index position in font for a codepoint (unicode character), fallback to '?' if not found
extern fn int get_glyph_index(Font font, int codepoint) @extern("GetGlyphIndex");
// Get glyph font info data for a codepoint (unicode character), fallback to '?' if not found
extern fn GlyphInfo get_glyph_info(Font font, int codepoint) @extern("GetGlyphInfo");
// Get glyph rectangle in font atlas for a codepoint (unicode character), fallback to '?' if not found
extern fn Rectangle get_glyph_atlas_rec(Font font, int codepoint) @extern("GetGlyphAtlasRec");

//= Text codepoints management functions (unicode characters)
//char *LoadUTF8(const int *codepoints, int length);                // Load UTF-8 text encoded from codepoints array
//void UnloadUTF8(char *text);                                      // Unload UTF-8 text encoded from codepoints array
//int *LoadCodepoints(const char *text, int *count);                // Load all codepoints from a UTF-8 text string, codepoints count returned by parameter
//void UnloadCodepoints(int *codepoints);                           // Unload codepoints data from memory
//int GetCodepointCount(const char *text);                          // Get total number of codepoints in a UTF-8 encoded string
//int GetCodepoint(const char *text, int *codepointSize);           // Get next codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure
//int GetCodepointNext(const char *text, int *codepointSize);       // Get next codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure
//int GetCodepointPrevious(const char *text, int *codepointSize);   // Get previous codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure
//const char *CodepointToUTF8(int codepoint, int *utf8Size);        // Encode one codepoint into UTF-8 byte array (array length returned as parameter)



//= Bounding box
/// Model drawing functions
extern fn void draw_bounding_box(BoundingBox bounds, Color color) @extern("DrawBoundingBox");



// Text font info functions
//void SetTextLineSpacing(int spacing);                                                 // Set vertical line spacing when drawing with line-breaks
//int MeasureText(const char *text, int fontSize);                                      // Measure string width for default font
//Vector2 MeasureTextEx(Font font, const char *text, float fontSize, float spacing);    // Measure string size for Font
//int GetGlyphIndex(Font font, int codepoint);                                          // Get glyph index position in font for a codepoint (unicode character), fallback to '?' if not found
//GlyphInfo GetGlyphInfo(Font font, int codepoint);                                     // Get glyph font info data for a codepoint (unicode character), fallback to '?' if not found
//Rectangle GetGlyphAtlasRec(Font font, int codepoint);                                 // Get glyph rectangle in font atlas for a codepoint (unicode character), fallback to '?' if not found

// Text codepoints management functions (unicode characters)
//char *LoadUTF8(const int *codepoints, int length);                // Load UTF-8 text encoded from codepoints array
//void UnloadUTF8(char *text);                                      // Unload UTF-8 text encoded from codepoints array
//int *LoadCodepoints(const char *text, int *count);                // Load all codepoints from a UTF-8 text string, codepoints count returned by parameter
//void UnloadCodepoints(int *codepoints);                           // Unload codepoints data from memory
//int GetCodepointCount(const char *text);                          // Get total number of codepoints in a UTF-8 encoded string
//int GetCodepoint(const char *text, int *codepointSize);           // Get next codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure
//int GetCodepointNext(const char *text, int *codepointSize);       // Get next codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure
//int GetCodepointPrevious(const char *text, int *codepointSize);   // Get previous codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure
//const char *CodepointToUTF8(int codepoint, int *utf8Size);        // Encode one codepoint into UTF-8 byte array (array length returned as parameter)

// Text strings management functions (no UTF-8 strings, only byte chars)
// NOTE: Some strings allocate memory internally for returned strings, just be careful!
//int TextCopy(char *dst, const char *src);                                             // Copy one string to another, returns bytes copied
//bool TextIsEqual(const char *text1, const char *text2);                               // Check if two text string are equal
//unsigned int TextLength(const char *text);                                            // Get text length, checks for '\0' ending
//const char *TextFormat(const char *text, ...);                                        // Text formatting with variables (sprintf() style)
//const char *TextSubtext(const char *text, int position, int length);                  // Get a piece of a text string
//char *TextReplace(char *text, const char *replace, const char *by);                   // Replace text string (WARNING: memory must be freed!)
//char *TextInsert(const char *text, const char *insert, int position);                 // Insert text in a position (WARNING: memory must be freed!)
//const char *TextJoin(const char **textList, int count, const char *delimiter);        // Join text strings with delimiter
//const char **TextSplit(const char *text, char delimiter, int *count);                 // Split text into multiple strings
//void TextAppend(char *text, const char *append, int *position);                       // Append text at specific position and move cursor!
//int TextFindIndex(const char *text, const char *find);                                // Find first text occurrence within a string
//const char *TextToUpper(const char *text);                      // Get upper case version of provided string
//const char *TextToLower(const char *text);                      // Get lower case version of provided string
//const char *TextToPascal(const char *text);                     // Get Pascal case notation version of provided string
//int TextToInteger(const char *text);                            // Get integer value from text (negative values not supported)



//= Materials
//= Material loading/unloading functions
extern fn Material* load_materials(char* filename, int* materialCount) @extern("LoadMaterials");
extern fn Material load_material_default() @extern("LoadMaterialDefault");
extern fn bool is_material_ready(Material material) @extern("IsMaterialReady");
extern fn void unlaod_material(Material material) @extern("UnloadMaterial");
extern fn void set_material_texture(Material* material, int mapType, Texture texture) @extern("SetMaterialTexture");
