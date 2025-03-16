
module pleroma::raylib;


const String RAYLIB_VERSION = "5.5.0";


//= Window-related functions
// Initialize window and OpenGL context
extern fn void init_window(int width, int height, char* title) @extern("InitWindow");
// Close window and unload OpenGL context
extern fn void close_window() @extern("CloseWindow");
// Check if application should close (KEY_ESCAPE pressed or windows close icon clicked)
extern fn bool window_should_close() @extern("WindowShouldClose");
// Check if window has been initialized successfully
extern fn bool window_is_ready() @extern("IsWindowReady");
// Check if window is currently fullscreen
extern fn bool is_fullscreen() @extern("IsWindowFullscreen");
// Check if window is currently hidden
extern fn bool is_hidden() @extern("IsWindowHidden");
// Check if window is currently minimized
extern fn bool is_minimized() @extern("IsWindowMinimized");
// Check if window is currently maximized
extern fn bool is_maximized() @extern("IsWindowMaximized");
// Check if window is currently focused
extern fn bool is_focused() @extern("IsWindowFocused");
// Check if window has been resized last frame
extern fn bool is_resized() @extern("IsWindowResized");
// Check if one specific window flag is enabled
extern fn bool is_state(uint flag) @extern("IsWindowState");
// Set window configuration state using flags (only PLATFORM_DESKTOP)
extern fn void set_window_state(uint flag) @extern("SetWindowState");
// Clear window configuration state flags
extern fn void clear_window_state(uint flags) @extern("ClearWindowState");
// Toggle window state: fullscreen/windowed, resizes monitor to match window resolution
extern fn void toggle_fullscreen() @extern("ToggleFullscreen");
// Toggle window state: borderless windowed, resizes window to match monitor resolution
extern fn void toggle_borderless() @extern("ToggleBorderlessWindowed");
// Set window state: maximized, if resizable
extern fn void maximize() @extern("MaximizeWindow");
// Set window state: minimized, if resizable
extern fn void minimize() @extern("MinimizeWindow");
// Set window state: not minimized/maximized
extern fn void restore() @extern("RestoreWindow");
// Set icon for window (single image, RGBA 32bit, only PLATFORM_DESKTOP)
//extern fn void set_window_icon(Image image) @extern("SetWindowIcon");
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
// Get current screen width
extern fn int get_screen_width() @extern("GetScreenWidth");
// Get current screen height
extern fn int get_screen_height() @extern("GetScreenHeight");
// Get current render width (it considers HiDPI)
extern fn int get_render_width() @extern("GetRenderWidth");
// Get current render height (it considers HiDPI)
extern fn int get_render_height() @extern("GetRenderHeight");
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
extern fn void begin_drawing() @extern("BeginDrawing");
// End canvas drawing and swap buffers (double buffering)
extern fn void end_drawing() @extern("EndDrawing");
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
// Begin stereo rendering (requires VR simulator)
extern fn void begin_vr_mode(VrStereoConfig config) @extern("BeginVrStereoMode");
// End stereo rendering (requires VR simulator)
extern fn void end_vr_mode() @extern("EndVrStereoMode");

//= VR stereo config functions for VR simulator
// Load VR stereo config for VR simulator device parameters
extern fn VrStereoConfig load_vr_config(VrDeviceInfo device) @extern("LoadVrStereoConfig");
// Unload VR stereo config
extern fn void unload_ver_config(VrStereoConfig config) @extern("UnloadVrStereoConfig");

//= Shader management functions
//= NOTE: Shader functionality is not available on OpenGL 1.1
// Load shader from files and bind default locations
extern fn Shader load_shader(char* vsFilename, char* fsFilename) @extern("LoadShader");
// Load shader from code strings and bind default locations
extern fn Shader load_shader_memory(char* vsCode, char* fsCode) @extern("LoadShaderFromMemory");
// Check if a shader is ready
extern fn bool is_shader_ready(Shader shader) @extern("IsShaderValid");
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
// Get a ray trace from screen position (i.e mouse)
extern fn Ray get_screen_to_world(Vector2 position, Camera3D camera) @extern("GetScreenToWorldRay");
// Get a ray trace from screen position (i.e mouse) in a viewport
extern fn Ray get_screen_to_world_ex(Vector2 position, Camera3D camera, int width, int height) @extern("GetScreenToWorldRayEx");
// Get the screen space position for a 3d world space position
extern fn Vector2 get_world_to_screen(Vector3 position, Camera3D camera) @extern("GetWorldToScreen");
// Get size position for a 3d world space position
extern fn Vector2 get_world_to_screen_ex(Vector3 position, Camera3D camera, int width, int height) @extern("GetWorldToScreenEx");
// Get the screen space position for a 2d camera world space position
extern fn Vector2 get_world_to_screen_2d(Vector2 position, Camera2D camera) @extern("GetWorldToScreen2D");
// Get the world space position for a 2d camera screen space position
extern fn Vector2 get_screen_to_world_2d(Vector2 position, Camera2D camera) @extern("GetScreenToWorld2D");
// Get camera transform matrix (view matrix)
extern fn Matrix get_camera_matrix(Camera3D camera) @extern("GetCameraMatrix");
// Get camera 2d transform matrix
extern fn Matrix get_camera_matrix_2d(Camera2D camera) @extern("GetCameraMatrix2D");

//= Timing-related functions
// Set target FPS (maximum)
extern fn void set_target_fps(int fps) @extern("SetTargetFPS");
// Get time in seconds for last frame drawn (delta time)
extern fn float get_frame_time() @extern("GetFrameTime");
// Get elapsed time in seconds since InitWindow()
extern fn double get_time() @extern("GetTime");
// Get current FPS
extern fn int get_fps() @extern("GetFPS");

//= Custom frame control functions
// NOTE: Those functions are intended for advance users that want full control over the frame processing
// By default EndDrawing() does this job: draws everything + SwapScreenBuffer() + manage frame timing + PollInputEvents()
// To avoid that behaviour and control frame processes manually, enable in config.h: SUPPORT_CUSTOM_FRAME_CONTROL

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

//= Show trace log messages (LOG_DEBUG, LOG_INFO, LOG_WARNING, LOG_ERROR...)
//extern fn void tracelog(int logLevel, const char *text, ...) @extern("TraceLog");
// Set custom trace log
extern fn void set_trace_log_level(TraceLogLevel logLevel) @extern("SetTraceLogLevel");
// Internal memory allocator
extern fn void* memalloc(uint size) @extern("MemAlloc");
// Internal memory reallocator
extern fn void* memrealloc(void* ptr, uint size) @extern("MemRealloc");
// Internal memory free
extern fn void memfree(void *ptr) @extern("MemFree");

//= Set custom callbacks
// WARNING: Callbacks setup is intended for advanced users

// Set custom trace log
//extern fn void (TraceLogCallback callback) @extern("SetTraceLogCallback");
// Set custom file binary data loader
//extern fn void (LoadFileDataCallback callback) @extern("SetLoadFileDataCallback");
// Set custom file binary data saver
//extern fn void (SaveFileDataCallback callback) @extern("SetSaveFileDataCallback");
// Set custom file text data loader
//extern fn void (LoadFileTextCallback callback) @extern("SetLoadFileTextCallback");
// Set custom file text data saver
//extern fn void (SaveFileTextCallback callback) @extern("MemFSetSaveFileTextCallbackree");

//= Files management functions
// Load file data as byte array (read)
extern fn char* load_file(char* fileName, int *dataSize) @extern("LoadFileData");
// Unload file data allocated by LoadFileData()
extern fn void unload_file(char* data) @extern("UnloadFileData");
// Save data to file from byte array (write), returns true on success
extern fn bool save_file(char* fileName, void *data, int dataSize) @extern("SaveFileData");
// Export data to code (.h), returns true on success
extern fn bool export_data(char* data, int dataSize, char* fileName) @extern("ExportDataAsCode");
// Load text data from file (read), returns a '\0' terminated string
extern fn char* load_file_text(char* fileName) @extern("LoadFileText");
// Unload file text data allocated by LoadFileText()
extern fn void unload_file_text(char *text) @extern("UnloadFileText");
// Save text data to file (write), string must be '\0' terminated, returns true on success
extern fn bool save_file_text(char* fileName, char* text) @extern("SaveFileText");

// TODO: Remaining functions

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
// Compute CRC32 hash code
extern fn uint compute_crc32(char *data, int dataSize) @extern("ComputeCRC32");
// Compute MD5 hash code, returns static int[4] (16 bytes)
extern fn uint* compute_md5(char *data, int dataSize) @extern("ComputeMD5");
// Compute SHA1 hash code, returns static int[5] (20 bytes)
extern fn uint* compute_sha1(char *data, int dataSize) @extern("ComputeSHA1");

//= Automation events functionality
// TODO:

//= Input-related functions: keyboard
// Check if a key has been pressed once
extern fn bool is_key_pressed(KeyboardKey key) @extern("IsKeyPressed");
// Check if a key has been pressed again (Only PLATFORM_DESKTOP)
extern fn bool is_key_repeat(KeyboardKey key) @extern("IsKeyPressedRepeat");
// Check if a key is being pressed
extern fn bool is_key_down(KeyboardKey key) @extern("IsKeyDown");
// Check if a key has been released once
extern fn bool is_key_released(KeyboardKey key) @extern("IsKeyReleased");
// Check if a key is NOT being pressed
extern fn bool is_key_up(KeyboardKey key) @extern("IsKeyUp");
// Get key pressed (keycode), call it multiple times for keys queued, returns 0 when the queue is empty
extern fn KeyboardKey get_key_pressed() @extern("GetKeyPressed");
// Get char pressed (unicode), call it multiple times for chars queued, returns 0 when the queue is empty
extern fn int get_char_pressed() @extern("GetCharPressed");
// Set a custom key to exit program (default is ESC)
extern fn void set_exit_key(KeyboardKey key) @extern("SetExitKey");

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
// Set gamepad vibration for both motors (duration in seconds)
extern fn void set_gamepad_vibration(int gamepad, float leftMotor, float rightMotor, float duration) @extern("SetGamepadVibration");

//= Input-related functions: mouse
// Check if a mouse button has been pressed once
extern fn bool is_mouse_button_pressed(MouseButton button) @extern("IsMouseButtonPressed");
// Check if a mouse button is being pressed
extern fn bool is_mouse_button_down(MouseButton button) @extern("IsMouseButtonDown");
// Check if a mouse button has been released once
extern fn bool is_mouse_button_released(MouseButton button) @extern("IsMouseButtonReleased");
// Check if a mouse button is NOT being pressed
extern fn bool is_mouse_button_up(MouseButton button) @extern("IsMouseButtonUp");
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

//= Input-related functions: touch
// TODO:

//= Gestures and Touch Handling Functions (Module: rgestures)
// TODO: 


//= rShapes
// TODO:


//= rTextures
//= Image loading functions
// Load image sequence from memory buffer
extern fn Image load_image_anim_from_memory(char* fileType, char* fileData, int dataSize, int* frames) @extern("LoadImageAnimFromMemory");
// Load image from screen buffer and (screenshot)
extern fn Image load_image_from_screen() @extern("LoadImageFromScreen");
// Export image as code file defining an array of bytes, returns true on success
extern fn bool export_image_as_code(Image image, char* file) @extern("ExportImageAsCode");

//= Image manipulation functions
// Apply custom square convolution kernel to image
extern fn void image_kernel_convolution(Image* image, float* kernel, int kernelSize) @extern("ImageKernelConvolution");

//= Image drawing functions
// Draw a triangle fan defined by points within an image (first vertex is the center)
extern fn void image_draw_triangle_fan(Image* dst, Vector2* points, int pointCount, Color color) @extern("ImageDrawTriangleFan");
// Draw a triangle strip defined by points within an image
extern fn void image_draw_triangle_strip(Image* dst, Vector2* points, int pointCount, Color color) @extern("ImageDrawTriangleStrip");

//= Texture loading functions
// Load texture from file into GPU memory (VRAM)
extern fn Texture load_texture(char* filename) @extern("LoadTexture");
// Load cubemap from image, multiple image cubemap layouts supported
extern fn Texture load_texture_cubemap(Image image, int layout) @extern("LoadTextureCubemap");
// Load texture for rendering (framebuffer)
extern fn RenderTexture load_render_texture(int width, int height) @extern("LoadRenderTexture");
// Check if a texture is ready
extern fn bool is_texture_ready(Texture texture) @extern("IsTextureValid");
// Unload texture from GPU memory (VRAM)
extern fn void unload_texture(Texture texture) @extern("UnloadTexture");
// Check if a render texture is ready
extern fn bool is_render_texture_ready(RenderTexture target) @extern("IsRenderTextureValid");
// Unload render texture from GPU memory (VRAM)
extern fn void unload_render_texture(RenderTexture target) @extern("UnloadRenderTexture");
// Update GPU texture with new data
extern fn void update_texture(Texture texture, void* pixels) @extern("UpdateTexture");
// Update GPU texture rectangle with new data
extern fn void update_texture_rec(Texture texture, Rectangle rec, void* pixels) @extern("UpdateTextureRec");

//= Texture configuration functions
// Generate GPU mipmaps for a texture
extern fn void gen_texture_mipmaps(Texture* texture) @extern("GenTextureMipmaps");
// Set texture scaling filter mode
extern fn void set_texture_filter(Texture texture, int filter) @extern("SetTextureFilter");
// Set texture wrapping mode
extern fn void set_texture_wrap(Texture texture, int wrap) @extern("SetTextureWrap");

//= Texture drawing functions
// Draw a Texture2D
extern fn void draw_texture(Texture texture, int pos_x, int pos_y, Color tint) @extern("DrawTexture");
// Draw a Texture2D with position defined as Vector2
extern fn void draw_texture_v(Texture texture, Vector2 position, Color tint) @extern("DrawTextureV");
// Draw a Texture2D with extended parameters
extern fn void draw_texture_ex(Texture texture, Vector2 position, float rotation, float scale, Color tint) @extern("DrawTextureEx");
// Draw a part of a texture defined by a rectangle
extern fn void draw_texture_rec(Texture texture, Rectangle source, Vector2 position, Color tint) @extern("DrawTextureRec");
// Draw a part of a texture defined by a rectangle with 'pro' parameters
extern fn void draw_texture_pro(Texture texture, Rectangle source, Rectangle dest, Vector2 origin, float rotation, Color tint) @extern("DrawTexturePro");
// Draws a texture (or part of it) that stretches or shrinks nicely
extern fn void draw_texture_npatch(Texture texture, NPatchInfo npatch_info, Rectangle dest, Vector2 origin, float rotation, Color tint) @extern("DrawTextureNPatch");

//= Color/pixel related functions
// TODO:

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


//= rtext
// Load font from file with extended parameters, use NULL for codepoints and 0 for codepointCount to load the default character set, font size is provided in pixels height
extern fn Font load_font_ex(char* fileName, int fontSize, int* codepoints, int codepointCount) @extern("LoadFontEx");
// Load font from memory buffer, fileType refers to extension: i.e. '.ttf'
extern fn Font load_font_from_memory(char* fileType, char* fileData, int dataSize, int fontSize, int* codepoints, int codepointCount) @extern("LoadFontFromMemory");
// Load font data for further use
extern fn GlyphInfo* load_font_data(char* fileData, int dataSize, int fontSize, int* codepoints, int codepointCount, int type) @extern("LoadFontData");
// Generate image font atlas using chars info
extern fn Image gen_font_atlas(GlyphInfo* glyphs, Rectangle** glyphRecs, int glyphCount, int fontSize, int padding, int packMethod) @extern("GenImageFontAtlas");
// Unload font chars info data (RAM)
extern fn void unload_font_data(GlyphInfo* glyphs, int glyphCount) @extern("UnloadFontData");
// Export font as code file, returns true on success
extern fn bool export_font_as_code(Font font, char* fileName) @extern("ExportFontAsCode");
//= Text drawing functions
// Draw current FPS
extern fn void draw_fps(int posX, int posY) @extern("DrawFPS");
// Draw text (using default font)
extern fn void draw_text(char* text, int posX, int posY, int fontSize, Color color) @extern("DrawText");
// Draw one character (codepoint)
extern fn void draw_text_codepoint(Font font, int codepoint, Vector2 position, float fontSize, Color tint) @extern("DrawTextCodepoint");
// Draw multiple character (codepoint)
extern fn void draw_text_codepoints(Font font, int* codepoints, int codepointCount, Vector2 position, float fontSize, float spacing, Color tint) @extern("DrawTextCodepoints");

//= Text font info functions
// Set vertical line spacing when drawing with line-breaks
extern fn void set_text_line_spacing(int spacing) @extern("SetTextLineSpacing");
// Measure string width for default font
extern fn int measure_text(char* text, int fontSize) @extern("MeasureText");
// Get glyph index position in font for a codepoint (unicode character), fallback to '?' if not found
extern fn int get_glyph_index(Font font, int codepoint) @extern("GetGlyphIndex");
// Get glyph font info data for a codepoint (unicode character), fallback to '?' if not found
extern fn GlyphInfo get_glyph_info(Font font, int codepoint) @extern("GetGlyphInfo");
// Get glyph rectangle in font atlas for a codepoint (unicode character), fallback to '?' if not found
extern fn Rectangle get_glyph_atlas_rec(Font font, int codepoint) @extern("GetGlyphAtlasRec");

//= Text codepoints management functions (unicode characters)
// TODO:

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
// TODO:

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

//= rmodels
// Basic geometric 3D shapes drawing functions
// TODO:
//void DrawLine3D(Vector3 startPos, Vector3 endPos, Color color);                                    // Draw a line in 3D world space
//void DrawPoint3D(Vector3 position, Color color);                                                   // Draw a point in 3D space, actually a small line
//void DrawCircle3D(Vector3 center, float radius, Vector3 rotationAxis, float rotationAngle, Color color); // Draw a circle in 3D world space
//void DrawTriangle3D(Vector3 v1, Vector3 v2, Vector3 v3, Color color);                              // Draw a color-filled triangle (vertex in counter-clockwise order!)
//void DrawTriangleStrip3D(const Vector3 *points, int pointCount, Color color);                      // Draw a triangle strip defined by points
//void DrawCube(Vector3 position, float width, float height, float length, Color color);             // Draw cube
//void DrawCubeV(Vector3 position, Vector3 size, Color color);                                       // Draw cube (Vector version)
//void DrawCubeWires(Vector3 position, float width, float height, float length, Color color);        // Draw cube wires
//void DrawCubeWiresV(Vector3 position, Vector3 size, Color color);                                  // Draw cube wires (Vector version)
//void DrawSphere(Vector3 centerPos, float radius, Color color);                                     // Draw sphere
//void DrawSphereEx(Vector3 centerPos, float radius, int rings, int slices, Color color);            // Draw sphere with extended parameters
//void DrawSphereWires(Vector3 centerPos, float radius, int rings, int slices, Color color);         // Draw sphere wires
//void DrawCylinder(Vector3 position, float radiusTop, float radiusBottom, float height, int slices, Color color); // Draw a cylinder/cone
//void DrawCylinderEx(Vector3 startPos, Vector3 endPos, float startRadius, float endRadius, int sides, Color color); // Draw a cylinder with base at startPos and top at endPos
//void DrawCylinderWires(Vector3 position, float radiusTop, float radiusBottom, float height, int slices, Color color); // Draw a cylinder/cone wires
//void DrawCylinderWiresEx(Vector3 startPos, Vector3 endPos, float startRadius, float endRadius, int sides, Color color); // Draw a cylinder wires with base at startPos and top at endPos
//void DrawCapsule(Vector3 startPos, Vector3 endPos, float radius, int slices, int rings, Color color); // Draw a capsule with the center of its sphere caps at startPos and endPos
//void DrawCapsuleWires(Vector3 startPos, Vector3 endPos, float radius, int slices, int rings, Color color); // Draw capsule wireframe with the center of its sphere caps at startPos and endPos
//void DrawPlane(Vector3 centerPos, Vector2 size, Color color);                                      // Draw a plane XZ
//void DrawRay(Ray ray, Color color);                                                                // Draw a ray line
//void DrawGrid(int slices, float spacing);                                                          // Draw a grid (centered at (0, 0, 0))

// Model management functions
// Load model from files (meshes and materials)
extern fn Model load_model(char* fileName) @extern("LoadModel");
// Load model from generated mesh (default material)
extern fn Model load_model_from_mesh(Mesh mesh) @extern("LoadModelFromMesh");
// Check if a model is valid (loaded in GPU, VAO/VBOs)
extern fn bool is_model_valid(Model model) @extern("IsModelValid");
// Unload model (including meshes) from memory (RAM and/or VRAM)
extern fn void unload_model(Model model) @extern("UnloadModel");
// Compute model bounding box limits (considers all meshes)
extern fn BoundingBox get_model_bounds(Model model) @extern("GetModelBoundingBox");

// Model drawing functions
// Draw a model (with texture if set)
extern fn void draw_model(Model model, Vector3 position, float scale, Color tint) @extern("DrawModel");
// Draw a model with extended parameters
extern fn void draw_model_ex(Model model, Vector3 position, Vector3 rotationAxis, float rotationAngle, Vector3 scale, Color tint) @extern("DrawModelEx");
// Draw a model wires (with texture if set)
extern fn void draw_model_wires(Model model, Vector3 position, float scale, Color tint) @extern("DrawModelWires");
// Draw a model wires (with texture if set) with extended parameters
extern fn void draw_model_wires_ex(Model model, Vector3 position, Vector3 rotationAxis, float rotationAngle, Vector3 scale, Color tint) @extern("DrawModelWiresEx");
// Draw a model as points
extern fn void draw_model_points(Model model, Vector3 position, float scale, Color tint) @extern("DrawModelPoints");
// Draw a model as points with extended parameters
extern fn void draw_model_points_ex(Model model, Vector3 position, Vector3 rotationAxis, float rotationAngle, Vector3 scale, Color tint) @extern("DrawModelPointsEx");
// Draw bounding box (wires)
//extern fn void draw_bounds(BoundingBox box, Color color) @extern("DrawBoundingBox");
// Draw a billboard texture
extern fn void draw_billboard(Camera3D camera, Texture texture, Vector3 position, float scale, Color tint) @extern("DrawBillboard");
// Draw a billboard texture defined by source
extern fn void draw_billboard_rec(Camera3D camera, Texture texture, Rectangle source, Vector3 position, Vector2 size, Color tint) @extern("DrawBillboardRec");
// Draw a billboard texture defined by source and rotation
extern fn void draw_billboard_pro(Camera3D camera, Texture texture, Rectangle source, Vector3 position, Vector3 up, Vector2 size, Vector2 origin, float rotation, Color tint) @extern("DrawBillboardPro");

// Mesh management functions
// Upload mesh vertex data in GPU and provide VAO/VBO ids
extern fn void upload_mesh(Mesh *mesh, bool dynamic) @extern("UploadMesh");
// Update mesh vertex data in GPU for a specific buffer index
extern fn void update_mesh(Mesh mesh, int index, void* data, int dataSize, int offset) @extern("UpdateMeshBuffer");
// Unload mesh data from CPU and GPU
extern fn void unload_mesh(Mesh mesh) @extern("UnloadMesh");
// Draw a 3d mesh with material and transform
extern fn void draw_mesh(Mesh mesh, Material material, Matrix transform) @extern("DrawMesh");
// Draw multiple mesh instances with material and different transforms
extern fn void draw_mesh_instanced(Mesh mesh, Material material, Matrix* transforms, int instances) @extern("DrawMeshInstanced");
// Compute mesh bounding box limits
extern fn BoundingBox get_mesh_bounds(Mesh mesh) @extern("GetMeshBoundingBox");
// Compute mesh tangents
extern fn void gen_mesh_tangents(Mesh *mesh) @extern("GenMeshTangents");
// Export mesh data to file, returns true on success
extern fn bool export_mesh(Mesh mesh, char* fileName) @extern("ExportMesh");
// Export mesh as code file (.h) defining multiple arrays of vertex attributes
extern fn bool export_mesh_code(Mesh mesh, char* fileName) @extern("ExportMeshAsCode");

// Mesh generation functions
// Generate polygonal mesh
extern fn Mesh gen_mesh_poly(int sides, float radius) @extern("GenMeshPoly");
// Generate plane mesh (with subdivisions)
extern fn Mesh gen_mesh_plane(float width, float length, int resX, int resZ) @extern("GenMeshPlane");
// Generate cuboid mesh
extern fn Mesh gen_mesh_cube(float width, float height, float length) @extern("GenMeshCube");
// Generate sphere mesh (standard sphere)
extern fn Mesh gen_mesh_sphere(float radius, int rings, int slices) @extern("GenMeshSphere");
// Generate half-sphere mesh (no bottom cap)
extern fn Mesh gen_mesh_hemi(float radius, int rings, int slices) @extern("GenMeshHemiSphere");
// Generate cylinder mesh
extern fn Mesh gen_mesh_cylinder(float radius, float height, int slices) @extern("GenMeshCylinder");
// Generate cone/pyramid mesh
extern fn Mesh gen_mesh_cone(float radius, float height, int slices) @extern("GenMeshCone");
// Generate torus mesh
extern fn Mesh gen_mesh_torus(float radius, float size, int radSeg, int sides) @extern("GenMeshTorus");
// Generate trefoil knot mesh
extern fn Mesh gen_mesh_knot(float radius, float size, int radSeg, int sides) @extern("GenMeshKnot");
// Generate heightmap mesh from image data
extern fn Mesh gen_mesh_heightmap(Image heightmap, Vector3 size) @extern("GenMeshHeightmap");
// Generate cubes-based map mesh from image data
extern fn Mesh gen_mesh_cubicmap(Image cubicmap, Vector3 cubeSize) @extern("GenMeshCubicmap");

//= Material loading/unloading functions
// Load materials from model file
extern fn Material* load_materials(char* filename, int* materialCount) @extern("LoadMaterials");
// Load default material (Supports: DIFFUSE, SPECULAR, NORMAL maps)
extern fn Material load_material_default() @extern("LoadMaterialDefault");
// Check if a material is valid (shader assigned, map textures loaded in GPU)
extern fn bool is_material_ready(Material material) @extern("IsMaterialValid");
// Unload material from GPU memory (VRAM)
extern fn void unload_material(Material material) @extern("UnloadMaterial");
// Set texture for a material map type (MATERIAL_MAP_DIFFUSE, MATERIAL_MAP_SPECULAR...)
extern fn void set_material_texture(Material* material, int mapType, Texture texture) @extern("SetMaterialTexture");
// Set material for a mesh
extern fn void set_model_material(Model *model, int meshId, int materialId) @extern("SetModelMeshMaterial");

// Model animations loading/unloading functions
// Load model animations from file
extern fn ModelAnimation* load_model_animations(String fileName, int* animCount) @extern("LoadModelAnimations");
// Update model animation pose (CPU)
extern fn void update_model_animation(Model model, ModelAnimation anim, int frame) @extern("UpdateModelAnimation");
// Update model animation mesh bone matrices (GPU skinning)
extern fn void update_model_animation_bones(Model model, ModelAnimation anim, int frame) @extern("UpdateModelAnimationBones");
// Unload animation data
extern fn void unload_model_animation(ModelAnimation anim) @extern("UnloadModelAnimation");
// Unload animation array data
extern fn void unload_model_animations(ModelAnimation *animations, int animCount) @extern("UnloadModelAnimations");
// Check model animation skeleton match
extern fn bool is_model_animation_valid(Model model, ModelAnimation anim) @extern("IsModelAnimationValid");

// Collision detection functions
// Check collision between two spheres
extern fn bool check_collision_spheres(Vector3 center1, float radius1, Vector3 center2, float radius2) @extern("CheckCollisionSpheres");
// Check collision between two bounding boxes
extern fn bool check_collision_boxes(BoundingBox box1, BoundingBox box2) @extern("CheckCollisionBoxes");
// Check collision between box and sphere
extern fn bool check_collision_box_sphere(BoundingBox box, Vector3 center, float radius) @extern("CheckCollisionBoxSphere");
// Get collision info between ray and sphere
extern fn RayCollision get_ray_collision_sphere(Ray ray, Vector3 center, float radius) @extern("GetRayCollisionSphere");
// Get collision info between ray and box
extern fn RayCollision get_ray_collision_box(Ray ray, BoundingBox box) @extern("GetRayCollisionBox");
// Get collision info between ray and mesh
extern fn RayCollision get_ray_collision_mesh(Ray ray, Mesh mesh, Matrix transform) @extern("GetRayCollisionMesh");
// Get collision info between ray and triangle
extern fn RayCollision get_ray_collision_triangle(Ray ray, Vector3 p1, Vector3 p2, Vector3 p3) @extern("GetRayCollisionTriangle");
// Get collision info between ray and quad
extern fn RayCollision get_ray_collision_quad(Ray ray, Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4) @extern("GetRayCollisionQuad");


