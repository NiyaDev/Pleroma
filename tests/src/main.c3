module tests;


import pleroma;
import std::io;

fn int main(String[] args) {
	pleroma::init();
	defer pleroma::close();
	
	Bulk bulk = bulk::open("resources/testing.blk");
	Sprite* spr1 = bulk.get_sprite("black_units");
	
	while (!pleroma::window_should_close()) {
		pleroma::begin_drawing();

		spr1.drawp({0,0,32,32});
		//spr2.drawp({32,0,32,32});

		pleroma::end_drawing();
	}
	
	return 0;
}
