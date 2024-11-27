
module tests;
import pleroma;
import pleroma::keybindings;
import pleroma::music;
import pleroma::sprite;
import pleroma::settings;
import raylib;
import std::io;
import std::io::file;


fn int main(String[] args) {
	//* Bulk creation
	create_bulk();
	default_kb_bulk();
	default_st_bulk();


	//* Init pleroma
	pleroma::init(
		.title = "Testing",
	);
	defer pleroma::close();


	//* Textures
	Bulk* tex_bulk = bulk::load("resources/001.blk", DEFLATE);
	defer tex_bulk.close();

	Image* img = tex_bulk.get("tiles_1", Image.typeid)!!;
	Texture* tex = img.texture();
	Texture*[] texs = img.cut_sheet(2,1);


	//* Sprites
	Bulk* spr_bulk = bulk::load("resources/003.blk", DEFLATE);
	defer spr_bulk.close();
	Sprite* spr = spr_bulk.get("test", Sprite.typeid)!!;
	spr.set_animation("not_def")!!;
	spr.textures = texs;

	//* Audio
	Bulk* sfx_bulk = bulk::load("resources/002.blk", DEFLATE);
	defer sfx_bulk.close();

	pleroma::music = sfx_bulk.get("theme", Music.typeid)!!;
	defer pleroma::music.unload();
	pleroma::music.play();
	
	while (!raylib::window_should_close()) {
		if (keybindings::down("up")!!)    camera::main.move({ 0,-1, 0});
		if (keybindings::down("down")!!)  camera::main.move({ 0, 1, 0});
		if (keybindings::down("left")!!)  camera::main.move({-1, 0, 0});
		if (keybindings::down("right")!!) camera::main.move({ 1, 0, 0});
		
		pleroma::begin_drawing();

		texs[0].draw(0,0, color::WHITE);
		texs[1].draw(50,0, color::WHITE);
		tex.draw(100,0, color::WHITE);

		spr.draw({-100, -100});

		pleroma::end_drawing();
	}
	
	return 0;
}


fn void create_bulk() {
	Bulk* tex_bulk = bulk::init("001");
	tex_bulk.add("black_units", image::load("resources/black_units.png"))!!;
	tex_bulk.add("white_units", image::load("resources/white_units.png"))!!;
	tex_bulk.add("border_1", image::load("resources/border_1.png"))!!;
	tex_bulk.add("tiles_1", image::load("resources/tiles_1.png"))!!;
	tex_bulk.save(DEFLATE);

	Bulk* sfx_bulk = bulk::init("002");
	sfx_bulk.add_file("theme", "resources/New Bark Town (Lofi Remix).mp3", AUDIO)!!;
	sfx_bulk.save(DEFLATE);


	Bulk* spr_bulk = bulk::init("003");
	Sprite* test = sprite::new();
	test.new_animation("not_def", {0,1}, 10)!!;
	spr_bulk.add("test", test)!!;
	spr_bulk.save(DEFLATE);

	Bulk* spr_bulk_1 = bulk::init("003_1");
	Sprite* test_1 = sprite::new();
	test_1.new_animation("not_def", {0,1}, 10)!!;
	spr_bulk_1.add("test", test_1)!!;
	spr_bulk_1.save();
}

fn void default_kb_bulk() {
	Bulk* kb_bulk = bulk::init("def_kb");
	kb_bulk.add("kb_up_1", keybindings::new_bulk( .key = "up",		.value = { .type = KEYBOARD, .index = 0, .key = 87 }))!!;
	kb_bulk.add("kb_up_2", keybindings::new_bulk( .key = "up",		.value = { .type = KEYBOARD, .index = 0, .key = 265}))!!;
	kb_bulk.add("kb_down_1", keybindings::new_bulk( .key = "down",	.value = { .type = KEYBOARD, .index = 0, .key = 83 }))!!;
	kb_bulk.add("kb_down_2", keybindings::new_bulk( .key = "down",	.value = { .type = KEYBOARD, .index = 0, .key = 264}))!!;
	kb_bulk.add("kb_left_1", keybindings::new_bulk( .key = "left",	.value = { .type = KEYBOARD, .index = 0, .key = 65 }))!!;
	kb_bulk.add("kb_left_2", keybindings::new_bulk( .key = "left",	.value = { .type = KEYBOARD, .index = 0, .key = 263}))!!;
	kb_bulk.add("kb_right_1", keybindings::new_bulk( .key = "right",	.value = { .type = KEYBOARD, .index = 0, .key = 68 }))!!;
	kb_bulk.add("kb_right_2", keybindings::new_bulk( .key = "right",	.value = { .type = KEYBOARD, .index = 0, .key = 262}))!!;
	kb_bulk.save(DEFLATE);
}

fn void default_st_bulk() {
	Bulk* st_bulk = bulk::init("def_st");
	float def_value = 0.6;
	Resolution def_res = {1280,720};
	Resolution def_ren = {640,360};
	st_bulk.add("volume_master", settings::new_setting(FLOAT, &def_value))!!;
	st_bulk.add("volume_music", settings::new_setting(FLOAT, &def_value))!!;
	st_bulk.add("volume_sound", settings::new_setting(FLOAT, &def_value))!!;
	st_bulk.add("resolution_screen", settings::new_setting(RESOLUTION, &def_res))!!;
	st_bulk.add("resolution_render", settings::new_setting(RESOLUTION, &def_ren))!!;
	st_bulk.save(DEFLATE);

	Bulk* st_bulk_un = bulk::init("def_st_unflated");
	st_bulk_un.add("volume_master", settings::new_setting(FLOAT, &def_value))!!;
	st_bulk_un.add("volume_music", settings::new_setting(FLOAT, &def_value))!!;
	st_bulk_un.add("volume_sound", settings::new_setting(FLOAT, &def_value))!!;
	st_bulk_un.add("resolution_screen", settings::new_setting(RESOLUTION, &def_res))!!;
	st_bulk_un.add("resolution_render", settings::new_setting(RESOLUTION, &def_ren))!!;
	st_bulk_un.save();
}