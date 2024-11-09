module tests;


import pleroma;
import pleroma::keybindings;
import pleroma::music;
import raylib;
import std::io;
import std::io::file;

fn int main(String[] args) {
	pleroma::init(
		.title = "Testing",
		.render_res = {640, 360},
		.debug_mode = true,
		.debug_level = NONE,
	);
	defer pleroma::close();

	create_bulk();
	default_kb_bulk();

	//* Sprites
	Bulk* spr_bulk = bulk::load("resources/001.blk", DEFLATE);
	defer spr_bulk.close();

	Image* img = spr_bulk.get_image("tiles_1")!!;
	Texture* tex = img.texture();
	Texture*[] texs = img.cut_sheet(2,1);

	//* Audio
	Bulk* sfx_bulk = bulk::load("resources/002.blk", DEFLATE);
	defer spr_bulk.close();

	pleroma::music = sfx_bulk.get_music("theme")!!;
	pleroma::music.play();

	
	
	
	//keybindings::add("test", KeyType.KEYBOARD, 87);

	///*

	//Texture* tex = texture::load("resources/black_units.png");
	//Texture* tex = image::load("resources/black_units.png").texture()!!;
	
	while (!raylib::window_should_close()) {
		//if (keybindings::pressed("up")) pleroma::set_render_resolution({640,360});
		//if (keybindings::pressed("down")) pleroma::set_render_resolution({1280,720});
		//if (keybindings::pressed("left")) pleroma::set_render_resolution({1920,1080});
		//if (keybindings::pressed("right")) { io::printn("right"); }
		if (keybindings::down("up"))    camera::main.move({ 0, 1, 0});
		if (keybindings::down("down"))  camera::main.move({ 0,-1, 0});
		if (keybindings::down("left"))  camera::main.move({ 1, 0, 0});
		if (keybindings::down("right")) camera::main.move({-1, 0, 0});
		//if (keybindings::down("left"))  io::printfn("Textures: %d", pleroma::textures_rendered);
		
		pleroma::begin_drawing();

		texs[0].draw(0,0, color::WHITE);
		texs[1].draw(50,0, color::WHITE);
		tex.draw(100,0, color::WHITE);
		
		//for (int i = 0; i < (16*16); i++) {
		//	test.draw(48 * (i%8), 16 * (i/8), color::WHITE);
			//if (i%2 == 0 ) { spr3.set_animation("white"); }
			//else { spr3.set_animation("black"); }
			
			//spr3.drawp({32*(float)(i%8),32*(float)(i/8),32,32});
		//}
		
		//spr1.drawp({0,0,32,32});
		//spr2.drawp({32,0,32,32});

		pleroma::end_drawing();
	}
	//*/
	
	return 0;
}


fn void create_bulk() {
	Bulk* spr_bulk = bulk::init("001");
	spr_bulk.add_image("black_units", image::load("resources/black_units.png"))!!;
	spr_bulk.add_image("white_units", image::load("resources/white_units.png"))!!;
	spr_bulk.add_image("border_1", image::load("resources/border_1.png"))!!;
	spr_bulk.add_image("tiles_1", image::load("resources/tiles_1.png"))!!;
	spr_bulk.save(DEFLATE);

	Bulk* sfx_bulk = bulk::init("002");
	sfx_bulk.add_file("theme", "resources/New Bark Town (Lofi Remix).mp3")!!;
	sfx_bulk.save(DEFLATE);
}

fn void default_kb_bulk() {
	Bulk* kb_bulk = bulk::init("def_kb");
	kb_bulk.add_keybinding("kb_up_1", keybindings::new_bulk( .key = "up",		.value = { .type = KEYBOARD, .index = 0, .key = 87 }))!!;
	kb_bulk.add_keybinding("kb_up_2", keybindings::new_bulk( .key = "up",		.value = { .type = KEYBOARD, .index = 0, .key = 265}))!!;
	kb_bulk.add_keybinding("kb_down_1", keybindings::new_bulk( .key = "down",	.value = { .type = KEYBOARD, .index = 0, .key = 83 }))!!;
	kb_bulk.add_keybinding("kb_down_2", keybindings::new_bulk( .key = "down",	.value = { .type = KEYBOARD, .index = 0, .key = 264}))!!;
	kb_bulk.add_keybinding("kb_left_1", keybindings::new_bulk( .key = "left",	.value = { .type = KEYBOARD, .index = 0, .key = 65 }))!!;
	kb_bulk.add_keybinding("kb_left_2", keybindings::new_bulk( .key = "left",	.value = { .type = KEYBOARD, .index = 0, .key = 263}))!!;
	kb_bulk.add_keybinding("kb_right_1", keybindings::new_bulk( .key = "right",	.value = { .type = KEYBOARD, .index = 0, .key = 68 }))!!;
	kb_bulk.add_keybinding("kb_right_2", keybindings::new_bulk( .key = "right",	.value = { .type = KEYBOARD, .index = 0, .key = 262}))!!;
	kb_bulk.save(DEFLATE);
}