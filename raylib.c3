module pleroma;


//= Font
/// Font loading/unloading functions
extern fn Font get_font_default() @extern("GetFontDefault");
extern fn Font load_font(char* fileName) @extern("LoadFont");
extern fn Font load_font_ex(char* fileName, int fontSize, int* codepoints, int codepointCount) @extern("LoadFontEx");
extern fn Font load_font_from_image(Image image, Color key, int firstChar) @extern("LoadFontFromImage");
extern fn Font load_font_from_memory(char* fileType, char* fileData, int dataSize, int fontSize, int* codepoints, int codepointCount) @extern("LoadFontFromMemory");
extern fn bool is_font_ready(Font font) @extern("IsFontReady");
extern fn void unload_font(Font font) @extern("UnloadFont");

/// Text drawing functions
extern fn void draw_text(char* text, int posX, int posY, int fontSize, Color color) @extern("DrawText");
extern fn void draw_text_ex(Font font, char* text, Vector2 position, float font_size, float spacing, Color tint) @extern("DrawTextEx");
extern fn void draw_text_pro(Font font, char* text, Vector2 position, Vector2 origin, float rotation, float font_size, float spacing, Color tint) @extern("DrawTextPro");

// Text drawing functions
//void DrawTextPro(Font font, const char *text, Vector2 position, Vector2 origin, float rotation, float fontSize, float spacing, Color tint); // Draw text using Font and pro parameters (rotation)
//void DrawTextCodepoint(Font font, int codepoint, Vector2 position, float fontSize, Color tint); // Draw one character (codepoint)
//void DrawTextCodepoints(Font font, const int *codepoints, int codepointCount, Vector2 position, float fontSize, float spacing, Color tint); // Draw multiple character (codepoint)

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


//= Image
//= Image loading functions
extern fn Image load_image(char* filename) @extern("LoadImage");
extern fn Image load_image_raw(char* filename, int width, int height, PixelFormat format, int header_size) @extern("LoadImageRaw");
extern fn Image load_image_svg(char* filename, int width, int height) @extern("LoadImageSvg");
extern fn Image load_image_anim(char* fileName, int* frames) @extern("LoadImageAnim");
extern fn Image load_image_from_memory(char* fileType, char* fileData, int dataSize) @extern("LoadImageFromMemory");
extern fn Image load_image_from_texture(Texture texture) @extern("LoadImageFromTexture");
extern fn Image load_image_from_screen() @extern("LoadImageFromScreen");
extern fn bool is_image_ready(Image image) @extern("IsImageReady");
extern fn void unload_image(Image image) @extern("UnloadImage");
extern fn bool export_image(Image image, char* filename) @extern("ExportImage");
extern fn char* export_image_to_memory(Image image, char* fileType, int* fileSize) @extern("ExportImageToMemory");
extern fn bool export_image_as_code(Image image, char* file) @extern("ExportImageAsCode");

//= Image generation functions
extern fn Image gen_image_color(int width, int height, Color color) @extern("GenImageColor");
extern fn Image gen_image_gradient_linear(int width, int height, int direction, Color start, Color end) @extern("GenImageGradientLinear");
extern fn Image gen_image_gradient_radial(int width, int height, float density, Color inner, Color outer) @extern("GenImageGradientRadial");
extern fn Image gen_image_gradient_square(int width, int height, float density, Color inner, Color outer) @extern("GenImageGradientSquare");
extern fn Image gen_image_checked(int width, int height, int checksX, int checksY, Color col1, Color col2) @extern("GenImageChecked");
extern fn Image gen_image_white_noise(int width, int height, float factor) @extern("GenImageWhiteNoise");
extern fn Image gen_image_perlin_noise(int width, int height, int offsetX, int offsetY, float scale,) @extern("GenImagePerlinNoise");
extern fn Image gen_image_cellular(int width, int height, int tileSize) @extern("GenImageCellular");
extern fn Image gen_image_text(int width, int height, char* text) @extern("GenImageText");

//= Image manipulation functions
extern fn Image image_copy(Image image) @extern("ImageCopy");
extern fn Image image_from_image(Image image, Rectangle rec) @extern("ImageFromImage");
extern fn Image image_text(char* text, int fontSize, Color color) @extern("ImageText");
extern fn Image image_text_ex(Font font, char* text, float fontSize, float spacing, Color tint) @extern("ImageTextEx");
extern fn void image_format(Image* image, int newFormat) @extern("ImageFormat");
extern fn void image_to_pot(Image* image, Color fill) @extern("ImageToPOT");
extern fn void image_crop(Image* image, Rectangle crop) @extern("ImageCrop");
extern fn void image_alpha_crop(Image* image, float threshold) @extern("ImageAlphaCrop");
extern fn void image_alpha_clear(Image* image, Color color, float threshold) @extern("ImageAlphaClear");
extern fn void image_alpha_mask(Image* image, Image alphaMask) @extern("ImageAlphaMask");
extern fn void image_alpha_premultiply(Image* image) @extern("ImageAlphaPremultiply");
extern fn void image_blur_gaussian(Image* image, int blurSize) @extern("ImageBlurGaussian");
extern fn void image_resize(Image* image, int newWidth, int newHeight) @extern("ImageResize");
extern fn void image_resize_nn(Image* image, int newWidth, int newHeight) @extern("ImageResizeNN");
extern fn void image_resize_canvas(Image* image, int newWidth, int newHeight, int offsetX, int offsetY, Color fill) @extern("ImageResizeCanvas");
extern fn void image_mipmaps(Image* image) @extern("ImageMipmaps");
extern fn void image_dither(Image* image, int rBpp, int gBpp, int bBpp, int aBpp) @extern("ImageDither");
extern fn void image_flip_vertical(Image* image) @extern("ImageFlipVertical");
extern fn void image_flip_horizontal(Image* image) @extern("ImageFlipHorizontal");
extern fn void image_rotate(Image* image, int degrees) @extern("ImageRotate");
extern fn void image_rotate_cw(Image* image) @extern("ImageRotateCW");
extern fn void image_rotate_ccw(Image* image) @extern("ImageRotateCCW");
extern fn void image_color_tint(Image* image, Color color) @extern("ImageColorTint");
extern fn void image_color_invert(Image* image) @extern("ImageColorInvert");
extern fn void image_color_grayscale(Image* image) @extern("ImageColorGrayscale");
extern fn void image_color_contrast(Image* image, float contrast) @extern("ImageColorContrast");
extern fn void image_color_brightness(Image* image, int brightness) @extern("ImageColorBrightness");
extern fn void image_color_replace(Image* image, Color color, Color replace) @extern("ImageColorReplace");
extern fn Color* load_image_palette(Image image, int maxPaletteSize, int* colorCount) @extern("LoadImagePalette");
extern fn Rectangle get_image_alpha_border(Image image, float threshold) @extern("GetImageAlphaBorder");
extern fn void unload_image_palette(Color* colors) @extern("UnloadImagePalette");
extern fn Color get_image_color(Image* image, int x, int y) @extern("GetImageColor");

//= Image drawing functions
extern fn void image_clear_background(Image* dst, Color color) @extern("ImageClearBackground");
extern fn void image_draw_pixel(Image* dst, int posX, int posY, Color color) @extern("ImageDrawPixel");
extern fn void image_draw_pixel_v(Image* dst, Vector2 position, Color color) @extern("ImageDrawPixelV");
extern fn void image_draw_line(Image* dst, int startPosX, int startPosY, int endPosX, int endPosY, Color color) @extern("ImageDrawLine");
extern fn void image_draw_line_v(Image* dst, Vector2 start, Vector2 end, Color color) @extern("ImageDrawLineV");
extern fn void image_draw_circle(Image* dst, int centerX, int centerY, int radius, Color color) @extern("ImageDrawCircle");
extern fn void image_draw_circle_v(Image* dst, Vector2 center, int radius, Color color) @extern("ImageDrawCircleV");
extern fn void image_draw_circle_lines(Image* dst, int centerX, int centerY, int radius, Color color) @extern("ImageDrawCircleLines");
extern fn void image_draw_circle_lines_v(Image* dst, Vector2 center, int radius, Color color) @extern("ImageDrawCircleLinesV");
extern fn void image_draw_rectangle(Image* dst, int posX, int posY, int width, int height, Color color) @extern("ImageDrawRectangle");
extern fn void image_draw_rectangle_v(Image* dst, Vector2 position, Vector2 size, Color color) @extern("ImageDrawRectangleV");
extern fn void image_draw_rectangle_rec(Image* dst, Rectangle rec, Color color) @extern("ImageDrawRectangleRec");
extern fn void image_draw_rectangle_lines(Image* dst, Rectangle rec, int thick, Color color) @extern("ImageDrawRectangleLines");
extern fn void image_draw(Image* dst, Image src, Rectangle srcRec, Rectangle dstRec, Color tint) @extern("ImageDraw");
extern fn void image_draw_text(Image* dst, char* text, int posX, int posY, int fontSize, Color color) @extern("ImageDrawText");
extern fn void image_draw_text_ex(Image* dst, Font font, char* text, Vector2 position, float fontSize, float spacing, Color tint) @extern("ImageDrawTextEx");

//= Texture loading functions
extern fn Texture load_texture_from_image(Image image) @extern("LoadTextureFromImage");
extern fn Texture load_texture_cubemap(Image image, int layout) @extern("LoadTextureCubemap");


//= Materials
//= Material loading/unloading functions
extern fn Material* load_materials(char* filename, int* materialCount) @extern("LoadMaterials");
extern fn Material load_material_default() @extern("LoadMaterialDefault");
extern fn bool is_material_ready(Material material) @extern("IsMaterialReady");
extern fn void unlaod_material(Material material) @extern("UnloadMaterial");
extern fn void set_material_texture(Material* material, int mapType, Texture texture) @extern("SetMaterialTexture");


//= Shaders
//= Drawing-related functions
extern fn void begin_shader_mode(Shader shader) @extern("BeginShaderMode");
extern fn void end_shader_mode() @extern("EndShaderMode");

//= Shader management functions
extern fn Shader load_shader(char* vsFilename, char* fsFilename) @extern("LoadShader");
extern fn bool is_shader_ready(Shader shader) @extern("IsShaderReady");
extern fn int get_shader_location(Shader shader, char* uniformName) @extern("GetShaderLocation");
//extern "C" { fn GetShaderLocationAttrib(shader: ShaderRl, atttribName: *const i8) -> i32; }
extern fn void set_shader_value(Shader shader, int locIndex, void* value, int uniformType) @extern("SetShaderValue");
extern fn void set_shader_value_v(Shader shader, int locIndex, void* value, int uniformType) @extern("SetShaderValueV");
//extern "C" { fn SetShaderValueMatrix(shader: ShaderRl, locIndex: i32, value: *const c_void, uniformType: i32); }
extern fn void set_shader_value_texture(Shader shader, int locIndex, void* value, int uniformType) @extern("SetShaderValueTexture");
extern fn void unload_shader(Shader shader) @extern("UnloadShader");


//= Textures
/// Texture loading functions
extern fn Texture load_texture(char* filename) @extern("LoadTexture");
extern fn bool is_texture_ready(Texture texture) @extern("IsTextureReady");
extern fn void unload_texture(Texture texture) @extern("UnloadTexture");
extern fn void update_texture(Texture texture, void* pixels) @extern("UpdateTexture");
extern fn void update_texture_rec(Texture texture, Rectangle rec, void* pixels) @extern("UpdateTextureRec");
extern fn RenderTexture load_render_texture(int width, int height) @extern("LoadRenderTexture");
extern fn bool is_render_texture_ready(RenderTexture target) @extern("IsRenderTextureReady");
extern fn void unload_render_texture(RenderTexture target) @extern("UnloadRenderTexture");

/// Texture configuration functions
extern fn void gen_texture_mipmaps(Texture* texture) @extern("GenTextureMipmaps");
extern fn void set_texture_filter(Texture texture, int filter) @extern("SetTextureFilter");
extern fn void set_texture_wrap(Texture texture, int wrap) @extern("SetTextureWrap");

/// Texture drawing functions
extern fn void draw_texture(Texture texture, int pos_x, int pos_y, Color tint) @extern("DrawTexture");
extern fn void draw_texture_v(Texture texture, Vector2 position, Color tint) @extern("DrawTextureV");
extern fn void draw_texture_ex(Texture texture, Vector2 position, float rotation, float scale, Color tint) @extern("DrawTextureEx");
extern fn void draw_texture_rec(Texture texture, Rectangle source, Vector2 position, Color tint) @extern("DrawTextureRec");
extern fn void draw_texture_pro(Texture texture, Rectangle source, Rectangle dest, Vector2 origin, float rotation, Color tint) @extern("DrawTexturePro");
extern fn void draw_texture_npatch(Texture texture, NPatchInfo npatch_info, Rectangle dest, Vector2 origin, float rotation, Color tint) @extern("DrawTextureNPatch");

/// Drawing-related functions
extern fn void begin_texture_mode(RenderTexture target) @extern("BeginTextureMode");
extern fn void end_texture_mode() @extern("EndTextureMode");

// TODO find out where this func was
extern fn PixelFormat get_pixel_data_size(int width, int height, PixelFormat format) @extern("GetPixelDataSize");
