module pleroma;


import raylib;
import std::core::mem;


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
 * Exports Image to GPU as texture
 * @return "Exported texture info"
 **/
fn Texture Image.texture(&self) {
	return raylib::load_texture_from_image(*self);
}


module pleroma::image;

import raylib;

/**
 * Loads image from file.
 * Unneeded due to bulk loading, but exists jic.
 * @param filename "Name of file to load"
 * @return "Pointer to loaded Image"
 **/
fn Image* load(String filename) {
	Image* result = malloc(Image.sizeof);
	*result = raylib::load_image(filename);
	return result;
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
fn Image* load_raw(String filename, int width, int height, PixelFormat format, int headersize) {
	Image* result = malloc(Image.sizeof);
	*result = raylib::load_image_raw(filename, width, height, format, headersize);
	return result;
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
fn Image* load_svg(String filename, int width, int height) {
	Image* result = malloc(Image.sizeof);
	*result = raylib::load_image_svg(filename, width, height);
	return result;
}
/**
 * Loads image from anim
 * Unneeded due to bulk loading, bust exists jic.
 * @param filename "Name of file to load"
 * @param [&out] frames "Pointer to number of frames"
 * @return "Pointer to loaded image"
 **/
fn Image* load_anim(String filename, int* frames) {
	Image* result = malloc(Image.sizeof);
	*result = raylib::load_image_anim(filename, frames);
	return result;
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
fn Image* gen_color(int width, int height, Color color) {
	Image* result = malloc(Image.sizeof);
	*result = raylib::gen_image_color(width, height, color);
	return result;
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
fn Image* gen_linear_gradient(int width, int height, int direction, Color start, Color end) {
	Image* result = malloc(Image.sizeof);
	*result = raylib::gen_image_gradient_linear(width, height, direction, start, end);
	return result;
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
fn Image* gen_radial_gradient(int width, int height, float density, Color inner, Color outer) {
	Image* result = malloc(Image.sizeof);
	*result = raylib::gen_image_gradient_radial(width, height, density, inner, outer);
	return result;
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
fn Image* gen_square_gradient(int width, int height, float density, Color inner, Color outer) {
	Image* result = malloc(Image.sizeof);
	*result = raylib::gen_image_gradient_square(width, height, density, inner, outer);
	return result;
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
fn Image* gen_checker(int width, int height, int checksx, int checksy, Color col1, Color col2) {
	Image* result = malloc(Image.sizeof);
	*result = raylib::gen_image_checked(width, height, checksx, checksy, col1, col2);
	return result;
}
/**
 * Generate an image made of a two color gradient
 * @param width "Width of generated image"
 * @param height "Height of generated image"
 * @require width > 0, height > 0, "Width or Height is invalid"
 * @param factor "Factor"
 * @return "Pointer to loaded image"
 **/
fn Image* gen_white_noise(int width, int height, float factor) {
	Image* result = malloc(Image.sizeof);
	*result = raylib::gen_image_white_noise(width, height, factor);
	return result;
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
fn Image* gen_perlin_noise(int width, int height, int offsetx, int offsety, float scale) {
	Image* result = malloc(Image.sizeof);
	*result = raylib::gen_image_perlin_noise(width, height, offsetx, offsety, scale);
	return result;
}
/**
 * Generate an image made of a two color gradient
 * @param width "Width of generated image"
 * @param height "Height of generated image"
 * @require width > 0, height > 0, "Width or Height is invalid"
 * @param tilesize "Tile size"
 * @return "Pointer to loaded image"
 **/
fn Image* gen_cellular(int width, int height, float tilesize) {
	Image* result = malloc(Image.sizeof);
	*result = raylib::gen_image_cellular(width, height, tilesize);
	return result;
}
