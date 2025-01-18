
import std::io;
import raylib;


fn void aa_start() @test {
	raylib::set_trace_log_level(NONE);
	raylib::init_window(100, 100, "TESTS");
	raylib::set_target_fps(60);
	raylib::init_audio_device();
}

// TODO: audio.c3
// TODO: bounds.c3
// TODO: camera.c3
// TODO: color.c3
// TODO: filepathlist.c3
// TODO: font.c3
// TODO: image.c3
// TODO: material.c3
// TODO: matrix.c3
// TODO: model.c3
// TODO: pixelformat.c3
// TODO: quaternion.c3
// TODO: ray.c3
// TODO: rectangle.c3
// TODO: rendertexture.c3
// TODO: shader.c3
// TODO: texture.c3
// TODO: vector2.c3
// TODO: vector3.c3
// TODO: vector4.c3
// TODO: vrinfo.c3

fn void zz_end() @test {
	raylib::close_audio_device();
	raylib::close_window();
}

