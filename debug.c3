
module pleroma::debug;
import std::collections;
import std::io;
import raylib;
import pleroma::color;
import pleroma::camera;


/** Error structure for displaying errors on screen
 **/
struct PlError {
	String text;
	PlErrorLevel level;
	
	int lifespan;
}

/** Error levels
 **/
enum PlErrorLevel {
	NONE,
	LOW,
	MID,
	HIGH,
	CRITICAL,
}


const int LOGTIMER_DEF = 200;


bool debug_state = true;
PlErrorLevel lowest = NONE;
List(<PlError*>) error_list;

/** Error logging
 @param desc "Description of the error"
 @param level "How problematic the error is"
 @param args "Any additional info that can be supplied"
 **/
fn void log(String desc = "Default", PlErrorLevel level = NONE, args...) {
	if (level >= lowest) {
		PlError* err = mem::new(PlError);
		*err = {
			.text = string::tformat("[%s] - %s %s\0", level, desc, args),
			.level = level,
			.lifespan = LOGTIMER_DEF,
		};
		error_list.push(err);
		
		if (debug_state) { io::printfn(err.text); }
	}
}

/** 
 **/
fn void draw_debug_log() {
	List(<int>) values;
	
	
	for (int i = 0; i < error_list.len(); i++) {
		PlError* err = error_list.get(i);
		
		raylib::draw_text(err.text, 10, pleroma::render_size.height - ((i + 1) * 10), 8, color::RED);
		
		err.lifespan--;
		if (err.lifespan <= 0) { error_list.remove_at(i); }
	}
}
/** Draws debug stats
 **/
fn void draw_debug_stats() {
	int fps = raylib::get_fps();
	Vector3 cam;
	switch (camera::main.mode) {
		case CAMERA2D: cam = {camera::main.cam2d.target.x, camera::main.cam2d.target.y, 0};
		case CAMERA3D: cam = camera::main.cam3d.target;
	}
	raylib::draw_text(string::tformat("FPS: %d\nCamera: %d,%d,%d\nTextures: %d\0", fps, cam.x, cam.y, cam.z, pleroma::textures_rendered), 0, 0, 10, color::WHITE);
}
