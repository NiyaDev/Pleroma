
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
	NOT_INIT,
	NO_FILES,
	NO_ENTRY,
	HAS_ENTRY,
}
/** Settings value
 **/
struct SettingsValue {
	SettingValueType type;
	union {
		bool		as_bool;
		char		as_char;
		short		as_short;
		int			as_int;
		long		as_long;
		float		as_float;
		double		as_double;
		Vector2		as_vector2;
		Vector3		as_vector3;
		Resolution	as_resolution;
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
fn void! Settings.set(&self, String i, SettingsValue val) @operator([]=) {
	if (!((HashMap(<String,SettingsValue>)*)self).is_initialized()) {
		debug::log("Setting member without initializing");
		return SettingsFault.NOT_INIT?;
	}
	
	if (((HashMap(<String,SettingsValue>)*)self).has_key(i)) {
		debug::log("Settings missing entry", NONE, i);
		return SettingsFault.HAS_ENTRY?;
	}

	((HashMap(<String,SettingsValue>)*)self).set(i, val);

	return;
}
/** Create a new setting
 **/
fn SettingsValue*! new_setting(SettingValueType type, any value) {
	SettingsValue* output = mem::new(SettingsValue);
	*output = {
		.type = type,
	};

	switch (value.type) {
		default: debug::log("Entered a settings variable that is not a type accepted");
		case bool:			output.as_bool			= *((bool*)value);
		case char:			output.as_char			= *((char*)value);
		case short:			output.as_short			= *((short*)value);
		case int:			output.as_int			= *((int*)value);
		case long:			output.as_long			= *((long*)value);
		case float:			output.as_float			= *((float*)value);
		case double:		output.as_double		= *((double*)value);
		case Vector2:		output.as_vector2		= *((Vector2*)value);
		case Vector3:		output.as_vector3		= *((Vector3*)value);
		case Resolution:	output.as_resolution	= *((Resolution*)value);
	}

	return output;
}


/** Initialize settings
 **/
fn void! init() {
	if (pleroma::settings.is_initialized()) {
		debug::log("Attempted to initialize settings while it was already initialized");
		return SettingsFault.ALREADY_INIT?;
	}

	pleroma::settings.new_init();

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