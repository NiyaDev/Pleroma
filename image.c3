module pleroma;


struct Image {
	void* data;
	int width;
	int height;
	int mipmaps;
	PixelFormat format;
}


/// Wrapper for Raylib::IsImageReady()
fn bool Image.ready(&self) {
	return is_image_ready(*self);
}
/// Wrapper for Raylib::UnloadImage()
fn void Image.unload(&self) {
	unload_image(*self);
}


/// Image loading functions
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

/// Image generation functions
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

/// Image drawing functions
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

/// Texture loading functions
extern fn Texture load_texture_from_image(Image image) @extern("LoadTextureFromImage");
extern fn Texture load_texture_cubemap(Image image, int layout) @extern("LoadTextureCubemap");
