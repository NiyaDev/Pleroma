module pleroma::sprite;


import pleroma;
import raylib;
import std::collections;
import std::io;


struct Animation {
	int* data;
	usz length;
}


struct Sprite {
	Image original;
	List(<Texture>) textures;
	Color tint;
	int dim;
	
	HashMap(<String, Animation>) animations;
	String current_animation;
	int frame;
	int timer, timer_max;
}


/**
 * Initializing a sprite using sprite from file
 * @param [&in] filename
 * @return "Sprite pointer"
 **/
fn Sprite* from_file(char* filename) {
	//* Setting defaults
	Sprite result = {
		.textures = {},
		.tint = {255,255,255,255},
		.current_animation = "default",
		.timer_max = 20,
	};
	
	//* Load spritesheet and cut up into textures
	Image sheet = raylib::load_image(filename);
	result.original = sheet;
	int width = sheet.width;
	int height = sheet.height;
	int total_textures = width / height;
	for (int i = 0; i < total_textures; i++) {
		Image dup = raylib::image_from_image(sheet, {(float)(i * height), 0, height, height});
		Texture text = raylib::load_texture_from_image(dup);
		raylib::unload_image(dup);
		result.textures.push(text);
	}
	result.dim = height;
	
	//* Creating default animation list
	result.new_animation("default", {0});
	
	//* Malloc and return
	Sprite* res_ptr = malloc($sizeof(result));
	*res_ptr = result;
	return res_ptr;
}
/**
 * Creates a new Sprite using input image, ignoring animations
 * @param img
 **/
fn Sprite* from_image(Image img) {
	//* Setting defaults
	Sprite result = {
		.textures = {},
		.tint = {255,255,255,255},
		.current_animation = "default",
		.timer_max = 20,
	};
	
	//* Load spritesheet and cut up into textures
	result.original = img;
	int width = img.width;
	int height = img.height;
	int total_textures = width / height;
	for (int i = 0; i < total_textures; i++) {
		Image dup = raylib::image_from_image(img, {(float)(i * height), 0, height, height});
		Texture text = raylib::load_texture_from_image(dup);
		raylib::unload_image(dup);
		result.textures.push(text);
	}
	result.dim = height;
	
	//* Creating default animation list
	result.new_animation("default", {0});
	
	//* Malloc and return
	Sprite* res_ptr = malloc($sizeof(result));
	*res_ptr = result;
	return res_ptr;
}

/**
 * Frees sprite
 **/
fn void Sprite.free(&self) {
	self.original.unload();
	foreach (Texture tex : self.textures) {
		tex.unload();
	}
	self.animations.free();
}

/**
 * Draws sprite at a position and updates animation progress
 * @param position
 **/
fn void Sprite.draw(&self, Vector2 position) {
	if (try current_animation = self.animations[self.current_animation]) {
		self.textures[current_animation.data[self.frame]].draw_v(position, self.tint);
	}
	
	self.timer++;
	if (self.timer >= self.timer_max) {
		self.timer = 0;
		self.frame++;
		
		usz! result = self.animations[self.current_animation].length;
		if (try result && self.frame >= result) {
			self.frame = 0;
		}
	}
}
/**
 * Draws sprite with a rectangle and updates animation progress
 * @param dst
 **/
fn void Sprite.drawp(&self, Rectangle dst) {
	if (try current_animation = self.animations[self.current_animation]) {
		self.textures[current_animation.data[self.frame]].draw_pro({0,0,self.dim,self.dim}, dst, {0,0}, 0, self.tint);
	}
	
	self.timer++;
	if (self.timer >= self.timer_max) {
		self.timer = 0;
		self.frame++;
		
		usz! result = self.animations[self.current_animation].length;
		if (try result && self.frame >= result) {
			self.frame = 0;
		}
	}
}

/**
 * Initializing a sprite using sprite from file
 * @param name
 * @param [in] input
 **/
fn void Sprite.new_animation(&self, String name, int[] input) {
	Animation ani = {
		.data = malloc($sizeof(input[0])*input.len),
		.length = input.len,
	};
	for (int i = 0; i < input.len; i++) { ani.data[i] = input[i]; }
	self.animations.set(name, ani);
}

/**
 * Sets current animation
 * @param name
 **/
fn void Sprite.set_animation(&self, String name) {
	if (self.animations.has_key(name)) {
		self.current_animation = name;
		self.frame = 0;
		self.timer = 0;
	} else {
		debug::log("Input animation doesn't exist.", NONE, name);
	}
}

/**
 * Prints info on sprite
 **/
fn void Sprite.print(&self) {
	io::print("{\n\tTextures:\n");
	foreach (t : self.textures) {
		io::print("\t\t[");
		t.print();
		io::print("]\n");
	}
	io::printf("\tcolor: [%d,%d,%d,%d]\n\n", self.tint.r, self.tint.g, self.tint.b, self.tint.a);
	
	io::printf("\tAnimations:\n");
	self.animations.@each(; String key, Animation value) {
		if (key != self.current_animation) { io::printf("\t\t%s - [", key); }
		else { io::printf("\t     >  %s - [", key); }
		for (int i = 0; i < value.length; i++) {
			io::printf("%s",value.data[i]);
			if (i != value.length - 1) io::printf(",");
		}
		io::print("]\n");
	};
	io::printf("\tFrame: %d\n\tTimer: %d/%d\n", self.frame, self.timer, self.timer_max);
	
	io::printn("}");
}
