
import std::io;
import raylib;


fn void aa_start() @test {
	set_trace_log_level(7);
	init_window(100, 100, "TESTS");
	set_target_fps(framerate);
	init_audio_device();
}

// TODO: audio.c3
// TODO: bounds.c3
// TODO: camera.c3
// TODO: color.c3

fn void zz_end() @test {
	close_audio_device();
	close_window();
}

