module tests;


import pleroma;
import pleroma::keybindings;
import raylib;
import std::io;

fn int main(String[] args) {
	pleroma::init(
		.title = "Testing",
		.render_res = {640, 360},
		.debug_mode = true,
		.debug_level = NONE,
	);
	defer pleroma::close();
	
	Bulk* spr_bulk = bulk::init("sprite_new");
	(void)spr_bulk.add_image("img", image::load("resources/white_units.png"));
	//spr_bulk.save();

	//Bulk* spr_bulk = bulk::load("resources/sprite_new.blk");

	Texture* test = spr_bulk.get_image("img").texture()!!;
	//Bulk spr_bulk = bulk::open("resources/sprites.blk");
	//defer spr_bulk.close();
	
	//Sprite* spr1 = spr_bulk.get_sprite("black_units");
	//spr1.set_animation("pawn");
	//Sprite* spr2 = spr_bulk.get_sprite("white_units_");
	//spr2.set_animation("queen");
	//Sprite* spr3 = spr_bulk.get_sprite("tiles_1");

	
	//Bulk kb_bulk = bulk::open("resources/def_keybinds.blk");
	//keybindings::print();
	
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
	
	//Bulk kb_bulk = bulk::init("resources/def_keybinds.blk");
	//KeybindBulk* up_bind		= keybindings::new_bulk( .key = "up",   	.value = { .type = KEYBOARD, .index = 0, .key = 87 });
	//KeybindBulk* down_bind		= keybindings::new_bulk( .key = "down", 	.value = { .type = KEYBOARD, .index = 0, .key = 83 });
	//KeybindBulk* left_bind		= keybindings::new_bulk( .key = "left", 	.value = { .type = KEYBOARD, .index = 0, .key = 65 });
	//KeybindBulk* right_bind		= keybindings::new_bulk( .key = "right",	.value = { .type = KEYBOARD, .index = 0, .key = 68 });
	//KeybindBulk* up_bind_2		= keybindings::new_bulk( .key = "up",   	.value = { .type = KEYBOARD, .index = 0, .key = 265 });
	//KeybindBulk* down_bind_2	= keybindings::new_bulk( .key = "down", 	.value = { .type = KEYBOARD, .index = 0, .key = 264 });
	//KeybindBulk* left_bind_2	= keybindings::new_bulk( .key = "left", 	.value = { .type = KEYBOARD, .index = 0, .key = 263 });
	//KeybindBulk* right_bind_2	= keybindings::new_bulk( .key = "right",	.value = { .type = KEYBOARD, .index = 0, .key = 262 });
	//kb_bulk.add("kb_up_1",		{KEYBINDING, $sizeof(*up_bind), up_bind});
	//kb_bulk.add("kb_up_2",		{KEYBINDING, $sizeof(*up_bind_2), up_bind_2});
	//kb_bulk.add("kb_down_1",	{KEYBINDING, $sizeof(*down_bind), down_bind});
	//kb_bulk.add("kb_down_2",	{KEYBINDING, $sizeof(*down_bind_2), down_bind_2});
	//kb_bulk.add("kb_left_1",	{KEYBINDING, $sizeof(*left_bind), left_bind});
	//kb_bulk.add("kb_left_2",	{KEYBINDING, $sizeof(*left_bind_2), left_bind_2});
	//kb_bulk.add("kb_right_1",	{KEYBINDING, $sizeof(*right_bind), right_bind});
	//kb_bulk.add("kb_right_2",	{KEYBINDING, $sizeof(*right_bind_2), right_bind_2});
	//kb_bulk.save();
	
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
		
		for (int i = 0; i < (16*16); i++) {
			test.draw(48 * (i%8), 16 * (i/8), color::WHITE);
			//if (i%2 == 0 ) { spr3.set_animation("white"); }
			//else { spr3.set_animation("black"); }
			
			//spr3.drawp({32*(float)(i%8),32*(float)(i/8),32,32});
		}
		
		//spr1.drawp({0,0,32,32});
		//spr2.drawp({32,0,32,32});

		pleroma::end_drawing();
	}
	//*/
	
	return 0;
}
