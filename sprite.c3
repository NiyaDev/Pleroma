
module pleroma;
import std::collections;
import std::io;
import pleroma::texture;


/** Sprite structure
 **/
struct Sprite {
	Texture*[] textures;

	HashMap(<String, SpriteAnimation*>) animations;
	String current_animation;
}
/** Animation structure
 **/
struct SpriteAnimation {
	int[] frames;
	int speed;

	int frame;
	int counter;
}
/** Sprite Faults
 **/
fault SpriteFault {
	ANIM_EXISTS,
	ANIM_DOESNT_EXIST,
}

/** Draws sprite to screen and continues animation
 @param position "Position in vector space to draw"
 @param tint "Color to tinit sprite"
 **/
fn void Sprite.draw(&self, Vector2 position, Color tint = color::WHITE) {
	SpriteAnimation* ani = self.animations[self.current_animation]!!;
	Texture* tex = self.textures[ani.frames[ani.frame]];

	tex.draw_v(position, tint);

	ani.counter += 1;
	if (ani.counter >= ani.speed) {
		ani.counter = 0;
		ani.frame += 1;
		if (ani.frame >= ani.frames.len) {
			ani.frame = 0;
		}
	}
}
/** Creates a new animation inside sprite
 @param name "Name of animation"
 @param frames "Each member points to which texture in the textures array"
 @param speed "The speed to play the animation"
 **/
fn void! Sprite.new_animation(&self, String name, int[] frames, int speed) {
	if (self.animations.has_key(name)) {
		debug::log("Animation already exists");
		return SpriteFault.ANIM_EXISTS?;
	}

	int[] new_frames = mem::new_array(int, frames.len);
	foreach (index, val : frames) new_frames[index] = frames[index];

	SpriteAnimation* ani = sprite::new_animation(new_frames, speed);
	self.animations.set(name, ani);
}
/** Sets current animations and resets previous
 @param name "Name of new animation to play"
 **/
fn void! Sprite.set_animation(&self, String name) {
	if (!self.animations.has_key(name)) {
		debug::log("Animation doesn't exist", LOW, name);
		return SpriteFault.ANIM_DOESNT_EXIST?;
	}

	self.reset_animation()!!;
	self.current_animation = name;
}
/** Reset current animation to frame 0 and counter 0
 **/
fn void! Sprite.reset_animation(&self) {
	SpriteAnimation* ani = self.animations[self.current_animation]!!;
	ani.frame = 0;
	ani.counter = 0;
}
/** 
 **/
fn Sprite* Sprite.copy(&self) {
	Sprite* output = mem::new(Sprite);
	output.animations.new_init();

	if (self.textures.ptr != null && self.textures.len > 0) {
		Texture*[] tex_arr = mem::new_array(Texture*, self.textures.len);
		foreach (index, value : self.textures) {
			Texture* tex = mem::new(Texture);
			*tex = *value;
			tex_arr[index] = tex;
		}
		output.textures = tex_arr;
	}

	self.animations.@each(; String key, SpriteAnimation* val) {
		output.new_animation(key, val.frames, val.speed)!!;
	};
	output.current_animation = self.current_animation;

	return output;
}
/** Closes sprite and frees all resources
 **/
fn void Sprite.close(&self) {
	self.animations.@each(; String key, SpriteAnimation* ani) {
		free(ani.frames);
		free(ani);
	};
	for (int i = 0; i < self.textures.len; i++) {
		self.textures[i].unload();
		free(self.textures[i]);
	}
}
/** Prints all info about Sprite
 **/
fn void Sprite.print(&self) {
	io::printn("[\n\t[");
	if (self.textures.ptr != null) {
		for (int i = 0; i < self.textures.len; i++) {
			io::print("\t\t");
			self.textures[i].print();
		}
	}
	io::printf("\t],\n\tCurrent Animation: %s", self.current_animation);
	self.animations.@each(; String key, SpriteAnimation* ani) {
		io::print("\n\t");
		if (key == self.current_animation) io::print("->");
		io::printf("\t%s: ", key);
		ani.print();
		io::printn(",");
	};
	io::printn("]");
}

/** Prints all info about SpriteAnimation
 **/
fn void SpriteAnimation.print(&self) {
	io::print("{[");
	for (int i = 0; i < self.frames.len; i++) {
		io::printf("%d", self.frames[i]);
		if (i < self.frames.len - 1) io::print(",");
	}
	io::printf("] Speed: %d, Frame: %d, Count: %d}", self.speed, self.frame, self.counter);
}



module pleroma::sprite;
import std::io;


/** Create new blank Sprite
 @return "Pointer to Sprite"
 **/
fn Sprite* new() {
	Sprite* output = mem::new(Sprite);
	output.animations.new_init();

	SpriteAnimation* ani = mem::new(SpriteAnimation);
	*ani = {};

	ani.frames = allocator::alloc_array(allocator::heap(), int, 1);
	ani.frames[0] = 0;

	ani.speed = 10;
	ani.frame = 0;
	ani.counter = 0;
	
	output.animations.set("default", ani);
	output.current_animation = "default";

	return output;
}
/** Creates a new animation
 @param frames "The frames of the animation"
 @param speed "The speed of the animation"
 @return "Pointer to Sprite Animation"
 **/
fn SpriteAnimation* new_animation(int[] frames, int speed) {
	SpriteAnimation* ani = mem::new(SpriteAnimation);
	*ani = {};
	ani.frames = frames;
	ani.speed = speed;
	ani.frame = 0;
	ani.counter = 0;

	return ani;
}