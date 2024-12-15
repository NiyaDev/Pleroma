
import std::io;
import pleroma::wave;
import pleroma::sound;
import pleroma::music;
import pleroma::camera;
import bulk;
import raylib;


fn void! aa_start() @test {
	pleroma::init(
		.title = "Testing",
		.screen_res = {100,100},
		.render_res = {100,100},
		.ignore_kb = true,
		.ignore_st = true,
	);
}
fn void! zz_end() @test {
	pleroma::close();
}

//* audiostream.c3
fn void! audiostream_wave() @test {
	//* Load Wave
	Wave* wave = wave::load("resources/New Bark Town (Lofi Remix).mp3")!!;
	defer wave.unload();
	assert(wave != null);
	assert(wave.data != null);

	//* Wave to Sound
	Sound* sound = wave.sound()!!;
	defer sound.unload();
	assert(sound != null);
	assert(sound.stream.buffer != null);
}
fn void! audiostream_sound() @test {
	//* Load Sound
	Sound* sound = sound::load("resources/New Bark Town (Lofi Remix).mp3")!!;
	defer sound.unload();
	assert(sound != null);
	assert(sound.stream.buffer != null);

	//* Alias
	Sound* sound_alias = sound.alias();
	defer sound_alias.unload_alias();
	assert(sound_alias != null);
	assert(sound_alias.ready());
}
fn void! audiostream_music() @test {
	//* Load Music
	Music* music = music::load("resources/New Bark Town (Lofi Remix).mp3")!!;
	defer music.unload();
	assert(music != null);
	assert(music.stream.buffer != null);

	//* Play
	music.play();
	music.update();
	assert(music.is_playing());
	music.stop();
}

//* camera.c3
fn void! camera() @test {
	//* 2D Camera
	camera::set_mode(CAMERA2D);
	camera::set_position({0,0,0});
	assert(camera::get_position().equals({0,0,0}));
	camera::move({1,1,1});
	assert(!camera::get_position().equals({1,1,1}));

	//* 3D camera
	camera::set_mode(CAMERA3D);
	camera::set_position({0,0,0});
	assert(camera::get_position().equals({0,0,0}));
	camera::move({1,1,1});
	assert(camera::get_position().equals({1,1,1}));
}

//* files.c3
// TODO
fn void! bulk_data() @test {
	Bulk* blk_test = bulk::init("test")!!;
	defer blk_test.close()!!;

	//* Test String
	String str = "Test";
	blk_test.add("str_test", &str)!!;
	BulkValue str_test = blk_test.get("str_test")!!;
	assert(str == str_test.as_string.data);

	//* Save and reload
	blk_test.save();
	Bulk* blk_save = bulk::init("test")!!;
	defer blk_save.close()!!;

	//* Test saved String
	BulkValue str_save = blk_save.get("str_test")!!;
	assert(str == str_save.as_string.data);
}

//* font.c3

//* image.c3

//* keybindings.c3

//* rendertexture.c3

//* settings.c3

//* sprite.c3

//* structures.c3

//* texture.c3