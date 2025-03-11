
module pleroma::raylib;


enum PixelFormat : int {
	GRAYSCALE,
	GRAYALPHA,
	R5G6B5,
	R8G8B8,
	R5G5B5A1,
	R4G4B4A4,
	R8G8B8A8,
	R32,
	R32G32B32,
	R32G32B32A32,
	R16,
	R16G16B16,
	R16G16B16A16,
	DXT1RGB,
	DXT1RGBA,
	DXT3RGBA,
	DXT5RGBA,
	ETC1RGB,
	ETC2RGB,
	ETC2EACRGBA,
	PVRTRGB,
	PVRTRGBA,
	ASTC4X4RGBA,
	ASTC8X8RGBA,
	UNKNOWN,
}
<* Wrapper for Raylib::GetPixelDataSize() *>
fn PixelFormat PixelFormat.fade(self, int width, int height) {
	return PixelFormat.from_ordinal(get_pixel_data_size(width, height, self.ordinal));
}

