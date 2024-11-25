
module pleroma::keybindings;
import pleroma;
import pleroma::debug;
import raylib;
import std::collections;
import std::io;


/** Keybind structure
 **/
struct Keybind {
	KeyType type;
	char index;
	int key;
}
enum KeyType {
	KEYBOARD,
	MOUSE_BUTTONS,
	MOUSE_AXIS,
	GAMEPAD_BUTTONS,
	GAMEPAD_AXIS,
}
fault KeybindFault {
	UNKNOWN,
	NO_KEYBINDS,
	NOT_INIT,
	NO_KEYBIND,
	GAMEPAD_NOT_CONNECTED,
}


bool kb_initialized = false;
HashMap(<String,List(<Keybind>)>) keybindings;
float deadzone = 0;


/** Initializes keybinds system
 **/
fn void! init() {
	keybindings.new_init();
	
	//* Checks for Saved keybinds
	if (file::is_file("resources/sav_kb.blk")) {
		Bulk* kb_bulk = bulk::load("resources/sav_kb.blk", DEFLATE);
		debug::log("Loaded saved keybindings file.");
		return;
	}

	//* Checks for Default keybinds
	if (file::is_file("resources/def_kb.blk")) {
		Bulk* kb_bulk = bulk::load("resources/def_kb.blk", DEFLATE);
		debug::log("Loaded default keybindings file.");
		return;
	}
	
	//* Return error
	debug::log("Failed to find saved or default keybindings file.", LOW);
	return KeybindFault.NO_KEYBINDS?;
}
/** Adds input keybind in list of binds
 @param key "Name of the keybind in the hashmap"
 @param value "Keybind itself"
 **/
fn void! add(String key, Keybind value) {
	//* Check if keybinds have been initialized
	if (!keybindings.is_initialized()) {
		debug::log("Attempted to use keybinds without initializing.", MID);
		return KeybindFault.NOT_INIT?;
	}
	
	//* If key already exists, add keybind to list. Else just add normally.
	if (keybindings.has_key(key)) {
		if (try val = keybindings.get_ref(key)) val.push(value);
	} else {
		List(<Keybind>) list;
		list.push(value);
		keybindings.set(key, list);
	}
}
/** Gets whether the input key has been pressed once or axis is not currently zero
 @param key "Key to see if pressed"
 **/
fn bool! pressed(String key) {
	if (!keybindings.is_initialized()) {
		debug::log("Attempted to use keybinds without initializing.", MID);
		return KeybindFault.NOT_INIT?;
	}
	
	List(<Keybind>)! value = keybindings[key];
	if (catch value) {
		debug::log("No keybinding for entry.");
		return KeybindFault.NO_KEYBIND?;
	}
	
	foreach(index, val : value) {
		switch (val.type) {
			case KEYBOARD:
				return raylib::is_key_pressed(val.key);
			case MOUSE_BUTTONS:
				return raylib::is_mouse_button_pressed(val.key);
			case MOUSE_AXIS:
				switch (val.key) {
					default: debug::log("Invalid key value.", NONE, val.key);
					case 0: if (raylib::get_mouse_x() > deadzone || raylib::get_mouse_x() < -deadzone) { return true; }
					case 1: if (raylib::get_mouse_y() > deadzone || raylib::get_mouse_y() < -deadzone) { return true; }
				}
			case GAMEPAD_BUTTONS:
				if (!raylib::is_gamepad_available(val.index)) {
					debug::log("Selected gamepad not connected.", LOW, val.index);
					return KeybindFault.GAMEPAD_NOT_CONNECTED?;
				}
				return raylib::is_gamepad_button_pressed(val.index, val.key);
			case GAMEPAD_AXIS:
				if (!raylib::is_gamepad_available(val.index)) {
					debug::log("Selected gamepad not connected.", LOW, val.index);
					return KeybindFault.GAMEPAD_NOT_CONNECTED?;
				}
				float movement = raylib::get_gamepad_axis_movement(val.index, val.key);
				if (movement > deadzone || movement < -deadzone) { return true; }
		}
	}
	
	return KeybindFault.UNKNOWN?;
}
/** Gets whether the input key is pressed or axis is not currently zero
 @param key "Key to see if down"
 **/
fn bool! down(String key) {
	if (!keybindings.is_initialized()) {
		debug::log("Attempted to use keybinds without initializing.", MID);
		return KeybindFault.NOT_INIT?;
	}
	
	List(<Keybind>)! value = keybindings[key];
	if (catch value) {
		debug::log("No keybinding for entry.");
		return KeybindFault.NO_KEYBIND?;
	}
	
	foreach(index, val : value) {
		switch (val.type) {
			case KEYBOARD:
				return raylib::is_key_down(val.key);
			case MOUSE_BUTTONS:
				return raylib::is_mouse_button_down(val.key);
			case MOUSE_AXIS:
				switch (val.key) {
					default: debug::log("Invalid key value.", NONE, val.key);
					case 0: if (raylib::get_mouse_x() > deadzone || raylib::get_mouse_x() < -deadzone) { return true; }
					case 1: if (raylib::get_mouse_y() > deadzone || raylib::get_mouse_y() < -deadzone) { return true; }
				}
			case GAMEPAD_BUTTONS:
				if (!raylib::is_gamepad_available(val.index)) {
					debug::log("Selected gamepad not connected.", LOW, val.index);
					return KeybindFault.GAMEPAD_NOT_CONNECTED?;
				}
				return raylib::is_gamepad_button_down(val.index, val.key);
			case GAMEPAD_AXIS:
				if (!raylib::is_gamepad_available(val.index)) {
					debug::log("Selected gamepad not connected.", LOW, val.index);
					return KeybindFault.GAMEPAD_NOT_CONNECTED?;
				}
				float movement = raylib::get_gamepad_axis_movement(val.index, val.key);
				if (movement > deadzone || movement < -deadzone) { return true; }
		}
	}
	
	return KeybindFault.UNKNOWN?;
}
/** Gets whether the input key has been released or axis is currently zero
 @param key "Key to see if released"
 **/
fn bool! released(String key) {
	if (!keybindings.is_initialized()) {
		debug::log("Attempted to use keybinds without initializing.", MID);
		return KeybindFault.NOT_INIT?;
	}
	
	List(<Keybind>)! value = keybindings[key];
	if (catch value) {
		debug::log("No keybinding for entry.");
		return KeybindFault.NO_KEYBIND?;
	}
	
	foreach(index, val : value) {
		switch (val.type) {
			case KEYBOARD:
				return raylib::is_key_released(val.key);
			case MOUSE_BUTTONS:
				return raylib::is_mouse_button_released(val.key);
			case MOUSE_AXIS:
				switch (val.key) {
					default: debug::log("Invalid key value.", NONE, val.key);
					case 0: if (raylib::get_mouse_x() < deadzone || raylib::get_mouse_x() > -deadzone) { return true; }
					case 1: if (raylib::get_mouse_y() < deadzone || raylib::get_mouse_y() > -deadzone) { return true; }
				}
			case GAMEPAD_BUTTONS:
				if (!raylib::is_gamepad_available(val.index)) {
					debug::log("Selected gamepad not connected.", LOW, val.index);
					return KeybindFault.GAMEPAD_NOT_CONNECTED?;
				}
				return raylib::is_gamepad_button_released(val.index, val.key);
			case GAMEPAD_AXIS:
				if (!raylib::is_gamepad_available(val.index)) {
					debug::log("Selected gamepad not connected.", LOW, val.index);
					return KeybindFault.GAMEPAD_NOT_CONNECTED?;
				}
				float movement = raylib::get_gamepad_axis_movement(val.index, val.key);
				if (movement < deadzone || movement > -deadzone) { return true; }
		}
	}
	
	return KeybindFault.UNKNOWN?;
}
/** Gets whether the input key is not pressed or axis is currently zero
 @param key "Key to see if up"
 **/
fn bool! up(String key) {
	if (!keybindings.is_initialized()) {
		debug::log("Attempted to use keybinds without initializing.", MID);
		return KeybindFault.NOT_INIT?;
	}
	
	List(<Keybind>)! value = keybindings[key];
	if (catch value) {
		debug::log("No keybinding for entry.");
		return KeybindFault.NO_KEYBIND?;
	}
	
	foreach(index, val : value) {
		switch (val.type) {
			case KEYBOARD:
				return raylib::is_key_up(val.key);
			case MOUSE_BUTTONS:
				return raylib::is_mouse_button_up(val.key);
			case MOUSE_AXIS:
				switch (val.key) {
					default: debug::log("Invalid key value.", NONE, val.key);
					case 0: if (raylib::get_mouse_x() < deadzone || raylib::get_mouse_x() > -deadzone) { return true; }
					case 1: if (raylib::get_mouse_y() < deadzone || raylib::get_mouse_y() > -deadzone) { return true; }
				}
			case GAMEPAD_BUTTONS:
				if (!raylib::is_gamepad_available(val.index)) {
					debug::log("Selected gamepad not connected.", LOW, val.index);
					return KeybindFault.GAMEPAD_NOT_CONNECTED?;
				}
				return raylib::is_gamepad_button_up(val.index, val.key);
			case GAMEPAD_AXIS:
				if (!raylib::is_gamepad_available(val.index)) {
					debug::log("Selected gamepad not connected.", LOW, val.index);
					return KeybindFault.GAMEPAD_NOT_CONNECTED?;
				}
				float movement = raylib::get_gamepad_axis_movement(val.index, val.key);
				if (movement < deadzone || movement > -deadzone) { return true; }
		}
	}
	
	return KeybindFault.UNKNOWN?;
}
/** Prints the contents of the keybindings map
 **/
fn void print() {
	io::printn("Keybindings: [");
	
	keybindings.@each(; String key, List(<Keybind>) value) {
		io::printf("\t%s:\t\t[", key);
		for (int i = 0; i < value.len(); i++) {
			io::printf("(%s, %d, %d)", value[i].type, value[i].key, value[i].index);
			if (i != value.len() - 1) { io::print(","); }
		}
		io::printn("],");
	};
	
	io::printn("]");
}



struct KeybindBulk {
	String key;
	Keybind value;
}
/** Create a new KeybindBulk file for saving
 **/
fn KeybindBulk* new_bulk(String key, Keybind value) {
	KeybindBulk* result = mem::new(KeybindBulk);
	*result = { key, value };
	
	return result;
}
