module tests;


import pleroma;
import pleroma::keybindings;
import raylib;
import std::io;

fn int main(String[] args) {
	pleroma::init();
	defer pleroma::close();
	
	Bulk bulk = bulk::open("resources/sprites.blk");
	Sprite* spr1 = bulk.get_sprite("black_units");
	spr1.set_animation("pawn");
	Sprite* spr2 = bulk.get_sprite("white_units");
	spr2.set_animation("queen");
	Sprite* spr3 = bulk.get_sprite("tiles_1");
	
	//Bulk bulk = bulk::init("resources/sprites.blk");
	//Sprite* black_units = sprite::from_file("resources/black_units.png");
	//black_units.new_animation("pawn", {0});
	//black_units.new_animation("rook", {1});
	//black_units.new_animation("knight", {2});
	//black_units.new_animation("bishop", {3});
	//black_units.new_animation("queen", {4});
	//black_units.new_animation("king", {5});
	//Sprite* white_units = sprite::from_file("resources/white_units.png");
	//white_units.new_animation("pawn", {0});
	//white_units.new_animation("rook", {1});
	//white_units.new_animation("knight", {2});
	//white_units.new_animation("bishop", {3});
	//white_units.new_animation("queen", {4});
	//white_units.new_animation("king", {5});
	//Sprite* border_1 = sprite::from_file("resources/border_1.png");
	//Sprite* tiles_1 = sprite::from_file("resources/tiles_1.png");
	//tiles_1.new_animation("black", {0});
	//tiles_1.new_animation("white", {1});
	//bulk.add("black_units", {SPRITE, $sizeof(*black_units), black_units});
	//bulk.add("white_units", {SPRITE, $sizeof(*white_units), white_units});
	//bulk.add("border_1", {SPRITE, $sizeof(*border_1), border_1});
	//bulk.add("tiles_1", {SPRITE, $sizeof(*tiles_1), tiles_1});
	//bulk.save();
	
	
	//keybindings::add("test", KeyType.KEYBOARD, 87);
	
	while (!raylib::window_should_close()) {
		pleroma::begin_drawing();
		
		for (int i = 0; i < (8*8); i++) {
			if (i%2 == 0 ) { spr3.set_animation("white"); }
			else { spr3.set_animation("black"); }
			
			spr3.drawp({32*(float)(i%8),32*(float)(i/8),32,32});
		}
		
		spr1.drawp({0,0,32,32});
		spr2.drawp({32,0,32,32});

		pleroma::end_drawing();
	}
	
	return 0;
}
