
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
//extern fn void begin_texture_mode(RenderTexture target) @extern("BeginTextureMode");
// Ends drawing to render texture
//extern fn void end_texture_mode() @extern("EndTextureMode");
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
// Load cubemap from image, multiple image cubemap layouts supported
extern fn Texture load_texture_cubemap(Image image, int layout) @extern("LoadTextureCubemap");


//= Color/pixel related functions
// Get src alpha-blended into dst color with tint
extern fn Color color_alpha_blend(Color dst, Color src, Color tint) @extern("ColorAlphaBlend");

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
// Measure string size for Font
extern fn Vector2 measure_text_ex(Font font, char* text, float fontSize, float spacing) @extern("MeasureTextEx");
// Get glyph index position in font for a codepoint (unicode character), fallback to '?' if not found
extern fn int get_glyph_index(Font font, int codepoint) @extern("GetGlyphIndex");
// Get glyph font info data for a codepoint (unicode character), fallback to '?' if not found
extern fn GlyphInfo get_glyph_info(Font font, int codepoint) @extern("GetGlyphInfo");
// Get glyph rectangle in font atlas for a codepoint (unicode character), fallback to '?' if not found
extern fn Rectangle get_glyph_atlas_rec(Font font, int codepoint) @extern("GetGlyphAtlasRec");


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

// Mesh management functions
// Upload mesh vertex data in GPU and provide VAO/VBO ids
extern fn void upload_mesh(Mesh *mesh, bool dynamic) @extern("UploadMesh");
// Update mesh vertex data in GPU for a specific buffer index
extern fn void update_mesh(Mesh mesh, int index, void* data, int dataSize, int offset) @extern("UpdateMeshBuffer");
// Export mesh as code file (.h) defining multiple arrays of vertex attributes
extern fn bool export_mesh_code(Mesh mesh, char* fileName) @extern("ExportMeshAsCode");

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


