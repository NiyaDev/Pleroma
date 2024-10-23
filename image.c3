
module pleroma;

import std::core::mem;
import raylib;


/**
 * Image
 **/
struct Image {
	void* data;
	int width;
	int height;
	int mipmaps;
	PixelFormat format;
}
/**
 * Image faults
 **/
fault ImageFault {
	FAILED_FIND_FILE,
	FAILED_GENERATE_IMAGE,
}
/**
 * Checks whether the Image  is ready for use
 * @return "Image is ready to use"
 **/
fn bool Image.ready(&self) {
	return raylib::is_image_ready(*self);
}
/**
 * Unloads Image from memory
 **/
fn void Image.unload(&self) {
	raylib::unload_image(*self);
	free(self);
}
/**
 * Save image to file
 * @param filename "Name of file to save"
 * @return "Success"
 **/
fn bool Image.save(&self, String filename) {
	return raylib::export_image(*self, filename);
}
/**
 * Save image to memory
 * @param filetype "Filetype as a string"
 * @return "Array of bytes"
 **/
fn char[] Image.to_mem(&self, String filetype) {
	int length = 0;
	char* result_ptr = raylib::export_image_to_memory(*self, filetype, &length);
	char[] result = mem::new_array(char, length);
	for (int i = 0; i < length; i++) { result[i] = result_ptr[i]; }
	return result;
}
/**
 * Save image to memory
 * @param filetype "Filetype as a string"
 * @return "Array of bytes"
 **/
fn char* Image.to_mem_ptr(&self, String filetype, int* length) {
	char* result_ptr = raylib::export_image_to_memory(*self, filetype, length);
	return result_ptr;
}
/**
 * Exports Image to GPU as texture
 * @return "Pointer to exported texture info"
 **/
fn Texture* Image.texture(&self) {
	Texture* result = malloc(Texture.sizeof);
	*result = raylib::load_texture_from_image(*self);
	return result;
}
/**
 * Creates a copy of image
 * @return "Pointer to duplicate of image"
 **/
fn Image* Image.copy(&self) {
	Image* result = malloc(Image.sizeof);
	*result = raylib::image_copy(*self);
	return result;
}
/**
 * Copies a subsection of image
 * @require rec.width <= self.width, rec.height <= self.height, "Rect Width or Height is larger than image"
 * @return "Pointer to duplicate of image"
 **/
fn Image* Image.copy_section(&self, Rectangle rec) {
	Image* result = malloc(Image.sizeof);
	*result = raylib::image_from_image(*self, rec);
	return result;
}

/**
 * Sets the window icon to image
 * @return "self for later use"
 **/
fn Image* Image.set_icon(&self) {
	raylib::set_window_icon(*self);
	return self;
}
/**
 * Sets the window icon to an array of images
 * @return "self for later use"
 **/
fn Image[]* Image[].set_icons(&self) {
	raylib::set_window_icons((Image*)*self, self.len);
	return self;
}
/**
 * Convert image format
 * @param newformat "New pixel format"
 * @return "Self"
 **/
fn Image* Image.format(&self, PixelFormat newformat) {
	raylib::image_format(self, (int)newformat);
	return self;
}
/**
 * Convert image to power-of-two
 * @param fill "Color to fill"
 * @return "self"
 **/
fn Image* Image.power_of_two(&self, Color fill) {
	raylib::image_to_pot(self, fill);
	return self;
}
/**
 * Crop image
 * @param crop "Area to crop image to"
 * @require crop.width <= self.width, crop.height <= self.height, "Crop width or height exceeds image"
 * @require crop.x <= self.width, crop.x >= 0, crop.y <= self.height, crop.y >= 0, "Crop x or y not within image range"
 * @return "Self"
 **/
fn Image* Image.crop(&self, Rectangle crop) {
	raylib::image_crop(self, crop);
	return self;
}
/**
 * Crop image based on an alpha value
 * @param threshold "Value to crop based on"
 * @require threshold >= 0, threshold <= 1, "Threshold not within range"
 * @return "Self"
 **/
fn Image* Image.alpha_crop(&self, float threshold) {
	raylib::image_alpha_crop(self, threshold);
	return self;
} 
/**
 * Clear alpha to a specific color
 * @param color "Color to set"
 * @param threshold "Maximum value to change"
 * @require threshold >= 0, threshold <= 1, "Threshold not within range"
 * @return "Self"
 **/
fn Image* Image.clear_alpha(&self, Color color, float threshold) {
	raylib::image_alpha_clear(self, color, threshold);
	return self;
}
/**
 * Apply alpha mask to image
 * @param alphamask "Mask to apply"
 * @require alphamask.data != null, "Alpha mask not valid"
 * @return "Self"
 **/
fn Image* Image.mask(&self, Image alphamask) {
	raylib::image_alpha_mask(self, alphamask);
	return self;
}
/**
 * Premultiply alpha channel
 * @return "Self"
 **/
fn Image* Image.premultiply_alpha(&self) {
	raylib::image_alpha_premultiply(self);
	return self;
}
/**
 * Apply gaussian blur to image
 * @param blursize "Size of the blur"
 * @return "Self"
 **/
fn Image* Image.gauss(&self, int blursize) {
	raylib::image_blur_gaussian(self, blursize);
	return self;
}
/**
 * Bicubic resize of image
 * @param width "New width of image"
 * @param height "New height of image"
 * @require width > 0, height > 0, "Width or height is zero or less"
 * @return "Self"
 **/
fn Image* Image.resize(&self, int width, int height) {
	raylib::image_resize(self, width, height);
	return self;
}
/**
 * Nearest-Neighbor resize of image
 * @param width "New width of image"
 * @param height "New height of image"
 * @require width > 0, height > 0, "Width or height is zero or less"
 * @return "Self"
 **/
fn Image* Image.resize_nn(&self, int width, int height) {
	raylib::image_resize_nn(self, width, height);
	return self;
}
/**
 * Resize canvas and fill with color
 * @param width "New width of image"
 * @param height "New height of image"
 * @require width > 0, height > 0, "Width or height is zero or less"
 * @param x_offset "X position of the original image in new canvas"
 * @param y_offset "Y position of the original image in new canvas"
 * @require x_offset > width, y_offset > height, "The x or y offset is out of bounds"
 * @param fill "Color to fill in the new canvas area"
 * @return "Self"
 **/
fn Image* Image.resize_canvas(&self, int width, int height, int x_offset, int y_offset, Color fill) {
	raylib::image_resize_canvas(self, width, height, x_offset, y_offset, fill);
	return self;
}
/**
 * Compute all mipmap levels
 * @return "Self"
 **/
fn Image* Image.mipmaps(&self) {
	raylib::image_mipmaps(self);
	return self;
}
/**
 * Dither image
 * @param rbpp "Red bpp"
 * @param gbpp "Green bpp"
 * @param bbpp "Blue bpp"
 * @param abpp "Alpha bpp"
 * @return "Self"
 **/
fn Image* Image.dither(&self, int rbpp, int gbpp, int bbpp, int abpp) {
	raylib::image_dither(self, rbpp, gbpp, bbpp, abpp);
	return self;
}
/**
 * Flip around the X axis
 * @return "Self"
 **/
fn Image* Image.vflip(&self) {
	raylib::image_flip_vertical(self);
	return self;
}
/**
 * Flip around the Y axis
 * @return "Self"
 **/
fn Image* Image.hflip(&self) {
	raylib::image_flip_horizontal(self);
	return self;
}
/**
 * Rotate by angle
 * @param degrees "Amount to rotate"
 * @return "Self"
 **/
fn Image* Image.rotate(&self, int degrees) {
	raylib::image_rotate(self, degrees);
	return self;
}
/**
 * Rotate 90 degrees clockwise
 * @return "Self"
 **/
fn Image* Image.rotate_cw(&self) {
	raylib::image_rotate_cw(self);
	return self;
}
/**
 * Rotate 90 degrees counter-clockwise
 * @return "Self"
 **/
fn Image* Image.rotate_ccw(&self) {
	raylib::image_rotate_ccw(self);
	return self;
}
/**
 * Tint image
 * @param color "Color to tint"
 * @return "Self"
 **/
fn Image* Image.tint(&self, Color color) {
	raylib::image_color_tint(self, color);
	return self;
}
/**
 * Invert colors in image
 * @return "Self"
 **/
fn Image* Image.invert(&self) {
	raylib::image_color_invert(self);
	return self;
}
/**
 * Grayscale image
 * @return "Self"
 **/
fn Image* Image.grayscale(&self) {
	raylib::image_color_grayscale(self);
	return self;
}
/**
 * Apply contrast
 * @param contrast "Contrast to apply"
 * @require contrast >= 0, contrast <= 1, "Contrast out of proper range"
 * @return "Self"
 **/
fn Image* Image.contrast(&self, float contrast) {
	raylib::image_color_contrast(self, contrast);
	return self;
}
/**
 * Apply brightness to image
 * @param brightness "Brightness to apply"
 * @return "Self"
 **/
fn Image* Image.brightness(&self, int brightness) {
	raylib::image_color_brightness(self, brightness);
	return self;
}
/**
 * Replace color in image with another
 * @param color "Color to use"
 * @param replace "Color to replace"
 * @return "Self"
 **/
fn Image* Image.replace(&self, Color color, Color replace) {
	raylib::image_color_replace(self, color, replace);
	return self;
}
/**
 * Load palette from image as an array of colors
 * @param max "The max size of the palette"
 * @return "Array of colors from image"
 **/
fn Color[] Image.palette(&self, int max) {
	int count = 0;
	Color* res_ptr = raylib::load_image_palette(*self, max, &count);
	Color[] result = mem::new_array(Color, count);
	for (int i = 0; i < count; i++) result[i] = res_ptr[i];
	return result;
}
/**
 * Unload platte data
 **/
fn void Color[].unload(&self) {
	raylib::unload_image_palette((Color*)self);
}
/**
 * Get alpha border rectangle
 * @param threshold "Max alpha"
 * @require threshold >= 0, threshold <= 1, "Threshold is not in proper range"
 * @return "Self"
 **/
fn Image* Image.get_alpha_border(&self, float threshold) {
	raylib::get_image_alpha_border(*self, threshold);
	return self;
}
/**
 * Get color at point
 * @param x "X position"
 * @param y "Y position"
 * @require x >= 0, x <= self.width, y >= 0, y <= self.height, "X or Y position are out of proper range"
 * @return "Self"
 **/
fn Color Image.color(&self, int x, int y) {
	return raylib::get_image_color(self, x, y);
}
/**
 * Clears the images background
 * @param color "Color to set"
 * @return "Self"
 **/
fn Image* Image.clear_bg(&self, Color color) {
	raylib::image_clear_background(self, color);
	return self;
}
/**
 * Draw pixel into image
 * @param position "Position as a vector"
 * @require position.x >= 0, position.x <= self.width, position.y >= 0, position.y <= self.height, "X or Y position not in proper range"
 * @param color "Color of pixel"
 * @return "Self"
 **/
fn Image* Image.draw_pixel(&self, Vector2 position, Color color) {
	raylib::image_draw_pixel_v(self, position, color);
	return self;
}
/**
 * Draw a line onto image
 * @param start "Starting point of line"
 * @param end "Ending point of line"
 * @param color "Color of line"
 * @return "Self"
 **/
fn Image* Image.draw_line(&self, Vector2 start, Vector2 end, Color color) {
	raylib::image_draw_line_v(self, start, end, color);
	return self;
}
/**
 * Draw a circle onto image
 * @param center "Center of the circle"
 * @param radius "Radius of the circle"
 * @param color "Color to draw"
 * @return "Self"
 **/
fn Image* Image.draw_circle(&self, Vector2 center, int radius, Color color) {
	raylib::image_draw_circle_v(self, center, radius, color);
	return self;
}
/**
 * Draw a circle made of just lines onto image
 * @param center "Center of the circle"
 * @param radius "Radius of the circle"
 * @param color "Color to draw"
 * @return "Self"
 **/
fn Image* Image.draw_circle_lines(&self, Vector2 center, int radius, Color color) {
	raylib::image_draw_circle_lines_v(self, center, radius, color);
	return self;
}
/**
 * Draw rectangle onto image
 * @param rect "Where to draw the rectangle"
 * @param color "Color of rectangle"
 * @return "Self"
 **/
fn Image* Image.draw_rectangle(&self, Rectangle rect, Color color) {
	raylib::image_draw_rectangle_rec(self, rect, color);
	return self;
}
/**
 * Draw rectangle made of lines onto image
 * @param rect "Where to draw the rectangle"
 * @param thick "Thickness of lines"
 * @param color "Color of rectangle"
 * @return "Self"
 **/
fn Image* Image.draw_rectangle_rec(&self, Rectangle rect, int thick, Color color) {
	raylib::image_draw_rectangle_lines(self, rect, thick, color);
	return self;
}
/**
 * Draw image into image
 * @param src "Image to copy into main image"
 * @param srcrec "Section of src to copy"
 * @param dstrec "Section of main image to copy into"
 * @param tint "Color of image"
 * @return "Self"
 **/
fn Image* Image.draw_image(&self, Image src, Rectangle srcrec, Rectangle dstrec, Color tint = Color.WHITE) {
	raylib::image_draw(self, src, srcrec, dstrec, tint);
	return self;
}
/**
 * Draw text in default font ontop image
 * @param text "String to draw"
 * @param x "X position"
 * @param y "Y position"
 * @param fontsize "Size of font to be drawn"
 * @param color "Color of font to be drawn"
 * @return "Self"
 **/
fn Image* Image.draw_text(&self, String text, int x, int y, int fontsize, Color color) {
	raylib::image_draw_text(self, text, x, y, fontsize, color);
	return self;
}
/**
 * Draw text in default font ontop image
 * @param font "Font to draw"
 * @param text "String to draw"
 * @param position "Position as Vector2"
 * @param fontsize "Size of font to be drawn"
 * @param spacing "Spacing between characters"
 * @param tint "Color of font to be drawn"
 * @return "Self"
 **/
fn Image* Image.draw_text_ex(&self, Font font, String text, Vector2 position, float fontsize, float spacing, Color tint) {
	raylib::image_draw_text_ex(self, font, text, position, fontsize, spacing, tint);
	return self;
}



module pleroma::image;

import std::io::file;
import raylib;
import pleroma::debug;

/**
 * Loads image from file.
 * Unneeded due to bulk loading, but exists jic.
 * @param filename "Name of file to load"
 * @return "Pointer to loaded Image"
 **/
fn Image*! load(String filename) {
	Image* result = malloc(Image.sizeof);
	
	if (file::is_file(filename)) {
		*result = raylib::load_image(filename);
		return result;
	} else {
		debug::log("Failed to load Image", NONE, filename);
		return ImageFault.FAILED_FIND_FILE?;
	}
}
/**
 * Loads image from raw file.
 * Unneeded due to bulk loading, but exists jic.
 * @param filename "Name of file to load"
 * @param width "Width of image"
 * @param height "Height of image"
 * @require width > 0, height > 0, "Width or Height value is invalid"
 * @param format "Pixel format"
 * @param headersize "Size of image header in file"
 * @return "Pointer to loaded Image"
 **/
fn Image*! load_raw(String filename, int width, int height, PixelFormat format, int headersize) {
	Image* result = malloc(Image.sizeof);
	
	if (file::is_file(filename)) {
		*result = raylib::load_image_raw(filename, width, height, format, headersize);
		return result;
	} else {
		debug::log("Failed to load Image", NONE, filename);
		return ImageFault.FAILED_FIND_FILE?;
	}
}
/**
 * Loads image from .svg
 * Unneeded due to bulk loading, but exists jic.
 * @param filename "Name of file to load"
 * @param width "Width of image"
 * @param height "Height of image"
 * @require width > 0, height > 0, "Width of Height value is invalid"
 * @return "Pointer to loaded image"
 **/
fn Image*! load_svg(String filename, int width, int height) {
	Image* result = malloc(Image.sizeof);
	
	if (file::is_file(filename)) {
		*result = raylib::load_image_svg(filename, width, height);
		return result;
	} else {
		debug::log("Failed to load Image", NONE, filename);
		return ImageFault.FAILED_FIND_FILE?;
	}
}
/**
 * Loads image from anim
 * Unneeded due to bulk loading, bust exists jic.
 * @param filename "Name of file to load"
 * @param [&out] frames "Pointer to number of frames"
 * @return "Pointer to loaded image"
 **/
fn Image*! load_anim(String filename, int* frames) {
	Image* result = malloc(Image.sizeof);
	
	if (file::is_file(filename)) {
		*result = raylib::load_image_anim(filename, frames);
		return result;
	} else {
		debug::log("Failed to load Image", NONE, filename);
		return ImageFault.FAILED_FIND_FILE?;
	}
}
/**
 * Loads image from memory
 * @param filetype "Filetype as a string"
 * @param data "Data as an array"
 * @return "Pointer to loaded image"
 **/
fn Image* load_mem(String filetype, char[] data) {
	Image* result = malloc(Image.sizeof);
	*result = raylib::load_image_from_memory(filetype, (char*)data, data.len);
	return result;
}
/**
 * Loads image from memory
 * @param filetype "Filetype as a string"
 * @param data "Data as a pointer"
 * @param length "Length of data"
 * @return "Pointer to loaded image"
 **/
fn Image* load_mem_ptr(String filetype, char* data, usz length) {
	Image* result = malloc(Image.sizeof);
	*result = raylib::load_image_from_memory(filetype, data, (int)length);
	return result;
}
/**
 * Loads image from texture
 * @return "Pointer to loaded image"
 **/
fn Image* Texture.to_image(&self) {
	Image* result = malloc(Image.sizeof);
	*result = raylib::load_image_from_texture(*self);
	return result;
}
/**
 * Loads image from screen
 * @return "Pointer to loaded image"
 **/
fn Image* load_screen() {
	Image* result = malloc(Image.sizeof);
	*result = raylib::load_image_from_screen();
	return result;
}

/**
 * Generate an image made of a single color
 * @param width "Width of generated image"
 * @param height "Height of generated image"
 * @require width > 0, height > 0, "Width or Height is invalid"
 * @param color "Color of generated image"
 * @return "Pointer to loaded image"
 **/
fn Image*! gen_color(int width, int height, Color color) {
	Image* result = malloc(Image.sizeof);
	*result = raylib::gen_image_color(width, height, color);
	
	if (result.data != null) { return result; }
	else {
		debug::log("Failed to generate Image", NONE, $$FUNC);
		return ImageFault.FAILED_GENERATE_IMAGE?;
	}
}
/**
 * Generate an image made of a two color gradient
 * @param width "Width of generated image"
 * @param height "Height of generated image"
 * @require width > 0, height > 0, "Width or Height is invalid"
 * @param direction "Direction the gradient should go"
 * @param start "Color of gradient start"
 * @param end "Color of gradient end"
 * @return "Pointer to loaded image"
 **/
fn Image*! gen_linear_gradient(int width, int height, int direction, Color start, Color end) {
	Image* result = malloc(Image.sizeof);
	*result = raylib::gen_image_gradient_linear(width, height, direction, start, end);
	
	if (result.data != null) { return result; }
	else {
		debug::log("Failed to generate Image", NONE, $$FUNC);
		return ImageFault.FAILED_GENERATE_IMAGE?;
	}
}
/**
 * Generate an image made of a two color gradient
 * @param width "Width of generated image"
 * @param height "Height of generated image"
 * @require width > 0, height > 0, "Width or Height is invalid"
 * @param density "Density"
 * @param inner "Color of gradient center"
 * @param outer "Color of gradient outer"
 * @return "Pointer to loaded image"
 **/
fn Image*! gen_radial_gradient(int width, int height, float density, Color inner, Color outer) {
	Image* result = malloc(Image.sizeof);
	*result = raylib::gen_image_gradient_radial(width, height, density, inner, outer);
	
	if (result.data != null) { return result; }
	else {
		debug::log("Failed to generate Image", NONE, $$FUNC);
		return ImageFault.FAILED_GENERATE_IMAGE?;
	}
}
/**
 * Generate an image made of a two color gradient
 * @param width "Width of generated image"
 * @param height "Height of generated image"
 * @require width > 0, height > 0, "Width or Height is invalid"
 * @param density "Density"
 * @param inner "Color of gradient center"
 * @param outer "Color of gradient outer"
 * @return "Pointer to loaded image"
 **/
fn Image*! gen_square_gradient(int width, int height, float density, Color inner, Color outer) {
	Image* result = malloc(Image.sizeof);
	*result = raylib::gen_image_gradient_square(width, height, density, inner, outer);
	
	if (result.data != null) { return result; }
	else {
		debug::log("Failed to generate Image", NONE, $$FUNC);
		return ImageFault.FAILED_GENERATE_IMAGE?;
	}
}
/**
 * Generate an image made of a two color gradient
 * @param width "Width of generated image"
 * @param height "Height of generated image"
 * @param checksx "Number of x checks"
 * @param checksy "Number of y checks"
 * @require width > 0, height > 0, checksx > 0, checksy > 0, "Width or Height is invalid"
 * @param col1 "Checker color one"
 * @param col2 "Checker color two"
 * @return "Pointer to loaded image"
 **/
fn Image*! gen_checker(int width, int height, int checksx, int checksy, Color col1, Color col2) {
	Image* result = malloc(Image.sizeof);
	*result = raylib::gen_image_checked(width, height, checksx, checksy, col1, col2);
	
	if (result.data != null) { return result; }
	else {
		debug::log("Failed to generate Image", NONE, $$FUNC);
		return ImageFault.FAILED_GENERATE_IMAGE?;
	}
}
/**
 * Generate an image made of a two color gradient
 * @param width "Width of generated image"
 * @param height "Height of generated image"
 * @require width > 0, height > 0, "Width or Height is invalid"
 * @param factor "Factor"
 * @return "Pointer to loaded image"
 **/
fn Image*! gen_white_noise(int width, int height, float factor) {
	Image* result = malloc(Image.sizeof);
	*result = raylib::gen_image_white_noise(width, height, factor);
	
	if (result.data != null) { return result; }
	else {
		debug::log("Failed to generate Image", NONE, $$FUNC);
		return ImageFault.FAILED_GENERATE_IMAGE?;
	}
}
/**
 * Generate an image made of a two color gradient
 * @param width "Width of generated image"
 * @param height "Height of generated image"
 * @param offsetx "offsetx of generated image"
 * @param offsety "offsety of generated image"
 * @require width > 0, height > 0, offsetx > 0, offsety > 0, "Width or Height is invalid"
 * @param scale "Scale"
 * @return "Pointer to loaded image"
 **/
fn Image*! gen_perlin_noise(int width, int height, int offsetx, int offsety, float scale) {
	Image* result = malloc(Image.sizeof);
	*result = raylib::gen_image_perlin_noise(width, height, offsetx, offsety, scale);
	
	if (result.data != null) { return result; }
	else {
		debug::log("Failed to generate Image", NONE, $$FUNC);
		return ImageFault.FAILED_GENERATE_IMAGE?;
	}
}
/**
 * Generate an image made of a two color gradient
 * @param width "Width of generated image"
 * @param height "Height of generated image"
 * @require width > 0, height > 0, "Width or Height is invalid"
 * @param tilesize "Tile size"
 * @return "Pointer to loaded image"
 **/
fn Image*! gen_cellular(int width, int height, int tilesize) {
	Image* result = malloc(Image.sizeof);
	*result = raylib::gen_image_cellular(width, height, tilesize);
	
	if (result.data != null) { return result; }
	else {
		debug::log("Failed to generate Image", NONE, $$FUNC);
		return ImageFault.FAILED_GENERATE_IMAGE?;
	}
}

/**
 * Create an image from a string of text
 * @param text "Text to create an image of"
 * @param fontsize "Size of text font"
 * @param color "Color of text"
 * @return "Pointer to generated image"
 **/
fn Image*! text(String text, int fontsize, Color color) {
	Image* result = malloc(Image.sizeof);
	*result = raylib::image_text(text, fontsize, color);
	
	if (result.data != null) { return result; }
	else {
		debug::log("Failed to generate Image", NONE, $$FUNC);
		return ImageFault.FAILED_GENERATE_IMAGE?;
	}
}
/**
 * Create an image from a font and a string of text
 * @param font "Font to draw"
 * @param text "Text to draw"
 * @param fontsize "Size of font"
 * @param spacing "spacing between characters"
 * @param tint "Color of text"
 * @return "Pointer to generated image"
 **/
fn Image*! text_ex(Font font, String text, float fontsize, float spacing, Color tint) {
	Image* result = malloc(Image.sizeof);
	*result = raylib::image_text_ex(font, text, fontsize, spacing, tint);
	
	if (result.data != null) { return result; }
	else {
		debug::log("Failed to generate Image", NONE, $$FUNC);
		return ImageFault.FAILED_GENERATE_IMAGE?;
	}
}
