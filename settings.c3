module pleroma::settings;
import std::collections;
import std::io;
import pleroma;
import pleroma::debug;


/** Settings structure
 **/
distinct Settings = HashMap(<String,SettingsValue>);
/** Faults
 **/
fault SettingsFault {
	ALREADY_INIT,
	NO_FILES,
	NO_ENTRY,
	HAS_ENTRY,
}
/** Settings value
 **/
struct SettingsValue {
	SettingValueType type;
	union {
		bool bl;
		char by;
		short sh;
		int in;
		long lo;
		float fl;
		double du;
		Vector2 v2;
		Vector3 v3;
		Resolution re;
	}
}
/** Value types
 **/
enum SettingValueType {
	NONE,
	BOOL,
	BYTE,
	SHORT,
	INT,
	LONG,
	FLOAT,
	DOUBLE,
	VECTOR2,
	VECTOR3,
	RESOLUTION,
}


/** Initialize settings
 **/
fn void! Settings.init(&self) {
	if (((HashMap(<String,SettingsValue>)*)self).is_initialized()) {
		debug::log("Attempted to initialize settings while it was already initialized");
		return SettingsFault.ALREADY_INIT?;
	}

	((HashMap(<String,SettingsValue>)*)self).new_init();

	//* Checks for Saved keybinds
	if (file::is_file("resources/sav_st.blk")) {
		Bulk* kb_bulk = bulk::load("resources/sav_st.blk", DEFLATE);
		debug::log("Loaded saved settings file.");
		return;
	}

	//* Checks for Default keybinds
	if (file::is_file("resources/def_st.blk")) {
		Bulk* kb_bulk = bulk::load("resources/def_st.blk", DEFLATE);
		debug::log("Loaded default settings file.");
		return;
	}

	//* Return error
	debug::log("Failed to find saved or default settings file.", LOW);
	return SettingsFault.NO_FILES?;
}
/** Get member
 @param i "Key for entry"
 **/
fn SettingsValue! Settings.get(&self, String i) @operator([]) {
	if (!((HashMap(<String,SettingsValue>)*)self).has_key(i)) {
		debug::log("Settings missing entry", NONE, i);
		return SettingsFault.NO_ENTRY?;
	}

	return self.get(i);
}
/** Set member
 @param i "Key for entry"
 @param val "Value for entry"
 **/
fn void Settings.set(&self, String i, SettingsValue val) @operator([]=) {
	if (((HashMap(<String,SettingsValue>)*)self).has_key(i)) {
		debug::log("Settings missing entry", NONE, i);
	//	return SettingsFault.HAS_ENTRY?;
	}

	return self.set(i, val);
}
/** Create a new setting
 **/
fn SettingsValue*! new_setting(SettingValueType type, any value) {
	SettingsValue* output = malloc(SettingsValue.sizeof);
	*output = {
		.type = type,
	};

	switch (value.type) {
		default:
		case bool: output.bl = *((bool*)value);
	}

	return output;
}
