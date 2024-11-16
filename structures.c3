
module pleroma;
import pleroma::camera;
import raylib;
import std::math;
import std::io;


const float EPSILON = 1.1920929E-7;


/** Bounding box for hitboxes and collisions
 **/
struct BoundingBox {
	Vector3 min, max;
}
/** Draws the bounding box
 @param color "Color to draw the bounds"
 **/
fn void BoundingBox.draw(&self, Color color) {
	raylib::draw_bounding_box(*self, color);
}



/** 2D Camera
 **/
struct Camera2D {
	Vector2 offset, target;
	float rotation, zoom;
}

/** 3D Camera
 **/
struct Camera3D {
	Vector3 position, target, up;
	float fovy;
	CameraProjection projection;
}

/** Camera Projection
 **/
enum CameraProjection : int {
	CAMERA_PERSPECTIVE,		// Perspective projection
	CAMERA_ORTHOGRAPHIC,	// Orthographic projection
}



/** Color
 **/
struct Color {
	char r, g, b, a;
}
/** Apply alpha to color
 @param alpha "Value to change alpha to"
 @require alpha <= 1, alpha >= 0, "Alpha not withing proper range of 0 -> 1"
 **/
fn void Color.fade(&self, float alpha) {
	self.a = (char)(255 * alpha);
}
/** Converts color to hexadecimal representation
 @return "Hex version of color"
 **/
fn uint Color.to_int(&self) {
	return self.r << 24 | self.g << 16 | self.b << 8 | self.a;
}
/** Converts color into Vector4 representation
 @return "Vector4 version of color with each value being a float between 0 and 1"
 **/
fn Vector4 Color.normalize(&self) {
	return {
		.x = (float)self.r / 255,
		.y = (float)self.g / 255,
		.z = (float)self.b / 255,
		.w = (float)self.a / 255,
	};
}
/** Converts color into HSV
 @return "Hue, Saturation, and Value version of color as a Vector3"
 **/
fn Vector3 Color.hsv(&self) {
	float r = (float)self.r / 255;
	float g = (float)self.g / 255;
	float b = (float)self.b / 255;
	float cmax = math::max(r, math::max(g, b));
	float cmin = math::min(r, math::min(g, b));
	float delta = cmax - cmin;

	float hue;
	if (delta == 0.0) { hue = 0; }
	else if (cmax == r) { hue = (60 * (((g - b) / delta) + 360)) % 360; }
	else if (cmax == g) { hue = (60 * (((b - r) / delta) + 120)) % 360; }
	else if (cmax == b) { hue = (60 * (((r - g) / delta) + 240)) % 360; }
	else { hue = -1; };

	float sat = (cmax == 0 ? 0 : delta / cmax);

	return {
		.x = hue,
		.y = sat,
		.z = cmax,
	};
}
/** Multiplies color by input
 @param tint "Color to tint"
 @return "Tinted color"
 **/
fn Color Color.tint(&self, Color tint) {
	Color result = *self;

	float cr = (float)tint.r / 255;
	float cg = (float)tint.g / 255;
	float cb = (float)tint.b / 255;
	float ca = (float)tint.a / 255;

	result.r = (char)(((float)self.r / 255 * cr) * 255);
	result.g = (char)(((float)self.g / 255 * cg) * 255);
	result.b = (char)(((float)self.b / 255 * cb) * 255);
	result.a = (char)(((float)self.a / 255 * ca) * 255);

	return result;
}
/** Corrects color for brightness
 @param factor "Percentage to increase brightness"
 @require factor <= 1, factor >= -1, "Brightness factor not within range"
 @return "Brightened / Darkened color"
 **/
fn Color Color.brightness(&self, float factor) {
	Color result = *self;

	float red	= (float)self.r;
	float green	= (float)self.g;
	float blue	= (float)self.b;

	if (factor < 0) {
		factor	 = 1 + factor;
		red		*= factor;
		green	*= factor;
		blue	*= factor;
	} else {
		red		= (255 - red)	* factor + red;
		green	= (255 - green)	* factor + green;
		blue	= (255 - blue)	* factor + blue;
	}

	result.r = (char)red;
	result.g = (char)green;
	result.b = (char)blue;

	return result;
}
/** Corrects color for contrast
 @param contrast "Percentage to change brightness"
 @require contrast <= 1, contrast >= -1, "Contrast not within proper range"
 @return "Color changed by contrast"
 **/
fn Color Color.contrast(&self, float contrast) {
	Color result = *self;

	contrast += 1;
	contrast *= contrast;

	float pr = (float)self.r / 255;
	pr -= 0.5;
	pr *= contrast;
	pr += 0.5;
	pr *= 255;
	if (pr < 0) { pr = 0; }
	else if (pr > 255) { pr = 255; }

	float pg = (float)self.g / 255;
	pg -= 0.5;
	pg *= contrast;
	pg += 0.5;
	pg *= 255;
	if (pg < 0) { pg = 0; }
	else if (pg > 255) { pg = 255; }

	float pb = (float)self.b / 255.0;
	pb -= 0.5;
	pb *= contrast;
	pb += 0.5;
	pb *= 255;
	if (pb < 0) { pb = 0; }
	else if (pb > 255) { pb = 255; }

	result.r = (char)pr;
	result.g = (char)pg;
	result.b = (char)pb;

	return result;
}
/** Get color with alpha applied
 @param alpha "Alpha to apply to color"
 @require alpha >= 0, alpha <= 1, "Alpha not within proper range"
 @return "Color with alpha applied"
 **/
fn Color Color.alpha(&self, float alpha) {
	Color result = *self;

	result.a = (char)(255 * alpha);

	return result;
}
/** Get src alpha-blended into dst color with tint
 @param src
 @param tint
 @return "Color with Alpha blend applied"
 **/
fn Color Color.alpha_blend(&self, Color src, Color tint) {
	return raylib::color_alpha_blend(*self, src, tint);
}



/** File path list
 **/
struct FilePathList {
	uint capacity, count;
	char** paths;
}


/** Materials
 **/
struct Material {
	Shader shader;
	MaterialMap* maps;
	float[4] params;
}
/** Material Maps
 **/
struct MaterialMap {
	Texture texture;
	Color color;
	float value;
}



/** Rectangle
 **/
struct Rectangle {
	float x, y, width, height;
}



/** Resolution
 **/
struct Resolution {
	int width, height;
}



/** Shader
 **/
struct Shader {
	uint id;
	int* locs;
}
/** Wrapper for Raylib::UnloadShader(shader: ShaderRl)
 **/
fn void Shader.unload(&self) {
	raylib::unload_shader(*self);
}
/** Wrapper for bool Raylib::IsShaderReady(shader: ShaderRl)
 **/
fn bool Shader.ready(&self) {
	return raylib::is_shader_ready(*self);
}
/** Wrapper for raylib::BeginShaderMode()
 **/
fn Shader* Shader.begin(&self) {
	raylib::begin_shader_mode(*self);

	return self;
}
/** Wrapper for raylib::EndShaderMode()
 **/
fn Shader* Shader.end(&self) {
	raylib::end_shader_mode();

	return self;
}



/** Pixel Format
 **/
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
/** Wrapper for Raylib::GetPixelDataSize().
 **/
fn PixelFormat PixelFormat.fade(&self, int width, int height) {
	return (PixelFormat)raylib::get_pixel_data_size(width, height, (int)*self);
}



/** Ray
 **/
struct Ray {
	Vector3 position, direction;
}
/** Ray Collision
 **/
struct RayCollision {
	bool hit;
	float distance;
	Vector3 point, normal;
}



/** Vector2
 **/
struct Vector2 {
	float x;
	float y;
}
/** Calculate vector length
 @return "Length of vector"
 **/
fn float Vector2.length(&self) {
	return math::sqrt(self.x.pow(2) + self.y.pow(2));
}
/** Calculate vector square length
 @return "Length of Vector squared"
 **/
fn float Vector2.length_sqr(&self) {
	return self.x.pow(2) + self.y.pow(2);
}
/** Calculate two vectors dot product
 @param v2 "Second vector"
 @return "Dot product of two vectors"
 **/
fn float Vector2.dot_product(&self, Vector2 v2) {
	return (self.x * v2.x) + (self.y * v2.y);
}
/** Calculate distance between two vectors
 @param v2 "Second vector"
 @return "Distance between two points in vector space"
 **/
fn float Vector2.distance(&self, Vector2 v2) {
	return math::sqrt((self.x - v2.x).pow(2) + (self.y - v2.y).pow(2));
}
/** Calculate square distance between two vectors
 @param v2 "Second vector"
 @return "Distance between two points in vector space squared"
 **/
fn float Vector2.distance_sr(&self, Vector2 v2) {
	return (self.x - v2.x).pow(2) + (self.y - v2.y).pow(2);
}
/** Calculate angle between two vectors
 **/
fn float Vector2.angle(&self, Vector2 v2) {
	float dot = self.dot_product(v2);
	float det = (self.x * v2.x) - (self.y * v2.y);

	return math::atan2(dot,det);
}
/** Calculate angle defined by a line made by two vectors
 **/
fn float Vector2.angle_line(&self, Vector2 end) {
	return -math::atan2(end.y - self.y,end.x - self.x);
}
/** Normalize provided vector
 **/
fn Vector2 Vector2.normalize(&self) {
	float length = self.length();

	if (length > 0.0) {
		float ilength = 1.0 / length;
		return {.x = self.x * ilength, .y = self.y * ilength};
	}

	return *self;
}
/** Transform a Vector2 by a given Matrix
 **/
fn Vector2 Vector2.transform(&self, Matrix mat) {
	float x = self.x;
	float y = self.y;
	float z = 0;

	return {
		.x = (mat.m0 * x) + (mat.m4 * y) + (mat.m8 * z) + mat.m12,
		.y = (mat.m1 * x) + (mat.m5 * y) + (mat.m9 * z) + mat.m13,
	};
}
/** Calculate linear interpolation between two vectors
 **/
fn Vector2 Vector2.lerp(&self, Vector2 v2, float amount) {
	return {
		.x = self.x + (amount * (v2.x - self.x)),
		.y = self.y + (amount * (v2.y - self.y)),
	};
}
/** Calculate reflected vector to normal
 **/
fn Vector2 Vector2.reflect(&self, Vector2 normal) {
	float dot = self.dot_product(normal);

	return {
		.x = self.x - (2 * normal.x) * dot,
		.y = self.y - (2 * normal.y) * dot,
	};
}
/** Rotate vecotr by angle
 **/
fn Vector2 Vector2.rotate(&self, float angle) {
	float cosres = math::cos(angle);
	float sinres = math::sin(angle);

	return {
		.x = (self.x * cosres) - (self.y * sinres),
		.y = (self.x * sinres) + (self.y * cosres),
	};
}
/** Move vector towards target
 **/
fn Vector2 Vector2.move_towards(&self, Vector2 target, float max_distance) {
	float dx = target.x - self.x;
	float dy = target.y - self.y;
	float value = dx.pow(2) + dy.pow(2);

	if (value == 0 || (max_distance >= 0 && value <= max_distance.pow(2))) { return target; }
	float dist = math::sqrt(value);

	return {
		.x = self.x + (dx / dist) * max_distance,
		.y = self.y + (dy / dist) * max_distance,
	};
}
/** Invert given vector
 **/
fn Vector2 Vector2.invert(&self) {
	return {
		.x = 1 / self.x,
		.y = 1 / self.y,
	};
}
/** Clamp the components of the vector between min and max values specified byt the given vectors.
 **/
fn Vector2 Vector2.clamp(&self, Vector2 min, Vector2 max) {
	return {
		.x = math::clamp(self.x, min.x, max.x),
		.y = math::clamp(self.y, min.y, max.y),
	};
}
/** Clamp the magnitude of the vector between two min ans max values
 @require min < max
 **/
fn Vector2 Vector2.clamp_mag(&self, float min, float max) {
	float length = self.length();

	if (length > 0) {
		length = math::sqrt(length);

		float scale = 1;
		if (length < min) {
			scale = min / length;
		} else if (length > max) {
			scale = max / length;
		}

		return {
			.x = self.x * scale,
			.y = self.y * scale,
		};
	}

	return {
		.x = self.x,
		.y = self.y,
	};
}


/** Vector3
 **/
struct Vector3 {
	float x;
	float y;
	float z;
}
/** Add two Vector3s returning the result
 **/
fn Vector3 Vector3.add(&self, Vector3 rhs) {
	return {
		.x = self.x + rhs.x,
		.y = self.y + rhs.y,
		.z = self.z + rhs.z,
	};
}
/** Subtract two Vector3s returning the result
 **/
fn Vector3 Vector3.sub(&self, Vector3 rhs) {
	return {
		.x = self.x - rhs.x,
		.y = self.y - rhs.y,
		.z = self.z - rhs.z,
	};
}
/** Multiply two Vector3s returning the result
 **/
fn Vector3 Vector3.mul(&self, Vector3 rhs) {
	return {
		.x = self.x * rhs.x,
		.y = self.y * rhs.y,
		.z = self.z * rhs.z,
	};
}
/** Divide two Vector3s returning the result
 **/
fn Vector3 Vector3.div(&self, Vector3 rhs) {
	return {
		.x = self.x / rhs.x,
		.y = self.y / rhs.y,
		.z = self.z / rhs.z,
	};
}
/** Calculate two vectors cross product
 **/
fn Vector3 Vector3.cross_product(&self, Vector3 v2) {
	return {
		.x = self.y * v2.z - self.z * v2.y,
		.y = self.z * v2.x - self.x * v2.z,
		.z = self.x * v2.y - self.y * v2.x,
	};
}
/** Calculate one vector perpendicular vector
 **/
fn Vector3 Vector3.perpendicular(&self) {
	float min = math::abs(self.x);
	Vector3 cardinal_axis = {.x = 1, .y = 0, .z = 0};

	if (math::abs(self.y) < min) {
		min = math::abs(self.y);
		cardinal_axis = {.x = 0, .y = 1, .z = 0};
	}
	if (math::abs(self.z) < min) {
		cardinal_axis = {.x = 0, .y = 1, .z = 0};
	}

	return self.cross_product(cardinal_axis);
}
/** Calculate vector length
 **/
fn float Vector3.length(&self) {
	return math::sqrt(self.x.pow(2) + self.y.pow(2) + self.z.pow(2));
}
/** Calculate vector square length
 **/
fn float Vector3.length_sqr(&self) {
	return self.x.pow(2) + self.y.pow(2) + self.z.pow(2);
}
/** Calculate two vectors dot product
 **/
fn float Vector3.dot_product(&self, Vector3 v2) {
	return self.x * v2.x + self.y * v2.y + self.z * v2.z;
}
/** Calculate distance between two vectors
 **/
fn float Vector3.distance(&self, Vector3 v2) {
	return Vector3{
		.x = v2.x - self.x,
		.y = v2.y - self.y,
		.z = v2.z - self.z,
	}.length();
}
/** Calculate square distance between two vectors
 **/
fn float Vector3.distance_sqr(&self, Vector3 v2) {
	return Vector3{
		.x = v2.x - self.x,
		.y = v2.y - self.y,
		.z = v2.z - self.z,
	}.length_sqr();
}
/** Calculate angle between two vectors
 **/
fn float Vector3.angle(&self, Vector3 v2) {
	Vector3 cross = self.cross_product(v2);
	float len = cross.length();
	float dot = self.dot_product(v2);

	return math::atan2(len, dot);
}
/** Normalize provided vector
 **/
fn Vector3 Vector3.normalize(&self) {
	float len = self.length();
	if (len != 0) {
		float ilen = self.length();

		return {
			.x = self.x * ilen,
			.y = self.y * ilen,
			.z = self.z * ilen,
		};
	} else { return *self; }
}
/** Calculate the projection of the vector v1 on to v2
 **/
fn Vector3 Vector3.project(&self, Vector3 v2) {
	float v1dv2 = self.x*v2.x + self.y*v2.y + self.z*v2.z;
	float v2dv2 = v2.length_sqr();

	float mag = v1dv2 / v2dv2;

	return {
		.x = v2.x * mag,
		.y = v2.y * mag,
		.z = v2.z * mag,
	};
}
/** Calculate the rejection of the vector v1 on to v2
 **/
fn Vector3 Vector3.reject(&self, Vector3 v2) {
	float v1dv2 = self.x*v2.x + self.y*v2.y + self.z*v2.z;
	float v2dv2 = v2.length_sqr();

	float mag = v1dv2 / v2dv2;

	return Vector3{
		.x = self.x - (v2.x * mag),
		.y = self.y - (v2.y * mag),
		.z = self.z - (v2.z * mag),
	};
}
/** Orthonormalize provided vectors. Makes vectors normalized and orthogonal to each other. Gram-Schmidt function implementation.
 **/
fn void Vector3.orthinormalize(&self, Vector3* v2) {
	float len;
	float ilen;

	//* Normalize self
	len = self.length();
	if (len == 0) len = 1;
	ilen = 1 / len;
	self.x *= ilen;
	self.y *= ilen;
	self.z *= ilen;

	//* Cross product
	Vector3 vn1 = self.cross_product(*v2);

	//* Normalize
	len = vn1.length();
	if (len == 0) len = 1;
	ilen = 1.0 / len;
	vn1.x *= ilen;
	vn1.y *= ilen;
	vn1.z *= ilen;

	//* Cross product
	Vector3 vn2 = vn1.cross_product(*self);

	v2.x = vn2.x;
	v2.y = vn2.y;
	v2.z = vn2.z;
}
/** Transforms a Vector3 by a given Matrix
 **/
fn Vector3 Vector3.transform(&self, Matrix mat) {
	return {
		.x = mat.m0 * self.x + mat.m4 * self.y + mat.m8  * self.z + mat.m12,
		.y = mat.m1 * self.x + mat.m5 * self.y + mat.m9  * self.z + mat.m13,
		.z = mat.m2 * self.x + mat.m6 * self.y + mat.m10 * self.z + mat.m14,
	};
}
/** Transform a vector by quaternion rotation
 **/
fn Vector3 Vector3.rotate_quaternion(&self, Quaternion q) {
	return {
		.x = self.x * (double)(q.x.pow(2) + q.w.pow(2) - q.y.pow(2) - q.z.pow(2)) + self.y * (2.0 * q.x * q.y - 2.0 * q.w * q.z) + self.z * (2.0 * q.x * q.z + 2.0 * q.w * q.y),
		.y = self.x * (2.0 * q.w * q.z + 2.0 * q.x * q.y) + self.y * (double)(q.w.pow(2) - q.x.pow(2) + q.y.pow(2) - q.z.pow(2)) + self.z * (-2.0 * q.w * q.x + 2.0 * q.y * q.z),
		.z = self.x * (-2.0 * q.w * q.y + 2.0 * q.x * q.z) + self.y * (2.0 * q.w * q.x + 2.0 * q.y * q.z) + self.z * (double)(q.w.pow(2) - q.x.pow(2) - q.y.pow(2) + q.z.pow(2)),
	};
}
/** Rotates a vector around an axis Using Euler-Rodrigues Formula
 **/
fn Vector3 Vector3.rotate_axis(&self, Vector3 axis, float angle) {
	//* normalize
	float len = axis.length();
	if (len == 0) len = 1;
	float ilen = 1 / len;
	Vector3 new_axis = {
		.x = axis.x * ilen,
		.y = axis.y * ilen,
		.z = axis.z * ilen,
	};
	float new_angle = angle / 2;
	float a = math::sin(new_angle);
	float b = new_axis.x * a;
	float c = new_axis.y * a;
	float d = new_axis.z * a;
	a = math::cos(angle);
	Vector3 w = {.x = b, .y = c, .z = d };

	//* Cross product
	Vector3 wv = w.cross_product(*self);
	Vector3 wwv = w.cross_product(wv);

	//* Scale
	a *= 2;
	wv = {
		.x = wv.x * a,
		.y = wv.y * a,
		.z = wv.z * a,
	};
	wv = {
		.x = wv.x * 2,
		.y = wv.y * 2,
		.z = wv.z * 2,
	};

	return {
		.x = self.x + wv.x + wwv.x,
		.y = self.y + wv.y + wwv.y,
		.z = self.z + wv.z + wwv.z,
	};
}
/** Move Vector towards target
 **/
fn Vector3 Vector3.move_towards(&self, Vector3 target, float max_distance) {
	float dx = target.x - self.x;
	float dy = target.y - self.y;
	float dz = target.z - self.z;
	float value = dx.pow(2) + dy.pow(2) + dz.pow(2);

	if (value == 0.0 || (max_distance >= 0.0 && value <= max_distance.pow(2))) { return {}; }

	float dist = math::sqrt(value);

	return {
		.x = self.x + dx / dist * max_distance,
		.y = self.y + dy / dist * max_distance,
		.z = self.z + dz / dist * max_distance,
	};
}
/** Calculate linear interpolation between two vectors
 **/
fn Vector3 Vector3.lerp(&self, Vector3 target, float amount) {
	return {
		.x = self.x + amount * (target.x - self.x),
		.y = self.y + amount * (target.y - self.y),
		.z = self.z + amount * (target.z - self.z),
	};
}
/** Calculate reflected vector to normal
 **/
fn Vector3 Vector3.reflect(&self, Vector3 normal) {
	float dot = self.dot_product(normal);

	return {
		.x = self.x - (2.0 * normal.x) * dot,
		.y = self.y - (2.0 * normal.y) * dot,
		.z = self.z - (2.0 * normal.z) * dot,
	};
}
/** Get min value for each pair of components
 **/
fn Vector3 Vector3.min(&self, Vector3 v2) {
	return {
		.x = math::min(self.x, v2.x),
		.y = math::min(self.y, v2.y),
		.z = math::min(self.z, v2.z),
	};
}
/** Get max value for each pair of components
 **/
fn Vector3 Vector3.max(&self, Vector3 v2) {
	return {
		.x = math::max(self.x, v2.x),
		.y = math::max(self.y, v2.y),
		.z = math::max(self.z, v2.z),
	};
}
/** Compute barycenter coordinates (u, v, w) for point p with respect to triangle (a, b, c)
 **/
fn Vector3 Vector3.barycenter(&self, Vector3 a, Vector3 b, Vector3 c) {
	Vector3 v0 = {
		.x = b.x - a.x,
		.y = b.y - a.y,
		.z = b.z - a.z,
	};
	Vector3 v1 = {
		.x = c.x - a.x,
		.y = c.y - a.y,
		.z = c.z - a.z,
	};
	Vector3 v2 = {
		.x = self.x - a.x,
		.y = self.y - a.y,
		.z = self.z - a.z,
	};
	float d00 = v0.dot_product(v0);
	float d01 = v0.dot_product(v1);
	float d11 = v1.dot_product(v1);
	float d20 = v2.dot_product(v0);
	float d21 = v2.dot_product(v1);

	float denom = d00 * d11 - d01.pow(2);

	float z = (d00 * d21 - d01 * d20) / denom;
	float y = (d11 * d20 - d01 * d21) / denom;

	return {
		.x = 1.0 - (double)(z + y),
		.y = y,
		.z = z,
	};
}
/** Projects a Vector3 from screen space into object space
 **/
fn Vector3 Vector3.unproject(&self, Matrix projection, Matrix view) {
	//* Calculate unprojected matrix (multiply view matrix by projection matrix) and invert it
	Matrix mat_view_proj = {
		.m0  = view.m0  * projection.m0 + view.m1  * projection.m4 + view.m2  * projection.m8  + view.m3  * projection.m12,
		.m1  = view.m0  * projection.m1 + view.m1  * projection.m5 + view.m2  * projection.m9  + view.m3  * projection.m13,
		.m2  = view.m0  * projection.m2 + view.m1  * projection.m6 + view.m2  * projection.m10 + view.m3  * projection.m14,
		.m3  = view.m0  * projection.m3 + view.m1  * projection.m7 + view.m2  * projection.m11 + view.m3  * projection.m15,
		.m4  = view.m4  * projection.m0 + view.m5  * projection.m4 + view.m6  * projection.m8  + view.m7  * projection.m12,
		.m5  = view.m4  * projection.m1 + view.m5  * projection.m5 + view.m6  * projection.m9  + view.m7  * projection.m13,
		.m6  = view.m4  * projection.m2 + view.m5  * projection.m6 + view.m6  * projection.m10 + view.m7  * projection.m14,
		.m7  = view.m4  * projection.m3 + view.m5  * projection.m7 + view.m6  * projection.m11 + view.m7  * projection.m15,
		.m8  = view.m8  * projection.m0 + view.m9  * projection.m4 + view.m10 * projection.m8  + view.m11 * projection.m12,
		.m9  = view.m8  * projection.m1 + view.m9  * projection.m5 + view.m10 * projection.m9  + view.m11 * projection.m13,
		.m10 = view.m8  * projection.m2 + view.m9  * projection.m6 + view.m10 * projection.m10 + view.m11 * projection.m14,
		.m11 = view.m8  * projection.m3 + view.m9  * projection.m7 + view.m10 * projection.m11 + view.m11 * projection.m15,
		.m12 = view.m12 * projection.m0 + view.m13 * projection.m4 + view.m14 * projection.m8  + view.m15 * projection.m12,
		.m13 = view.m12 * projection.m1 + view.m13 * projection.m5 + view.m14 * projection.m9  + view.m15 * projection.m13,
		.m14 = view.m12 * projection.m2 + view.m13 * projection.m6 + view.m14 * projection.m10 + view.m15 * projection.m14,
		.m15 = view.m12 * projection.m3 + view.m13 * projection.m7 + view.m14 * projection.m11 + view.m15 * projection.m1,
	};

	//* Calculate inverted matrix -> MatrixInvert(matViewProj)
	float b00 = mat_view_proj.m0  * mat_view_proj.m5  - mat_view_proj.m1  * mat_view_proj.m4;
	float b01 = mat_view_proj.m0  * mat_view_proj.m6  - mat_view_proj.m2  * mat_view_proj.m4;
	float b02 = mat_view_proj.m0  * mat_view_proj.m7  - mat_view_proj.m3  * mat_view_proj.m4;
	float b03 = mat_view_proj.m1  * mat_view_proj.m6  - mat_view_proj.m2  * mat_view_proj.m5;
	float b04 = mat_view_proj.m1  * mat_view_proj.m7  - mat_view_proj.m3  * mat_view_proj.m5;
	float b05 = mat_view_proj.m2  * mat_view_proj.m7  - mat_view_proj.m3  * mat_view_proj.m6;
	float b06 = mat_view_proj.m8  * mat_view_proj.m13 - mat_view_proj.m9  * mat_view_proj.m12;
	float b07 = mat_view_proj.m8  * mat_view_proj.m14 - mat_view_proj.m10 * mat_view_proj.m12;
	float b08 = mat_view_proj.m8  * mat_view_proj.m15 - mat_view_proj.m11 * mat_view_proj.m12;
	float b09 = mat_view_proj.m9  * mat_view_proj.m14 - mat_view_proj.m10 * mat_view_proj.m13;
	float b10 = mat_view_proj.m9  * mat_view_proj.m15 - mat_view_proj.m11 * mat_view_proj.m13;
	float b11 = mat_view_proj.m10 * mat_view_proj.m15 - mat_view_proj.m11 * mat_view_proj.m14;

	//* Calculate the invert determinant (inlined to avoid double-caching)
	float inv_det = 1 / ((b00 * b11) - (b01 * b10) + (b02 * b09) + (b03 * b08) - (b04 * b07) + (b05 * b06));

	Matrix mat_view_proj_inv = {
		.m0  = (( mat_view_proj.m5  * b11) - (mat_view_proj.m6  * b10) + (mat_view_proj.m7  * b09)) * inv_det,
		.m1  = ((-mat_view_proj.m1  * b11) - (mat_view_proj.m2  * b10) + (mat_view_proj.m3  * b09)) * inv_det,
		.m2  = (( mat_view_proj.m13 * b05) - (mat_view_proj.m14 * b04) + (mat_view_proj.m15 * b03)) * inv_det,
		.m3  = ((-mat_view_proj.m9  * b05) + (mat_view_proj.m10 * b04) - (mat_view_proj.m11 * b03)) * inv_det,
		.m4  = ((-mat_view_proj.m4  * b11) + (mat_view_proj.m6  * b08) - (mat_view_proj.m7  * b07)) * inv_det,
		.m5  = (( mat_view_proj.m0  * b11) - (mat_view_proj.m2  * b08) + (mat_view_proj.m3  * b07)) * inv_det,
		.m6  = ((-mat_view_proj.m12 * b05) + (mat_view_proj.m14 * b02) - (mat_view_proj.m15 * b01)) * inv_det,
		.m7  = (( mat_view_proj.m8  * b05) - (mat_view_proj.m10 * b02) + (mat_view_proj.m11 * b01)) * inv_det,
		.m8  = (( mat_view_proj.m4  * b10) - (mat_view_proj.m5  * b08) + (mat_view_proj.m7  * b06)) * inv_det,
		.m9  = ((-mat_view_proj.m0  * b10) + (mat_view_proj.m1  * b08) - (mat_view_proj.m3  * b06)) * inv_det,
		.m10 = (( mat_view_proj.m12 * b04) - (mat_view_proj.m13 * b02) + (mat_view_proj.m15 * b00)) * inv_det,
		.m11 = ((-mat_view_proj.m8  * b04) + (mat_view_proj.m9  * b02) - (mat_view_proj.m11 * b00)) * inv_det,
		.m12 = ((-mat_view_proj.m4  * b09) + (mat_view_proj.m5  * b07) - (mat_view_proj.m6  * b06)) * inv_det,
		.m13 = (( mat_view_proj.m0  * b09) - (mat_view_proj.m1  * b07) + (mat_view_proj.m2  * b06)) * inv_det,
		.m14 = ((-mat_view_proj.m12 * b03) + (mat_view_proj.m13 * b01) - (mat_view_proj.m14 * b00)) * inv_det,
		.m15 = (( mat_view_proj.m8  * b03) - (mat_view_proj.m9  * b01) + (mat_view_proj.m10 * b00)) * inv_det,
	};

	//* Create quaternion from source point
	Quaternion quat = { .x = self.x, .y = self.y, .z = self.z, .w = 1 };

	//* Multiply quat point by unprojected matrix
	Vector4 q_tranformed = mat_view_proj_inv.quaternion_transform(quat);

	//* Normalized world points in vectors
	return {
		.x = q_tranformed.x / q_tranformed.w,
		.y = q_tranformed.y / q_tranformed.w,
		.z = q_tranformed.z / q_tranformed.w,
	};
}
/** Invert the given vector
 **/
fn Vector3 Vector3.invert(&self) {
	return {.x = 1 / self.x, .y = 1 / self.y, .z = 1 / self.z };
}
/** Clamp the components of the vector between min and max values specified by the given vectors
 **/
fn Vector3 Vector3.clamp(&self, Vector3 min, Vector3 max) {
	return {
		.x = math::min(max.x, math::max(min.x, self.x)),
		.y = math::min(max.y, math::max(min.y, self.y)),
		.z = math::min(max.z, math::max(min.z, self.z)),
	};
}
/** Clamp the magnitude of the vector between two values
 **/
fn Vector3 Vector3.clamp_value(&self, float min, float max) {
	Vector3 result = *self;

	float len = self.length_sqr();
	if (len > 0) {
		len = math::sqrt(len);

		float scale;
		if (len < min) { scale = min / len; }
		else if (len > max) { scale = max / len; }
		else { scale = 1; };

		result = {
			.x = self.x * scale,
			.y = self.y * scale,
			.z = self.z * scale,
		};
	}

	return {
		.x = result.x,
		.y = result.y,
		.z = result.z,
	};
}
/** Compute the direction of a refracted ray
 **/
fn Vector3 Vector3.refract(Vector3 v, Vector3 n, float r) {
	Vector3 result = {};

	float dot = v.dot_product(n);
	float d = 1 - r.pow(2) * (1 - dot.pow(2));

	if (d >= 0) {
		d = math::sqrt(d);

		result = {
			.x = r * v.x - (r * dot + d) * n.x,
			.y = r * v.y - (r * dot + d) * n.y,
			.z = r * v.z - (r * dot + d) * n.z,
		};
	}

	return result;
}
/** Converts input HSV into  it's equivalent color
 **/
fn Color Vector3.to_color(&self) {
	Color result = {
		.r = 0,
		.g = 0,
		.b = 0,
		.a = 255,
	};

	//* Red channel
	float k = (5 + self.x / 60) % 6;
	float t = 4 - k;
	if (t < k) { k = t; } else { k = k; };
	if (k < 1) { k = k; } else { k = 1; };
	if (k > 0) { k = k; } else { k = 0; };
	result.r = (char)((self.z - self.z * self.y * k) * 255);

	//* Green channel
	k = (3 + self.x / 60) % 6;
	t = 4 - k;
	if (t < k) { k = t; } else { k = k; };
	if (k < 1) { k = k; } else { k = 1; };
	if (k > 0) { k = k; } else { k = 0; };
	result.g = (char)((self.z - self.z * self.y * k) * 255);

	//* Blue channel
	k = (1 + self.x / 60) % 6;
	t = 4 - k;
	if (t < k) { k = t; } else { k = k; };
	if (k < 1) { k = k; } else { k = 1; };
	if (k > 0) { k = k; } else { k = 0; };
	result.b = (char)((self.z - self.z * self.y * k) * 255);

	return result;
}


/** Vector4
 **/
struct Vector4 {
	float x, y, z, w;
}
/** Add two matrices returning the result
 **/
fn Vector4 Vector4.add(&self, Vector4 rhs) {
	return {
		.x = self.x + rhs.x,
		.y = self.y + rhs.y,
		.z = self.z + rhs.z,
		.w = self.w + rhs.w,
	};
}
/** Subtract two matrices returning the result
 **/
fn Vector4 Vector4.sub(&self, Vector4 rhs) {
	return {
		.x = self.x - rhs.x,
		.y = self.y - rhs.y,
		.z = self.z - rhs.z,
		.w = self.w - rhs.w,
	};
}
/** Multiply two matrices returning the result
 **/
fn Vector4 Vector4.mul(&self, Vector4 rhs) {
	return {
		.x = self.x * rhs.x,
		.y = self.y * rhs.y,
		.z = self.z * rhs.z,
		.w = self.w * rhs.w,
	};
}
/** Divide two matrices returning the result
 **/
fn Vector4 Vector4.div(&self, Vector4 rhs) {
	return {
		.x = self.x / rhs.x,
		.y = self.y / rhs.y,
		.z = self.z / rhs.z,
		.w = self.w / rhs.w,
	};
}
/** Calculate vector length
 **/
fn float Vector4.length(&self) {
	return math::sqrt(self.x.pow(2) + self.y.pow(2) + self.z.pow(2) + self.w.pow(2));
}
/** Calculate vector square length
 **/
fn float Vector4.length_square(&self) {
	return self.x.pow(2) + self.y.pow(2) + self.z.pow(2) + self.w.pow(2);
}
/** Calculate two vectors dot product
 **/
fn float Vector4.dot_product(&self, Vector4 v2) {
	return self.x * v2.x + self.y * v2.y + self.z * v2.z + self.w * v2.w;
}
/** Calculate distance between two vectors
 **/
fn float Vector4.distance(&self, Vector4 v2) {
	return math::sqrt((self.x - v2.x).pow(2) + (self.y - v2.y).pow(2) + (self.z - v2.z).pow(2) + (self.w - v2.w).pow(2));
}
/** Calculate square distance between two vectors
 **/
fn float Vector4.distance_square(&self, Vector4 v2) {
	return (self.x - v2.x).pow(2) + (self.y - v2.y).pow(2) + (self.z - v2.z).pow(2) + (self.w - v2.w).pow(2);
}
/** Normalize provided vector
 **/
fn Vector4 Vector4.normalize(&self) {
	Vector4 result = {};

	float len = self.length();
	if (len > 0) {
		float ilen = 1 / len;
		result = {
			.x = self.x * ilen,
			.y = self.y * ilen,
			.z = self.z * ilen,
			.w = self.w * ilen,
		};
	}

	return result;
}
/** Get min value for each pair of components
 **/
fn Vector4 Vector4.min(&self, Vector4 v2) {
	return {
		.x = math::min(self.x, v2.x),
		.y = math::min(self.y, v2.y),
		.z = math::min(self.z, v2.z),
		.w = math::min(self.w, v2.w),
	};
}
/** Get max value for each pair of components
 **/
fn Vector4 Vector4.max(&self, Vector4 v2) {
	return {
		.x = math::max(self.x, v2.x),
		.y = math::max(self.y, v2.y),
		.z = math::max(self.z, v2.z),
		.w = math::max(self.w, v2.w),
	};
}
/** Calculate linear interpolation between two vectors
 **/
fn Vector4 Vector4.lerp(&self, Vector4 target, float amount) {
	return {
		.x = self.x + amount * (target.x - self.x),
		.y = self.y + amount * (target.y - self.y),
		.z = self.z + amount * (target.z - self.z),
		.w = self.w + amount * (target.w - self.w),
	};
}
/** Move Vector towards target
 **/
fn Vector4 Vector4.move_towards(&self, Vector4 target, float max_distance) {
	float dx = target.x - self.x;
	float dy = target.y - self.y;
	float dz = target.z - self.z;
	float dw = target.w - self.w;
	float value = dx.pow(2) + dy.pow(2) + dz.pow(2) + dw.pow(2);

	if (value == 0.0 || (max_distance >= 0.0 && value <= max_distance.pow(2))) { return {}; }

	float dist = math::sqrt(value);

	return {
		.x = self.x + dx / dist * max_distance,
		.y = self.y + dy / dist * max_distance,
		.z = self.z + dz / dist * max_distance,
		.w = self.w + dw / dist * max_distance,
	};
}
/** Invert the given vector
 **/
fn Vector4 Vector4.invert(&self) {
	return {
		.x = 1 / self.x,
		.y = 1 / self.y,
		.z = 1 / self.z,
		.w = 1 / self.w,
	};
}
/** Converts normaized Vector4 into a color.
 **/
fn Color Vector4.to_color(&self) {
	return {
		.r = (char)(self.x * 255),
		.g = (char)(self.y * 255),
		.b = (char)(self.z * 255),
		.a = (char)(self.w * 255),
	};
}


/** Quaternion
 **/
distinct Quaternion = Vector4;
/** Computes the length of a quaternion
 **/
fn float Quaternion.length(&self) {
	return math::sqrt(self.x.pow(2) + self.y.pow(2) + self.z.pow(2) + self.w.pow(2));
}
/** Calculate two quaternions dot product
 **/
fn float Quaternion.dot_product(&self, Quaternion v2) {
	return self.x * v2.x + self.y * v2.y + self.z * v2.z + self.w * v2.w;
}
/** Normalize provided quaternion
 **/
fn Quaternion Quaternion.normalize(&self) {
	Quaternion result = {};

	float len = self.length();
	if (len > 0) {
		float ilen = 1 / len;
		result = {
			.x = self.x * ilen,
			.y = self.y * ilen,
			.z = self.z * ilen,
			.w = self.w * ilen,
		};
	}

	return result;
}
/** Invert provided quaternion
 **/
fn Quaternion Quaternion.invert(&self) {
	return {
		.x = 1 / self.x,
		.y = 1 / self.y,
		.z = 1 / self.z,
		.w = 1 / self.w,
	};
}
/** Calculate linear interpolation between two quaternions
 **/
fn Quaternion Quaternion.lerp(&self, Quaternion target, float amount) {
	return {
		.x = self.x + amount * (target.x - self.x),
		.y = self.y + amount * (target.y - self.y),
		.z = self.z + amount * (target.z - self.z),
		.w = self.w + amount * (target.w - self.w),
	};
}
/** Calculate slerp-optimized interpolation between two quaternions
 **/
fn Quaternion Quaternion.n_lerp(&self, Quaternion target, float amount) {
	Quaternion result = {
		.x = self.x + amount * (target.x - self.x),
		.y = self.y + amount * (target.y - self.y),
		.z = self.z + amount * (target.z - self.z),
		.w = self.w + amount * (target.w - self.w),
	};

	float len = result.length();
	if (len == 0) { len = 1; };
	float ilen = 1 / len;

	return {
		.x = result.x * ilen,
		.y = result.y * ilen,
		.z = result.z * ilen,
		.w = result.w * ilen,
	};
}
/** Calculates spherical linear interpolation between two quaternions
 **/
fn Quaternion Quaternion.slerp(&self, Quaternion target, float amount) {
	Quaternion result = {};

	float cos_half_theta = self.dot_product(target);
	Quaternion new_target = target;
	if (cos_half_theta < 0) {
		new_target.x = -target.x;
		new_target.y = -target.y;
		new_target.z = -target.z;
		new_target.w = -target.w;
		cos_half_theta = -cos_half_theta;
	}

	if (math::abs(cos_half_theta) >= 1) { result = *self; }
	else if (cos_half_theta > 0.95) { result = self.n_lerp(target, amount); }
	else {
		float half_theta = math::acos(cos_half_theta);
		float sin_half_theta = math::sqrt(1 - cos_half_theta.pow(2));

		if (math::abs(sin_half_theta) < math::E) {
			result = {
				.x = (self.x * 0.5 + target.x * 0.5),
				.y = (self.y * 0.5 + target.y * 0.5),
				.z = (self.z * 0.5 + target.z * 0.5),
				.w = (self.w * 0.5 + target.w * 0.5),
			};
		} else {
			float ratio_a = math::sin((1 - amount) * half_theta) / sin_half_theta;
			float ratio_b = math::sin(amount * half_theta) / sin_half_theta;

			result = {
				.x = (self.x * ratio_a + target.x * ratio_b),
				.y = (self.y * ratio_a + target.y * ratio_b),
				.z = (self.z * ratio_a + target.z * ratio_b),
				.w = (self.w * ratio_a + target.w * ratio_b),
			};
		}
	}

	return result;
}
/** Get the rotation angle and axis for a given quaternion
 **/
fn AxisAngle Quaternion.to_axis_angle(&self) {
	Quaternion new_quat = *self;

	if (math::abs(self.w) > 1) {
		float len = self.length();
		if (len == 0) { len = 1; }
		float ilen = 1 / len;

		new_quat.x = self.x * ilen;
		new_quat.y = self.y * ilen;
		new_quat.z = self.z * ilen;
		new_quat.w = self.w * ilen;
	}

	Vector3 res_axis = {};
	float res_angle = 2 * math::acos(self.w);
	float den = (1 - math::sqrt(self.w.pow(2)));

	if (den > EPSILON) {
		res_axis.x = self.x / den;
		res_axis.y = self.y / den;
		res_axis.z = self.z / den;
	} else {
		res_axis.x = 1.0;
	}

	return { .axis = res_axis, .angle = res_angle };
}
/** Get the Euler angles equivalent to quaternion (roll, pitch, yaw)
 **/
fn Vector3 Quaternion.to_euler(&self) {
	float pitch;
	float yaw;
	float roll;

	//* Roll
	float x0 = 2 * (self.w * self.x + self.y * self.z);
	float x1 = 1 - (2 * (self.x.pow(2) + self.y.pow(2)));
	roll = math::atan2(x0, x1);

	//* Pitch
	float y0 = 2 * (self.w * self.y - self.z * self.x);
	if (y0 >  1) { y0 =  1; }
	if (y0 < -1) { y0 = -1; }
	pitch = math::asin(y0);

	//* Yaw
	float z0 = 2 * (self.w * self.z + self.x * self.y);
	float z1 = 1 - 2 * (self.y.pow(2) + self.z.pow(2));
	yaw = math::atan2(z0, z1);

	return { .x = pitch, .y = yaw, .z = roll };
}
/** Transform a quaternion given a transformation matrix
 **/
fn Quaternion Quaternion.transform(&self, Matrix mat) {
	return {
		.x = mat.m0 * self.x + mat.m4 * self.y + mat.m8  * self.z + mat.m12 * self.w,
		.y = mat.m1 * self.x + mat.m5 * self.y + mat.m9  * self.z + mat.m13 * self.w,
		.z = mat.m2 * self.x + mat.m6 * self.y + mat.m10 * self.z + mat.m14 * self.w,
		.w = mat.m3 * self.x + mat.m7 * self.y + mat.m11 * self.z + mat.m15 * self.w,
	};
}

/** Matrix
 **/
struct Matrix {
	float m0, m4, m8,  m12;
	float m1, m5, m9,  m13;
	float m2, m6, m10, m14;
	float m3, m7, m11, m15;
}
/** Add two matrices returning the result
 **/
fn Matrix Matrix.add(&self, Matrix rhs) {
	Matrix result = {};
	result.m0  = self.m0  + rhs.m0;
	result.m1  = self.m1  + rhs.m1;
	result.m2  = self.m2  + rhs.m2;
	result.m3  = self.m3  + rhs.m3;
	result.m4  = self.m4  + rhs.m4;
	result.m5  = self.m5  + rhs.m5;
	result.m6  = self.m6  + rhs.m6;
	result.m7  = self.m7  + rhs.m7;
	result.m8  = self.m8  + rhs.m8;
	result.m9  = self.m9  + rhs.m9;
	result.m10 = self.m10 + rhs.m10;
	result.m11 = self.m11 + rhs.m11;
	result.m12 = self.m12 + rhs.m12;
	result.m13 = self.m13 + rhs.m13;
	result.m14 = self.m14 + rhs.m14;
	result.m15 = self.m15 + rhs.m15;

	return result;
}
/** Subtract two matrices returning the result
 **/
fn Matrix Matrix.sub(&self, Matrix rhs) {
	Matrix result = {};

	result.m0  = self.m0  - rhs.m0;
	result.m1  = self.m1  - rhs.m1;
	result.m2  = self.m2  - rhs.m2;
	result.m3  = self.m3  - rhs.m3;
	result.m4  = self.m4  - rhs.m4;
	result.m5  = self.m5  - rhs.m5;
	result.m6  = self.m6  - rhs.m6;
	result.m7  = self.m7  - rhs.m7;
	result.m8  = self.m8  - rhs.m8;
	result.m9  = self.m9  - rhs.m9;
	result.m10 = self.m10 - rhs.m10;
	result.m11 = self.m11 - rhs.m11;
	result.m12 = self.m12 - rhs.m12;
	result.m13 = self.m13 - rhs.m13;
	result.m14 = self.m14 - rhs.m14;
	result.m15 = self.m15 - rhs.m15;

	return result;
}
/** Multiply two matrices returning the result
 **/
fn Matrix Matrix.mul(&self, Matrix rhs) {
	Matrix result = {};

	result.m0  = self.m0  * rhs.m0 + self.m1  * rhs.m4 + self.m2  * rhs.m8  + self.m3  * rhs.m12;
	result.m1  = self.m0  * rhs.m1 + self.m1  * rhs.m5 + self.m2  * rhs.m9  + self.m3  * rhs.m13;
	result.m2  = self.m0  * rhs.m2 + self.m1  * rhs.m6 + self.m2  * rhs.m10 + self.m3  * rhs.m14;
	result.m3  = self.m0  * rhs.m3 + self.m1  * rhs.m7 + self.m2  * rhs.m11 + self.m3  * rhs.m15;
	result.m4  = self.m4  * rhs.m0 + self.m5  * rhs.m4 + self.m6  * rhs.m8  + self.m7  * rhs.m12;
	result.m5  = self.m4  * rhs.m1 + self.m5  * rhs.m5 + self.m6  * rhs.m9  + self.m7  * rhs.m13;
	result.m6  = self.m4  * rhs.m2 + self.m5  * rhs.m6 + self.m6  * rhs.m10 + self.m7  * rhs.m14;
	result.m7  = self.m4  * rhs.m3 + self.m5  * rhs.m7 + self.m6  * rhs.m11 + self.m7  * rhs.m15;
	result.m8  = self.m8  * rhs.m0 + self.m9  * rhs.m4 + self.m10 * rhs.m8  + self.m11 * rhs.m12;
	result.m9  = self.m8  * rhs.m1 + self.m9  * rhs.m5 + self.m10 * rhs.m9  + self.m11 * rhs.m13;
	result.m10 = self.m8  * rhs.m2 + self.m9  * rhs.m6 + self.m10 * rhs.m10 + self.m11 * rhs.m14;
	result.m11 = self.m8  * rhs.m3 + self.m9  * rhs.m7 + self.m10 * rhs.m11 + self.m11 * rhs.m15;
	result.m12 = self.m12 * rhs.m0 + self.m13 * rhs.m4 + self.m14 * rhs.m8  + self.m15 * rhs.m12;
	result.m13 = self.m12 * rhs.m1 + self.m13 * rhs.m5 + self.m14 * rhs.m9  + self.m15 * rhs.m13;
	result.m14 = self.m12 * rhs.m2 + self.m13 * rhs.m6 + self.m14 * rhs.m10 + self.m15 * rhs.m14;
	result.m15 = self.m12 * rhs.m3 + self.m13 * rhs.m7 + self.m14 * rhs.m11 + self.m15 * rhs.m15;

	return result;
}
/** Compute matrix determinant
 **/
fn float Matrix.determinant(&self) {
	return self.m12 * self.m9 * self.m6*self.m3 - self.m8 * self.m13 * self.m6 * self.m3 - self.m12 * self.m5 * self.m10 * self.m3 + self.m4 * self.m13 * self.m10 * self.m3 +
		self.m8  *self.m5 * self.m14 * self.m3  - self.m4 * self.m9  * self.m14 * self.m3  - self.m12 * self.m9 * self.m2  * self.m7  + self.m8 * self.m13 * self.m2  * self.m7  +
		self.m12 *self.m1 * self.m10 * self.m7  - self.m0 * self.m13 * self.m10 * self.m7  - self.m8  * self.m1 * self.m14 * self.m7  + self.m0 * self.m9  * self.m14 * self.m7  +
		self.m12 *self.m5 * self.m2  * self.m11 - self.m4 * self.m13 * self.m2  * self.m11 - self.m12 * self.m1 * self.m6  * self.m11 + self.m0 * self.m13 * self.m6  * self.m11 +
		self.m4  *self.m1 * self.m14 * self.m11 - self.m0 * self.m5  * self.m14 * self.m11 - self.m8  * self.m5 * self.m2  * self.m15 + self.m4 * self.m9  * self.m2  * self.m15 +
		self.m8  *self.m1 * self.m6  * self.m15 - self.m0 * self.m9  * self.m6  * self.m15 - self.m4  * self.m1 * self.m10 * self.m15 + self.m0 * self.m5  * self.m10 * self.m15;
}
/** Get the trace of the matrix (Sum of the values along the diagonal)
 **/
fn float Matrix.trace(&self) {
	return self.m0 + self.m5 + self.m10 + self.m15;
}
/** Tansposes provided matrix
 **/
fn Matrix Matrix.transpose(&self) {
	Matrix result = {};

	result.m0  = self.m0;
	result.m1  = self.m4;
	result.m2  = self.m8;
	result.m3  = self.m12;
	result.m4  = self.m1;
	result.m5  = self.m5;
	result.m6  = self.m9;
	result.m7  = self.m13;
	result.m8  = self.m2;
	result.m9  = self.m6;
	result.m10 = self.m10;
	result.m11 = self.m14;
	result.m12 = self.m3;
	result.m13 = self.m7;
	result.m14 = self.m11;
	result.m15 = self.m15;

	return result;
}
/** Invert provided matrix
 **/
fn Matrix Matrix.invert(&self) {
	Matrix result = {};

	//* Cache the matrix values (speed optimization)
	float a00 = self.m0;
	float a01 = self.m1;
	float a02 = self.m2;
	float a03 = self.m3;
	float a10 = self.m4;
	float a11 = self.m5;
	float a12 = self.m6;
	float a13 = self.m7;
	float a20 = self.m8;
	float a21 = self.m9;
	float a22 = self.m10;
	float a23 = self.m11;
	float a30 = self.m12;
	float a31 = self.m13;
	float a32 = self.m14;
	float a33 = self.m15;

	float b00 = a00 * a11 - a01 * a10;
	float b01 = a00 * a12 - a02 * a10;
	float b02 = a00 * a13 - a03 * a10;
	float b03 = a01 * a12 - a02 * a11;
	float b04 = a01 * a13 - a03 * a11;
	float b05 = a02 * a13 - a03 * a12;
	float b06 = a20 * a31 - a21 * a30;
	float b07 = a20 * a32 - a22 * a30;
	float b08 = a20 * a33 - a23 * a30;
	float b09 = a21 * a32 - a22 * a31;
	float b10 = a21 * a33 - a23 * a31;
	float b11 = a22 * a33 - a23 * a32;

	//* Calculate the invert determinant (inlined to avoid double-caching)
	float inv_det = 1 / (b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 * b06);

	result.m0  = ( a11 * b11 - a12 * b10 + a13 * b09) * inv_det;
	result.m1  = (-a01 * b11 + a02 * b10 - a03 * b09) * inv_det;
	result.m2  = ( a31 * b05 - a32 * b04 + a33 * b03) * inv_det;
	result.m3  = (-a21 * b05 + a22 * b04 - a23 * b03) * inv_det;
	result.m4  = (-a10 * b11 + a12 * b08 - a13 * b07) * inv_det;
	result.m5  = ( a00 * b11 - a02 * b08 + a03 * b07) * inv_det;
	result.m6  = (-a30 * b05 + a32 * b02 - a33 * b01) * inv_det;
	result.m7  = ( a20 * b05 - a22 * b02 + a23 * b01) * inv_det;
	result.m8  = ( a10 * b10 - a11 * b08 + a13 * b06) * inv_det;
	result.m9  = (-a00 * b10 + a01 * b08 - a03 * b06) * inv_det;
	result.m10 = ( a30 * b04 - a31 * b02 + a33 * b00) * inv_det;
	result.m11 = (-a20 * b04 + a21 * b02 - a23 * b00) * inv_det;
	result.m12 = (-a10 * b09 + a11 * b07 - a12 * b06) * inv_det;
	result.m13 = ( a00 * b09 - a01 * b07 + a02 * b06) * inv_det;
	result.m14 = (-a30 * b03 + a31 * b01 - a32 * b00) * inv_det;
	result.m15 = ( a20 * b03 - a21 * b01 + a22 * b00) * inv_det;

	return result;
}
/** Transform a quaternion given a transformation matrix
 **/
fn Vector4 Matrix.quaternion_transform(&self, Quaternion q) {
	return {
		.x = self.m0 * q.x + self.m4 * q.y + self.m8  * q.z + self.m12 * q.w,
		.y = self.m1 * q.x + self.m5 * q.y + self.m9  * q.z + self.m13 * q.w,
		.z = self.m2 * q.x + self.m6 * q.y + self.m10 * q.z + self.m14 * q.w,
		.w = self.m3 * q.x + self.m7 * q.y + self.m11 * q.z + self.m15 * q.w,
	};
}
/** Prints matrix to console
 **/
fn void Matrix.print(&self) {
	io::printfn("[\n\t%d, %d, %d, %d,\n\t%d, %d, %d, %d,\n\t%d, %d, %d, %d,\n\t%d, %d, %d, %d,\n]",
		self.m0, self.m4, self.m8,  self.m12,
		self.m1, self.m5, self.m9,  self.m13,
		self.m2, self.m6, self.m10, self.m14,
		self.m3, self.m7, self.m11, self.m15,
	);
}



/** Axis and Angle tuple
 **/
struct AxisAngle {
	Vector3 axis;
	float angle;
}



/** VR stuff
 **/
struct VrDeviceInfo {
	int h_resolution, v_resolution;
	float h_screen_size, v_screen_size;
	float eye_to_screen_distance;
	float lens_seperation_distance;
	float interpupillary_distance;
	float[4] lens_distortion_values;
	float[4] chroma_aberration_correction;
}
struct VrStereoConfig {
	Matrix[2] projection, view_offset;
	float[2] left_lens_center, right_lens_center;
	float[2] left_screen_center, right_screen_center;
	float[2] scale, scale_in;
}



//= Color module
module pleroma::color;

const Color LIGHTGRAY	= {200, 200, 200, 255};
const Color GRAY		= {130, 130, 130, 255};
const Color DARKGRAY	= { 80,  80,  80, 255};
const Color YELLOW		= {253, 249,   0, 255};
const Color GOLD		= {255, 203,   0, 255};
const Color ORANGE		= {255, 161,   0, 255};
const Color PINK		= {255, 109, 194, 255};
const Color RED			= {230,  41,  55, 255};
const Color MAROON		= {190,  33,  55, 255};
const Color GREEN		= {  0, 228,  48, 255};
const Color LIME		= {  0, 158,  47, 255};
const Color DARKGREEN	= {  0, 117,  44, 255};
const Color SKYBLUE		= {102, 191, 255, 255};
const Color BLUE		= {  0, 121, 241, 255};
const Color DARKBLUE	= {  0,  82, 172, 255};
const Color PURPLE		= {200, 122, 255, 255};
const Color VIOLET		= {135,  60, 190, 255};
const Color DARKPURPLE	= {112,  31, 126, 255};
const Color BEIGE		= {211, 176, 131, 255};
const Color BROWN		= {127, 106,  79, 255};
const Color DARKBROWN	= { 76,  63,  47, 255};
const Color WHITE		= {255, 255, 255, 255};
const Color BLACK		= {  0,   0,   0, 255};
const Color BLANK		= {  0,   0,   0,   0};
const Color MAGENTA		= {255,   0, 255, 255};
const Color RAYWHITE	= {245, 245, 245, 255};
const Color PALETTE_30	= { 48,  56,  67, 255};

/** Convert hexcode into color
 **/
fn Color hex(uint hex_value) {
	return {
		.r = (char)((hex_value >> 24) & 0xFF),
		.g = (char)((hex_value >> 16) & 0xFF),
		.b = (char)((hex_value >> 8 ) & 0xFF),
		.a = (char)( hex_value        & 0xFF),
	};
}



//= Matrix module
module pleroma::matrix;
import std::math;

/** Zero matrix
 **/
const Matrix ZERO = {
	0.0, 0.0, 0.0, 0.0,
	0.0, 0.0, 0.0, 0.0,
	0.0, 0.0, 0.0, 0.0,
	0.0, 0.0, 0.0, 0.0,
};
/** Identity Matrix
 **/
const Matrix IDENTITY = {
	1.0, 0.0, 0.0, 0.0,
	0.0, 1.0, 0.0, 0.0,
	0.0, 0.0, 1.0, 0.0,
	0.0, 0.0, 0.0, 1.0,
};

/** Create translation matrix
 **/
fn Matrix translate(Vector3 v) {
	return {
		1.0, 0.0, 0.0, v.x,
		0.0, 1.0, 0.0, v.y,
		0.0, 0.0, 1.0, v.z,
		0.0, 0.0, 0.0, 1.0,
	};
}
/** Create rotation matrix from axis and angle
 **/
fn Matrix rotate(Vector3 axis, float angle) {
	Matrix result = {};

	float x = axis.x;
	float y = axis.y;
	float z = axis.z;

	float length_squared = x*x + y*y + z*z;
	if (length_squared != 1.0 && (length_squared != 0.0)) {
	    float ilength = 1.0 / math::sqrt(length_squared);
	    x *= ilength;
	    y *= ilength;
	    z *= ilength;
	}

	float sinres = math::sin(angle);
	float cosres = math::cos(angle);
	float t = 1 - cosres;

	result.m0 = x*x*t + cosres;
	result.m1 = y*x*t + z*sinres;
	result.m2 = z*x*t - y*sinres;
	result.m3 = 0;

	result.m4 = x*y*t - z*sinres;
	result.m5 = y*y*t + cosres;
	result.m6 = z*y*t + x*sinres;
	result.m7 = 0;

	result.m8 = x*z*t + y*sinres;
	result.m9 = y*z*t - x*sinres;
	result.m10 = z*z*t + cosres;
	result.m11 = 0;

	result.m12 = 0;
	result.m13 = 0;
	result.m14 = 0;
	result.m15 = 1;

	return result;
}
/** Get x-rotation matrix
 **/
fn Matrix rotate_x(float angle) {
	Matrix result = {};

	float cosres = math::cos(angle);
	float sinres = math::sin(angle);

	result.m5  =  cosres;
	result.m6  =  sinres;
	result.m9  = -sinres;
	result.m10 =  cosres;

	return result;
}
/** Get y-rotation matrix
 **/
fn Matrix rotate_y(float angle) {
	Matrix result = {};

	float cosres = math::cos(angle);
	float sinres = math::sin(angle);

	result.m0  =  cosres;
	result.m2  = -sinres;
	result.m8  =  sinres;
	result.m10 =  cosres;

	return result;
}
/** Get z-rotation matrix
 **/
fn Matrix rotate_z(float angle) {
	Matrix result = {};

	float cosres = math::cos(angle);
	float sinres = math::sin(angle);

	result.m0 =  cosres;
	result.m1 =  sinres;
	result.m4 = -sinres;
	result.m5 =  cosres;

	return result;
}
/** Get xyz-rotation matrix
 **/
fn Matrix rotate_xyz(Vector3 angle) {
	Matrix result = {};

	float cosz = math::cos(-angle.z);
	float sinz = math::sin(-angle.z);
	float cosy = math::cos(-angle.y);
	float siny = math::sin(-angle.y);
	float cosx = math::cos(-angle.x);
	float sinx = math::sin(-angle.x);

	result.m0 =  cosz * cosy;
	result.m1 = (cosz * siny * sinx) - (sinz * cosx);
	result.m2 = (cosz * siny * cosx) + (sinz * sinx);

	result.m4 =  sinz * cosy;
	result.m5 = (sinz * siny * sinx) + (cosz * cosx);
	result.m6 = (sinz * siny * cosx) - (cosz * sinx);

	result.m8 = -siny;
	result.m9 =  cosy * sinx;
	result.m10=  cosy * cosx;

	return result;
}
/** Get xyz-rotation matrix
 **/
fn Matrix rotate_zyx(Vector3 angle) {
	Matrix result = {};

	float cz = math::cos(angle.z);
	float sz = math::sin(angle.z);
	float cy = math::cos(angle.y);
	float sy = math::sin(angle.y);
	float cx = math::cos(angle.x);
	float sx = math::sin(angle.x);

	result.m0  = cz * cy;
	result.m4  = cz * sy * sx - cx * sz;
	result.m8  = sz * sx + cz * cx * sy;
	result.m12 = 0;

	result.m1  = cy * sz;
	result.m5  = cz * cx + sz * sy * sx;
	result.m9  = cx * sz * sy - cz * sx;
	result.m13 = 0;

	result.m2  = -sy;
	result.m6  =  cy * sx;
	result.m10 =  cy * cx;
	result.m14 =  0;

	result.m3  = 0;
	result.m7  = 0;
	result.m11 = 0;
	result.m15 = 1;

	return result;
}
/** Get scaling matrix
 **/
fn Matrix scale(Vector3 scale) {
	return {
		scale.x,     0.0,     0.0, 0.0,
		    0.0, scale.y,     0.0, 0.0,
		    0.0,     0.0, scale.z, 0.0,
		    0.0,     0.0,     0.0, 1.0,
	};
}
/** Get perspective projection matrix
 **/
fn Matrix frustum(double left, double right, double bottom, double top, double near, double far) {
	Matrix result = {};

	float rl  = (float)(right - left);
	float tb  = (float)(top - bottom);
	float f_n = (float)(far - near);

	result.m0 = (float)(near * 2) / rl;
	result.m1 = 0;
	result.m2 = 0;
	result.m3 = 0;

	result.m4 = 0;
	result.m5 = (float)(near * 2) / tb;
	result.m6 = 0;
	result.m7 = 0;

	result.m8  =  (float)(right + left) / rl;
	result.m9  =  (float)(top + bottom) / tb;
	result.m10 = -(float)(far + near) / f_n;
	result.m11 = -1;

	result.m12 = 0;
	result.m13 = 0;
	result.m14 = -(float)(far * near * 2.0) / f_n;
	result.m15 = 0;

	return result;
}
/** Get perspective projection matrix
 **/
fn Matrix perspective(double fov_y, double aspect, double near_plane, double far_plane) {
	Matrix result = {};

	double top    =  near_plane * math::tan((fov_y * 0.5));
	double bottom = -top;
	double right  =  top * aspect;
	double left   = -right;

	//* MatrixFrustum(-right, right, -top, top, near, far);
	float rl  = (float)(right - left);
	float tb  = (float)(top - bottom);
	float f_n = (float)(far_plane - near_plane);

	result.m0  =  ((float)near_plane * 2.0) / rl;
	result.m5  =  ((float)near_plane * 2.0) / tb;
	result.m8  =  (float)(right + left) / rl;
	result.m9  =  (float)(top + bottom) / tb;
	result.m10 = -(float)(far_plane + near_plane) / f_n;
	result.m11 = -1;
	result.m14 = -(float)(far_plane * near_plane * 2) / f_n;

	return result;
}
/** Get orthographic projection matrix
 **/
fn Matrix ortho(double left, double right, double bottom, double top, double near_plane, double far_plane) {
	Matrix result = ZERO;

	float rl  = (float)(right - left);
	float tb  = (float)(top - bottom);
	float f_n = (float)(far_plane - near_plane);

	result.m0  =  2 / rl;
	result.m1  =  0;
	result.m2  =  0;
	result.m3  =  0;
	result.m4  =  0;
	result.m5  =  2 / tb;
	result.m6  =  0;
	result.m7  =  0;
	result.m8  =  0;
	result.m9  =  0;
	result.m10 = -2 / f_n;
	result.m11 =  0;
	result.m12 = -(float)(left + right) / rl;
	result.m13 = -(float)(top + bottom) / tb;
	result.m14 = -(float)(far_plane + near_plane) / f_n;
	result.m15 =  1;

	return result;
}
/** Get camera look-at matrix (view matrix)
 **/
fn Matrix look_at(Vector3 eye, Vector3 target, Vector3 up) {
	Matrix result = {};

	float length;
	float ilength;

	Vector3 vz = eye.sub(target);

	//* Vector3Normalize(vz)
	Vector3 v = vz;
	length = v.length();
	if (length == 0) { length = 1; }
	ilength = 1 / length;
	vz.x *= ilength;
	vz.y *= ilength;
	vz.z *= ilength;

	//* Vector3CrossProduct(up, vz)
	Vector3 vx = up.cross_product(vz);

	//* Vector3Normalize(x)
	v = vx;
	length = v.length();
	if (length == 0) { length = 1; }
	ilength = 1 / length;
	vx.x *= ilength;
	vx.y *= ilength;
	vx.z *= ilength;

	//* Vector3CrossProduct(vz, vx)
	Vector3 vy = vz.cross_product(vx);

	result.m0  =  vx.x;
	result.m1  =  vy.x;
	result.m2  =  vz.x;
	result.m3  =     0;
	result.m4  =  vx.y;
	result.m5  =  vy.y;
	result.m6  =  vz.y;
	result.m7  =     0;
	result.m8  =  vx.z;
	result.m9  =  vy.z;
	result.m10 =  vz.z;
	result.m11 =     0;
	result.m12 = -(vx.x * eye.x + vx.y * eye.y + vx.z * eye.z);   //* Vector3DotProduct(vx, eye)
	result.m13 = -(vy.x * eye.x + vy.y * eye.y + vy.z * eye.z);   //* Vector3DotProduct(vy, eye)
	result.m14 = -(vz.x * eye.x + vz.y * eye.y + vz.z * eye.z);   //* Vector3DotProduct(vz, eye)
	result.m15 =    1;

	return result;
}



//= Quaternion module
module pleroma::quaternion;
import pleroma;
import std::math;

/** Calculate quaternion based on the rotation from one vector to another
 **/
fn pleroma::Quaternion from_v3_to_v3(Vector3 from, Vector3 to) {
	pleroma::Quaternion result = {};

	float cos2_theta = from.dot_product(to);
	Vector3 cross = from.cross_product(to);

	result = {
		.x = cross.x,
		.y = cross.y,
		.z = cross.z,
		.w = 1 + cos2_theta,
	};

	float len = result.length();
	if (len == 0) { len = 1; }
	float ilen = 1 / len;

	return {
		.x = result.x * ilen,
		.y = result.y * ilen,
		.z = result.z * ilen,
		.w = result.w * ilen,
	};
}
/** Get rotation quaternion for an angle and axis
 **/
fn pleroma::Quaternion quaternion_from_axis_angle(Vector3 axis, float angle) {
	pleroma::Quaternion result = {}; //Matrix.identity()

	float axis_len = axis.length();

	if (axis_len != 0) {
		float new_angle = angle * 0.5;

		float len = axis_len;
		if (len == 0) { len = 1; }
		float ilen = 1 / len;

		Vector3 new_axis = {
			.x = axis.x * ilen,
			.y = axis.y * ilen,
			.z = axis.z * ilen,
		};

		float sinres = math::sin(new_angle);
		float cosres = math::cos(new_angle);

		result.x = new_axis.x * sinres;
		result.y = new_axis.y * sinres;
		result.z = new_axis.z * sinres;
		result.w = cosres;

		len = result.length();
		if (len == 0) { len = 1; }
		ilen = 1 / len;

		result.x = result.x * ilen;
		result.y = result.y * ilen;
		result.z = result.z * ilen;
		result.w = result.w * ilen;
	}

	return result;
}
/** Get the quaternion equivalent to Euler angles
 **/
fn pleroma::Quaternion from_euler(float pitch, float yaw, float roll) {
	pleroma::Quaternion result = {};

	float x0 = math::cos((float)(pitch * 0.5));
	float x1 = math::sin((float)(pitch * 0.5));
	float y0 = math::cos((float)(yaw   * 0.5));
	float y1 = math::sin((float)(yaw   * 0.5));
	float z0 = math::cos((float)(roll  * 0.5));
	float z1 = math::sin((float)(roll  * 0.5));

	result.x = x1 * y0 * z0 - x0 * y1 * z1;
	result.y = x0 * y1 * z0 - x1 * y0 * z1;
	result.z = x0 * y0 * z1 - x1 * y1 * z0;
	result.w = x0 * y0 * z0 - x1 * y1 * z1;

	return result;
}
