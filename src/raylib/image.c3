
module pleroma::raylib;


<* Image *>
struct Image {
	void* data;
	int width;
	int height;
	int mipmaps;
	PixelFormat format;
}
extern fn Texture Image.texture(self) @extern("LoadTextureFromImage");
extern fn void Image.unload(self) @extern("UnloadImage");
extern fn char* Image.to_mem_ptr(self, String, int*) @extern("ExportImageToMemory"); 
extern fn Image Image.copy_rec(self, Rectangle) @extern("ImageFromImage");
extern fn void unload_image_palette(Color* colors) @extern("UnloadImagePalette");
extern fn Color* load_image_palette(Image image, int maxPaletteSize, int* colorCount) @extern("LoadImagePalette");
extern fn Image load_image_from_memory(char* fileType, char* fileData, int dataSize) @extern("LoadImageFromMemory");

<* Save image to memory *>
fn char[] Image.to_mem(self, String filetype) @export("image_tomem") {
	int length = 0;
	char* result_ptr = self.to_mem_ptr(filetype, &length);
	char[] result = mem::new_array(char, length);
	for (int i = 0; i < length; i++) { result[i] = result_ptr[i]; }
	return result;
}
<* Load palette from image as an array of colors
  @param max "The max size of the palette"
 *>
fn Color[] Image.palette(self, int max) @export("image_palette") {
	int count = 0;
	Color* res_ptr = raylib::load_image_palette(self, max, &count);
	Color[] result = mem::new_array(Color, count);
	for (int i = 0; i < count; i++) result[i] = res_ptr[i];
	raylib::unload_image_palette(res_ptr);
	return result;
}
<* Cut the Image into seperate textures
  @param count_x "Number of horizontal sprites"
  @param count_y "Number of vertical sprites"
 *>
fn Texture[] Image.cut_sheet(self, int count_x, int count_y) @export("image_cutsheet") {
	int total = count_x * count_y;
	int width = self.width / count_x;
	int height = self.height / count_y;

	Texture[] output = allocator::alloc_array(allocator::heap(), Texture, total);
	for (int i = 0; i < total; i++) {
		Image img = self.copy_rec({(float)(i%count_x) * width, (float)(i/count_x) * height, width, height});
		output[i] = img.texture();
		img.unload();
	}

	return output;
}


module pleroma::raylib::image;
import std::io::file;

<* Loads image from memory
  @param filetype "Filetype as a string"
  @param data "Data as an array"
 *>
fn Image load_mem(String filetype, char[] data) @export("image_loadarr") {
	return raylib::load_image_from_memory(filetype, (char*)data, data.len);
}


