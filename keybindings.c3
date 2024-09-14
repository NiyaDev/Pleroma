module pleroma::keybindings;


import pleroma;
import pleroma::debug;
import std::collections;


struct Keybind {
	KeyType type;
	int index;
	int key;
}
enum KeyType {
	KEYBOARD,
	MOUSE_BUTTONS,
	MOUSE_AXIS,
	GAMEPAD,
}


HashMap(<String,Keybind>) keybindings;
/**
 * Initializes keybinds system
 **/
fn void init() {
	keybindings.new_init();
}
/**
 * Adds input keybind in list of binds
 **/
fn void add(String name, KeyType type, int key, int index = 0) {
	Keybind bind = {
		.type = type,
		.index = index,
		.key = key,
	};
	if (!keybindings.is_initialized()) {
		debug::log(PleromaFault.KEYBIND_NOT_INIT);
	}
	if (keybindings.has_key(name)) {
		debug::log(PleromaFault.KEYBIND_REPLACED_ENTRY, type, key, index);
	}
	
	keybindings.set(name, bind);
}