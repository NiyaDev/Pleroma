#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#ifndef __c3__
#define __c3__

typedef void* c3typeid_t;
typedef void* c3fault_t;
typedef struct { void* ptr; size_t len; } c3slice_t;
typedef struct { void* ptr; c3typeid_t type; } c3any_t;

#endif

/* TYPES */
typedef struct pleroma_raylib__Image__ pleroma_raylib__Image;
typedef enum pleroma_raylib__PixelFormat__
{
	 pleroma_raylib__PixelFormat_GRAYSCALE,
	 pleroma_raylib__PixelFormat_GRAYALPHA,
	 pleroma_raylib__PixelFormat_R5G6B5,
	 pleroma_raylib__PixelFormat_R8G8B8,
	 pleroma_raylib__PixelFormat_R5G5B5A1,
	 pleroma_raylib__PixelFormat_R4G4B4A4,
	 pleroma_raylib__PixelFormat_R8G8B8A8,
	 pleroma_raylib__PixelFormat_R32,
	 pleroma_raylib__PixelFormat_R32G32B32,
	 pleroma_raylib__PixelFormat_R32G32B32A32,
	 pleroma_raylib__PixelFormat_R16,
	 pleroma_raylib__PixelFormat_R16G16B16,
	 pleroma_raylib__PixelFormat_R16G16B16A16,
	 pleroma_raylib__PixelFormat_DXT1RGB,
	 pleroma_raylib__PixelFormat_DXT1RGBA,
	 pleroma_raylib__PixelFormat_DXT3RGBA,
	 pleroma_raylib__PixelFormat_DXT5RGBA,
	 pleroma_raylib__PixelFormat_ETC1RGB,
	 pleroma_raylib__PixelFormat_ETC2RGB,
	 pleroma_raylib__PixelFormat_ETC2EACRGBA,
	 pleroma_raylib__PixelFormat_PVRTRGB,
	 pleroma_raylib__PixelFormat_PVRTRGBA,
	 pleroma_raylib__PixelFormat_ASTC4X4RGBA,
	 pleroma_raylib__PixelFormat_ASTC8X8RGBA,
	 pleroma_raylib__PixelFormat_UNKNOWN,
} pleroma_raylib__PixelFormat;
struct pleroma_raylib__Image__
{
	void* data;
	int32_t width;
	int32_t height;
	int32_t mipmaps;
	pleroma_raylib__PixelFormat format;
};
typedef c3slice_t String;
typedef struct pleroma_raylib__Texture__ pleroma_raylib__Texture;
typedef struct pleroma_raylib__Color__ pleroma_raylib__Color;
struct pleroma_raylib__Color__
{
	uint8_t r;
	uint8_t g;
	uint8_t b;
	uint8_t a;
};
struct pleroma_raylib__Texture__
{
	uint32_t id;
	int32_t width;
	int32_t height;
	int32_t mipmaps;
	pleroma_raylib__PixelFormat format;
};

/* FUNCTIONS */
extern pleroma_raylib__Image image_load(c3slice_t filename);

/* METHODS */
extern void texture_draw(pleroma_raylib__Texture* self, int32_t pos_x, int32_t pos_y, pleroma_raylib__Color tint);
extern pleroma_raylib__Texture image.texture(pleroma_raylib__Image* self);
