
module pleroma::raylib;
import std::io;


<* Texture stored in VRAM *>
struct Texture {
	uint id;
	int width, height, mipmaps;
	PixelFormat format;
}
<* Texture faults *>
fault TextureFault {
	FAILED_FIND_FILE,
}

<* Data to tile image *>
struct NPatchInfo {
	Rectangle source;
	int left;
	int top;
	int right;
	int bottom;
	NPatchLayout layout;
}

<* N-patch layout *>
enum NPatchLayout {
    NINE_PATCH,              // Npatch layout: 3x3 tiles
    THREE_PATCH_VERTICAL,    // Npatch layout: 1x3 tiles
    THREE_PATCH_HORIZONTAL   // Npatch layout: 3x1 tiles
}

<* Texture filter modes *>
enum TextureFilter {
	// No filter, just pixel approximation
	FILTER_POINT,
	// Linear filtering
	FILTER_BILINEAR,
	// Trilinear filtering (linear with mipmaps)
	FILTER_TRILINEAR,
	// Anisotropic filtering 4x
	FILTER_ANISOTROPIC_4X,
	// Anisotropic filtering 8x
	FILTER_ANISOTROPIC_8X,
	// Anisotropic filtering 16x
	FILTER_ANISOTROPIC_16X,
}
<* Texture wrapping modes *>
enum TextureWrap {
	// Repeats texture in tiled mode
	WRAP_REPEAT,
	// Clamps texture to edge pixel in tiled mode
    WRAP_CLAMP,
	// Mirrors and repeats the texture in tiled mode
    WRAP_MIRROR_REPEAT,
	// Mirrors and clamps to border the texture in tiled mode
    WRAP_MIRROR_CLAMP
}


<* Create NPatch for use *>
fn NPatchInfo Texture.npatch(self) @export("texture_npatch") {
	return {
		.source = {0, 0, self.width, self.height},
		.left = self.width / 3,
		.top = self.height / 3,
		.right = self.width / 3,
		.bottom = self.height / 3,
		.layout = NINE_PATCH,
	};
}
<* Prints information of texture *>
fn void Texture.print(self) @export("texture_print") {
	io::printfn(
		"%d - %dx%d - m:%d - f:%s",
		self.id,
		self.width, self.height,
		self.mipmaps,
		self.format,
	);
}


