module pleroma::debug;


import pleroma;
import raylib;
import std::io;
import std::core::string;
import std::collections;


struct PlError {
	String text;
	PlErrorLevel level;
	
	int lifespan;
}

enum PlErrorLevel {
	NONE,
	LOW,
	MID,
	HIGH,
	CRITICAL,
}

fault Images {
	FAILED_FIND_FILE,
	FAILED_GENERATE_IMAGE,
}

fault Textures {
	NOT_INITIALIZED,
}

const int LOGTIMER_DEF = 200;

bool debug_state = true;
bool debug_print = true;
PlErrorLevel lowest = NONE;
List(<PlError*>) error_list;
int log_timer = LOGTIMER_DEF;

/**
 * Error logging
 * @param desc "Description of the error"
 * @param level "How problematic the error is"
 * @param args "Any additional info that can be supplied"
 **/
fn void log(String desc = "Default", PlErrorLevel level = NONE, args...) {
	if (level >= lowest) {
		PlError* err = malloc(PlError.sizeof);
		*err = {
			.text = string::tformat("[%s] - %s %s", level, desc, args),
			.level = level,
			.lifespan = LOGTIMER_DEF,
		};
		error_list.push(err);
		
		if (debug_print) { io::printfn(err.text); }
	}
}


//= Drawing
/**
 *
 **/
fn void draw_debug_log() {
	List(<int>) values;
	
	for (int i = 0; i < error_list.len(); i++) {
		PlError* err = error_list.get(i);
		
		raylib::draw_text(err.text, 10, pleroma::data.render_size.height - ((i + 1) * 10), 8, color::RED);
		
		err.lifespan--;
		if (err.lifespan <= 0) { error_list.remove_at(i); }
	}
}


