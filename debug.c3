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
	
	GENERAL_NO_RENDER_TEXTURE = {PlErrorLevel.HIGH, "Attempted to start drawing while not having a RenderTexture."},
	
	BULK_FAILED_FIND_ENTRY = {PlErrorLevel.LOW, "Failed to find inputted entry in Bulk."},
	BULK_ENTRY_ALREADY_EXISTS = {PlErrorLevel.LOW, "Attempted to replace a bulk entry."},
	
	KEYBIND_NOT_INIT = {PlErrorLevel.MID, "Attempted to use keybinds without initializing."},
	KEYBIND_REPLACED_ENTRY = {PlErrorLevel.NONE, "Replaced keybind."},
	KEYBIND_NO_ENTRY = {PlErrorLevel.NONE, "No keybinding for entry."},
	KEYBIND_INVALID_KEY = {PlErrorLevel.NONE, "Invalid key value."},
	KEYBIND_GAMEPAD_NOT_CONNECTED = {PlErrorLevel.LOW, "Selected gamepad not connected."},
	KEYBIND_SAVE_LOADED = {PlErrorLevel.NONE, "Loaded saved keybindings file."},
	KEYBIND_DEFAULTS_LOADED = {PlErrorLevel.NONE, "Loaded default keybindings file."},
	KEYBIND_NO_FILES = {PlErrorLevel.LOW, "Failed to find saved or default keybindings file."},
	
	SPRITE_ANIMATION_DOESNT_EXIST = {PlErrorLevel.NONE, "Input animation doesn't exist."},
}

const int LOGTIMER_DEF = 200;

bool debug_state = true;
bool debug_print = true;
PlErrorLevel lowest = NONE;
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
	
	if (error.level >= lowest) {
		if (debug_print) { io::printfn(error.text); }
		
		PlError* ptr = (PlError*)malloc($sizeof(error));
		*ptr = error;
		error_list.push(ptr);
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