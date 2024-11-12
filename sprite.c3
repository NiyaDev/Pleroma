
module pleroma;
import std::collections;
import pleroma::texture;


/** Sprite structure
 **/
struct Sprite {
	Texture[] textures;
	HashMap(<String, SpriteAnimation>) animations;
}
/** Animation structure
 **/
struct SpriteAnimation {
	List(<int[]>) frames;
	int frame;
	int counter;
} 