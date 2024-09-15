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

enum PleromaFault : int (PlErrorLevel level, String desc) {
	GENERAL_FAILURE = {PlErrorLevel.NONE, "General error."},
	
	BULK_FAILED_FIND_ENTRY = {PlErrorLevel.LOW, "Failed to find inputted entry in Bulk."},
	BULK_ENTRY_ALREADY_EXISTS = {PlErrorLevel.LOW, "Attempted to replace a bulk entry."},
	
	KEYBIND_NOT_INIT = {PlErrorLevel.MID, "Attempted to add a keybind without initializing map."},
	KEYBIND_REPLACED_ENTRY = {PlErrorLevel.NONE, "Replaced keybind."},
	
	SPRITE_ANIMATION_DOESNT_EXIST = {PlErrorLevel.NONE, "Input animation doesn't exist."},
}

const int LOGTIMER_DEF = 200;

bool debug_state = true;
bool debug_print = true;
List(<PlError*>) error_list;
int log_timer = LOGTIMER_DEF;

/**
 * Log error
 * @param f
 * @param args
 **/
fn void log(PleromaFault f, args...) {
	PlError error = {
		.lifespan = LOGTIMER_DEF,
	};
	
	String text;
	error.text = string::tformat("[%s] - %s %s", f.level, f.desc, args);
	error.level = f.level;
	
	if (debug_print) { io::printfn(error.text); }
	
	PlError* ptr = (PlError*)malloc($sizeof(error));
	*ptr = error;
	error_list.push(ptr);
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