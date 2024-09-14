module tests;


import pleroma;
import pleroma::keybindings;
import raylib;
import std::io;

fn int main(String[] args) {
	pleroma::init();
	defer pleroma::close();
	
	Bulk bulk = bulk::open("resources/test2.blk");
	Sprite* spr1 = bulk.get_sprite("black_units");
	keybindings::add("test", KeyType.KEYBOARD, 87);
	
	//bulk.save("resources/test2.blk");
	
	while (!raylib::window_should_close()) {
		pleroma::begin_drawing();

		spr1.drawp({0,0,32,32});
		//spr2.drawp({32,0,32,32});

		pleroma::end_drawing();
	}
	
	return 0;
}
