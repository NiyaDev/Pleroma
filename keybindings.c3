module pleroma::keybindings;


import pleroma;
import pleroma::debug;
import raylib;
import std::collections;
import std::io;


struct Keybind {
	KeyType type;
	char index;
	int key;
}
enum KeyType {
	KEYBOARD,
	MOUSE_BUTTONS,
	MOUSE_AXIS,
	GAMEPAD,
}


HashMap(<String,List(<Keybind>)>) keybindings;
/**
 * Initializes keybinds system
 **/
fn void init() {
	keybindings.new_init();
}
/**
 * Adds input keybind in list of binds
 **/
fn void add(String key, Keybind value) {
	if (!keybindings.is_initialized()) {
		debug::log(KEYBIND_NOT_INIT);
		return;
	}
	
	if (keybindings.has_key(key)) {
		if (try val = keybindings.get_ref(key)) {
			val.push(value);
		}
	} else {
		List(<Keybind>) list;
		list.push(value);
		keybindings.set(key, list);
	}
}
/**
 * Gets whether the input key has been pressed once or axis is not currently zero
 **/
fn bool pressed(String key) {
	if (!keybindings.is_initialized()) {
		debug::log(KEYBIND_NOT_INIT);
		return false;
	}
	if (try value = keybindings[key]) {
		foreach(index, val : value) {
			if (raylib::is_key_pressed(val.key)) { return true; }
		}
		return false;
	} else {
		debug::log(KEYBIND_NO_ENTRY);
		return false;
	}
}
/**
 * Prints the contents of the keybindings map
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
/**
 * Create a new KeybindBulk file for saving
 **/
fn KeybindBulk* new_bulk(String key, Keybind value) {
	KeybindBulk kb_b = { key, value };
	
	KeybindBulk* result = malloc($sizeof(kb_b));
	*result = kb_b;
	
	return result;
}