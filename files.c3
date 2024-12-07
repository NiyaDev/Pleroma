
module pleroma::bulk;
import libc;
import std::io;
import std::collections;
import pleroma::keybindings;
import pleroma::image;
import pleroma::wave;
import pleroma::music;
import pleroma::sprite;
import pleroma::font;
import pleroma::settings;
import pleroma::debug;
import raylib;


const char BULK_MAJOR = 1;
const char BULK_MINOR = 0;
const char BULK_PATCH = 0;


/*
	? To add a new filetype to the bulk system
	? One in Load, two in Save, then one in both .get / .add
*/


/** Bulk file
 **/
struct Bulk {
	String name;
	char major, minor, patch;
	HashMap(<String, BulkEntry>) entries;
}
/** Bulk file faults
 **/
fault BulkFault {
	FILE_NOT_FOUND,
	FILE_ZERO_LENGTH,
	FILE_FAILED_BUFFER,
	ENTRY_EXISTS,
	ENTRY_DOESNT_EXIST,
	ENTRY_NOT_CORRECT_TYPE,
	ENTRY_NO_TYPE,
}
/** Initialize a blank Bulk
 @return "Pointer to new Bulk"
 **/
fn Bulk* init(String name) {
	Bulk* result = mem::new(Bulk);
	*result = {
		.name = name,
		.major = BULK_MAJOR,
		.minor = BULK_MINOR,
		.patch = BULK_PATCH,
	};
	result.entries.new_init();

	return result;
}
/** Loads bulk from file
 @param filename "Name of file to load"
 @param compression "Compression of file"
 **/
fn Bulk* load(String filename, Compression compression = NONE) {
	//* Grab name of file
	String[] name_ls = filename.split("/");
	String[] bkname = name_ls[name_ls.len-1].split(".");

	//* Create Bulk
	Bulk* self = init(bkname[0]);

	//* Create file
	BulkFile file = {};
	(void)file.init_file(filename, compression);

	//* Read Version
	self.major = file.read_8();
	self.minor = file.read_8();
	self.patch = file.read_8();

	//* Get number of entries
	char number_of_entries = file.read_8();
	usz offset = 4;

	//* Load each BulkEntry from file
	for (int i = 0; i < number_of_entries; i++) {
		usz entry_name_length = file.read_64();
		usz ptr = file.read_64();
		String entry_name = file.read_string(entry_name_length);
		
		//* Save head value and set it to data
		usz old_head = file.head;
		file.head = ptr;

		//* Create entry
		BulkEntry entry = {};
		entry.type = (BulkEntryType)file.read_8();

		//* Copy data
		switch (entry.type) {
			default: break;
			case STRING:		// 00
				entry.length = (usz)file.read_64();
				entry.data = malloc(entry.length);
				for (int j = 0; j < entry.length; j++) {
					((char*)entry.data)[j] = file.read_8();
				}
			case IMAGE:			// 01
				entry.length = (usz)file.read_64();
				entry.data = file.read_pointer(entry.length);
			case AUDIO:			// 02
				entry.length = (usz)file.read_64();
				entry.data = file.read_pointer(entry.length);
			case SPRITE:		// 03
				Sprite* spr = sprite::new();

				//* Number of animations
				usz number_of_ani = (usz)file.read_64();

				for (int k = 0; k < number_of_ani; k++) {
					//* Name of animation
					usz ani_name_len = (usz)file.read_64();
					String key = file.read_string(ani_name_len);
					//* Frames
					usz number_frames = (usz)file.read_64();
					int[] frames = allocator::alloc_array(allocator::heap(), int, number_frames);
					for (int j = 0; j < number_frames; j++) {
						frames[j] = file.read_32();
					}
					//* Speed
					usz speed = (usz)file.read_64();

					//* Compile
					SpriteAnimation* ani = sprite::new_animation(frames, (int)speed);
					spr.animations.set(key, ani);

					entry.data = spr;
				}
			case FONT:			// 04
				entry.length = (usz)file.read_64();
				entry.data = file.read_pointer(entry.length);
			case KEYBINDING:	// 21
				//* Get keybind name
				usz name_length = (usz)file.read_64();
				String name = file.read_string(name_length);
				
				//* Get keybind
				Keybind kb = {
					.type = (KeyType)file.read_8(),
					.key = file.read_32(),
					.index = file.read_8(),
				};
				
				//* add to list
				keybindings::add(name, kb)!!;
				
				//* Save
				KeybindBulk kb_b = {
					.key = name,
					.value = kb,
				};
				entry.length = $sizeof(kb_b);
				entry.data = malloc(entry.length);
				*(KeybindBulk*)entry.data = kb_b;
			case SETTING:		// 22
				SettingsValue* out = mem::new(SettingsValue);
				out.type = (SettingValueType)file.read_8();

				switch (out.type) {
					case BOOL:
						out.as_bool = (bool)file.read_8();
						file.head += (SettingsValue.sizeof - SettingValueType.sizeof - bool.sizeof);
					case BYTE:
						out.as_char = file.read_8();
						file.head += (SettingsValue.sizeof - SettingValueType.sizeof - char.sizeof);
					case SHORT:
						out.as_short = file.read_16();
						file.head += (SettingsValue.sizeof - SettingValueType.sizeof - short.sizeof);
					case INT:
						out.as_int = file.read_32();
						file.head += (SettingsValue.sizeof - SettingValueType.sizeof - int.sizeof);
					case LONG:
						out.as_long = file.read_64();
						file.head += (SettingsValue.sizeof - SettingValueType.sizeof - long.sizeof);
					case FLOAT:
						out.as_float = file.read_float();
						file.head += (SettingsValue.sizeof - SettingValueType.sizeof - float.sizeof);
					case DOUBLE:
						out.as_double = (double)file.read_64();
						file.head += (SettingsValue.sizeof - SettingValueType.sizeof - double.sizeof);
					case VECTOR2:
						out.as_vector2.x = (float)file.read_32();
						out.as_vector2.y = (float)file.read_32();
						file.head += (SettingsValue.sizeof - SettingValueType.sizeof - Vector2.sizeof);
					case VECTOR3:
						out.as_vector3.x = (float)file.read_32();
						out.as_vector3.y = (float)file.read_32();
						out.as_vector3.z = (float)file.read_32();
						file.head += (SettingsValue.sizeof - SettingValueType.sizeof - Vector3.sizeof);
					case RESOLUTION:
						out.as_resolution.width = file.read_32();
						out.as_resolution.height = file.read_32();
						file.head += (SettingsValue.sizeof - SettingValueType.sizeof - Resolution.sizeof);
					default:
						file.head += (SettingsValue.sizeof - SettingValueType.sizeof);
				}
				pleroma::settings[entry_name] = *out;
				entry.length = SettingsValue.sizeof;
				entry.data = out;
		}
		self.entries.set(entry_name, entry);
		
		//* Return head to old value
		file.head = old_head;
	}
	file.close();

	return self;
}
/** Closes Bulk
 **/
fn void Bulk.close(&self) {
	self.entries.@each(; String key, BulkEntry value) {
		switch (value.type) {
			default: free(value.data);
			case SPRITE:		// 03
				((Sprite*)value.data).close();
		}
	};
	self.entries.free();
}
/** Save Bulk to file
 **/
fn void Bulk.save(&self, Compression compression = NONE) {
	//* Building table of contents
	List(<BulkTableEntry>) table;
	self.entries.@each(; String key, BulkEntry entry) {
		BulkTableEntry table_entry = {
			.name = key,
			.data = entry,
		};
		table.push(table_entry);
	};

	//* Generate pointers for each table entry
	usz length_of_all_entries = 0;
	foreach (BulkTableEntry ent : table) { length_of_all_entries += ent.name.len; }
	
	//* Version(4) + Entries(table.len() * (StringLength(8) + Ptr(8))) + length_of_all_entries
	usz offset = 4 + (table.len() * (8 + 8)) + length_of_all_entries;
	for (int i = 0; i < table.len(); i++) {
		BulkTableEntry* ent = &table[i];
		ent.ptr = offset;
		
		//* Type
		offset++;
		switch (ent.data.type) {
			default:
			case STRING:		// 00
				char* ptr = ent.data.data;
				//* Length of string
				offset += 8;
				//* String
				for (int j = 0; ptr[j] != '\0'; j++) { offset++; }
				offset++;
			case IMAGE:			// 01
				//* Length of data
				offset += 8;
				//* Data
				offset += ent.data.length;
			case AUDIO:			// 02
				//* Length of data
				offset += 8;
				//* Data
				offset += ent.data.length;
			case SPRITE:		// 03
				Sprite* spr = (Sprite*)ent.data.data;
				
				//* Number of animations
				offset += 8;

				//* Loop through all animations
				spr.animations.@each(; String key, SpriteAnimation* ani) {
					//* Name of animation
					offset += 8;
					offset += key.len;
					//* Frames
					offset += 8;
					offset += (4 * ani.frames.len);
					//* Speed
					offset += 8;
				};
			case FONT:			// 04
				//* Length of data
				offset += 8;
				//* Data
				offset += ent.data.length;
			case KEYBINDING:	// 21
				//* Length of name
				offset += 8;
				
				//* Name
				offset += ((KeybindBulk*)ent.data.data).key.len;
	
				//* Keybind
				offset += 1; // Type
				offset += 4; // ID
				offset += 1; // Gamepad index
			case SETTING:		// 22
				//* Type
				offset += 1;

				//* Value
				offset += (SettingsValue.sizeof - SettingValueType.sizeof);
		}
	}

	BulkFile new_file = {};
	new_file.init_len(offset);

	//* Write version
	new_file.write_8(BULK_MAJOR);
	new_file.write_8(BULK_MINOR);
	new_file.write_8(BULK_PATCH);
	new_file.write_8((char)self.entries.len());

	//* Write table to file
	foreach (BulkTableEntry ent : table) {
		usz key_length = ent.name.len;
		new_file.write_64(key_length);
		new_file.write_64((ulong)ent.ptr);
		new_file.write_ptr(ent.name, key_length);
	}

	//* Write each entry to file
	foreach (BulkTableEntry ent : table) {
		//* Type
		new_file.write_8((char)ent.data.type);
		switch (ent.data.type) {
			default:
			case STRING:		// 00
				char* ptr = ent.data.data;
				
				//* Length
				usz length = 0;
				for (int j = 0; ptr[j] != '\0'; j++) { length++; }
				new_file.write_64(length+1);
				
				//* Data
				new_file.write_string(ptr);
			case IMAGE:			// 01
				new_file.write_64(ent.data.length);
				new_file.write_ptr(ent.data.data, ent.data.length);
			case AUDIO:			// 02
				new_file.write_64(ent.data.length);
				new_file.write_ptr(ent.data.data, ent.data.length);
			case SPRITE:		// 03
				Sprite* spr = (Sprite*)ent.data.data;

				//* Number of animations
				new_file.write_64(spr.animations.len());

				spr.animations.@each(; String key, SpriteAnimation* ani) {
					//* Name of animation
					new_file.write_64(key.len);
					new_file.write_string(key);
					//* Frames
					new_file.write_64(ani.frames.len);
					for (int i = 0; i < ani.frames.len; i++) {
						new_file.write_32(ani.frames[i]);
					}
					//* Speed
					new_file.write_64(ani.speed);
				};
			case FONT:			// 04
				new_file.write_64(ent.data.length);
				new_file.write_ptr(ent.data.data, ent.data.length);
			case KEYBINDING:	// 21
				KeybindBulk* kb = (KeybindBulk*)ent.data.data;
			
				//* Length of name
				new_file.write_64(kb.key.len);
				
				//* Name
				new_file.write_string(kb.key);
	
				//* Keybind
				new_file.write_8((char)kb.value.type);
				new_file.write_32(kb.value.key);
				new_file.write_8(kb.value.index);
			case SETTING:		// 22
				SettingsValue* sv = (SettingsValue*)ent.data.data;

				//* Type
				new_file.write_8((char)sv.type);
				
				//* Value
				switch (sv.type) {
					case BOOL:
						new_file.write_8((char)sv.as_bool);
						new_file.head += (SettingsValue.sizeof - SettingValueType.sizeof - bool.sizeof);
					case BYTE:
						new_file.write_8(sv.as_char);
						new_file.head += (SettingsValue.sizeof - SettingValueType.sizeof - char.sizeof);
					case SHORT:
						new_file.write_16(sv.as_short);
						new_file.head += (SettingsValue.sizeof - SettingValueType.sizeof - short.sizeof);
					case INT:
						new_file.write_32(sv.as_int);
						new_file.head += (SettingsValue.sizeof - SettingValueType.sizeof - int.sizeof);
					case LONG:
						new_file.write_64(sv.as_long);
						new_file.head += (SettingsValue.sizeof - SettingValueType.sizeof - long.sizeof);
					case FLOAT:
						new_file.write_float(sv.as_float);
						new_file.head += (SettingsValue.sizeof - SettingValueType.sizeof - float.sizeof);
					case DOUBLE:
						new_file.write_64((long)sv.as_double);
						new_file.head += (SettingsValue.sizeof - SettingValueType.sizeof - double.sizeof);
					case VECTOR2:
						new_file.write_32((int)sv.as_vector2.x);
						new_file.write_32((int)sv.as_vector2.y);
						new_file.head += (SettingsValue.sizeof - SettingValueType.sizeof - Vector2.sizeof);
					case VECTOR3:
						new_file.write_32((int)sv.as_vector3.x);
						new_file.write_32((int)sv.as_vector3.y);
						new_file.write_32((int)sv.as_vector3.z);
						new_file.head += (SettingsValue.sizeof - SettingValueType.sizeof - Vector3.sizeof);
					case RESOLUTION:
						new_file.write_32(sv.as_resolution.width);
						new_file.write_32(sv.as_resolution.height);
						new_file.head += (SettingsValue.sizeof - SettingValueType.sizeof - Resolution.sizeof);
					default:
						new_file.head += (SettingsValue.sizeof - SettingValueType.sizeof);
				}
		}
	}

	String filename = string::tformat("resources/%s.blk", self.name);
	(void)new_file.save(filename, compression);
}

/** Add file to Bulk
 @param name "Name of entry in Bulk"
 @param filename "Name of file to add to Bulk"
 **/
fn void! Bulk.add_file(&self, String name, String filename, BulkEntryType type) {
	//* Checking if it already exists
	if (self.entries.has_key(name)) {
		debug::log("Attempted to replace a bulk entry.", LOW);
		return BulkFault.ENTRY_EXISTS?;
	}

	//* Open File
	File! f = file::open(filename, "rb");
	if (catch f) {
		debug::log("File not found", LOW, filename);
		return BulkFault.FILE_NOT_FOUND?;
	}

	//* Get length of file
	usz! len = file::get_size(filename);
	if (catch len) {
		debug::log("File not found", LOW);
		return BulkFault.FILE_ZERO_LENGTH?;
	}

	//* Allocate data
	char[] data = mem::new_array(char, len);
	usz! result = f.read(data);
	if (catch result) {
		debug::log("File not found", LOW);
		return BulkFault.FILE_FAILED_BUFFER?;
	}

	//* Close file
	(void)f.close();

	BulkEntry entry = {
		.type = type,
		.length = data.len,
		.data = data,
	};
	self.entries.set(name, entry);
}
/** Add data to bulk
 @param name "Name of entry in Bulk"
 @param data "Data to add to Bulk"
 **/
fn void! Bulk.add(&self, String name, any data) {
	//* Checking if it already exists
	if (self.entries.has_key(name)) {
		debug::log("Attempted to replace a bulk entry.", LOW);
		return BulkFault.ENTRY_EXISTS?;
	}

	//* 
	BulkEntry entry;

	switch (data.type) {
		case String:
			String str = *(String*)data;
			usz length = str.len + 1;
			char* data_ptr = malloc(length);

			for (usz i = 0; i < length-2; i++) data_ptr[i] = str[i];
			data_ptr[length-1] = 0;

			entry = {
				.type = STRING,
				.length = length,
				.data = data_ptr,
			};
		case Image:
			int length = 0;
			char* mem = ((Image*)data).to_mem_ptr(".png", &length);

			((Image*)data).unload();

			entry = {
				.type = IMAGE,
				.length = length,
				.data = mem,
			};
		case char[]:
			entry = {
				.type = AUDIO,
				.length = ((char[]*)data).len,
				.data = (char[]*)data,
			};
		case KeybindBulk:
			entry = {
				.type = KEYBINDING,
				.length = KeybindBulk.sizeof,
				.data = data,
			};
		case Sprite:
			entry = {
				.type = SPRITE,
				.length = Sprite.sizeof,
				.data = data,
			};
		case SettingsValue:
			entry = {
				.type = SETTING,
				.length = SettingsValue.sizeof,
				.data = data,
			};
	}

	self.entries.set(name, entry);
}
/** Retrieves value from bulk entry
 @param name "Name of desired entry"
 @param type "Type of the desired entry"
 @return "Value"
 **/
fn void*! Bulk.get(&self, String name, typeid type) {
	//* Entry error checking
	BulkEntry! entry = self.entries[name];
	if (catch entry) {
		debug::log("Failed to find inputted entry in Bulk.", LOW, self.name, name);
		return BulkFault.ENTRY_DOESNT_EXIST?;
	}

	//* Make sure input type lines up with actual type
	switch (type) {
		case String:
			//* Ensure it's the correct type
			if (entry.type != STRING) {
				debug::log("Tried to load a non-String bulk item as a String.", LOW, name);
				return BulkFault.ENTRY_NOT_CORRECT_TYPE?;
			}
	
			//* Copy to actual string
			char[] result = mem::new_array(char, entry.length);
			for (int i = 0; i < entry.length; i++) { result[i] = ((char*)entry.data)[i]; }
		
			return (String*)&result;
		case Image:
			//* Ensure it's the correct type
			if (entry.type != IMAGE) {
				debug::log("Tried to load a non-Image bulk item as an Image.", LOW, name);
				return BulkFault.ENTRY_NOT_CORRECT_TYPE?;
			}

			return image::load_mem_ptr(".png", entry.data, entry.length);
		case Music:
			//* Ensure it's the correct type
			if (entry.type != AUDIO) {
				debug::log("Tried to load a non-Audio bulk item as Music.", LOW, name);
				return BulkFault.ENTRY_NOT_CORRECT_TYPE?;
			}

			return music::load_mem(".mp3", entry.data, (int)entry.length);
		case Sound:
			//* Ensure it's the correct type
			if (entry.type != AUDIO) {
				debug::log("Tried to load a non-Audio bulk item as a Sound.", LOW, name);
				return BulkFault.ENTRY_NOT_CORRECT_TYPE?;
			}

			Wave* wave = wave::load_mem(".mp3", entry.data, (int)entry.length)!!;
			Sound* output = wave.sound()!!;
			wave.unload();
			return output;
		case Sprite:
			//* Ensure it's the correct type
			if (entry.type != SPRITE) {
				debug::log("Tried to load a non-Sprite bulk item as a Sprite.", LOW, name);
				return BulkFault.ENTRY_NOT_CORRECT_TYPE?;
			}

			Sprite* spr = mem::new(Sprite);
			spr = ((Sprite*)entry.data).copy();
			//*spr = *((Sprite*)entry.data);

			return spr;
		case Font:
			//* Ensure it's the correct type
			if (entry.type != FONT) {
				debug::log("Tried to load a non-Font bulk item as a Font.", LOW, name);
				return BulkFault.ENTRY_NOT_CORRECT_TYPE?;
			}

			Font* output = font::load_memory(".ttf", entry.data, (int)entry.length, 16, {})!!;
			return output;
		case SettingsValue:
			//* Ensure it's the correct type
			if (entry.type != SETTING) {
				debug::log("Tried to load a non-Setting bulk item as a Setting.", LOW, name);
				return BulkFault.ENTRY_NOT_CORRECT_TYPE?;
			}

			return entry.data;
	}

	return BulkFault.ENTRY_NO_TYPE?;
}


/** Entry for bulk table
 **/
struct BulkTableEntry {
	String name;
	usz ptr;
	BulkEntry data;
}

/** Entry for bulk
 **/
struct BulkEntry {
	BulkEntryType type;
	usz length;
	void* data;
}
/** Different types of files stored in Bulk
 **/
enum BulkEntryType : char {
	STRING,
	IMAGE,	// Stored as .png
	AUDIO,	// Stored as .mp3
	SPRITE,	// Animation data only
	FONT,	// Stored as .ttf

	PADDING_5,
	PADDING_6,
	PADDING_7,
	PADDING_8,
	PADDING_9,
	PADDING_10,
	PADDING_11,
	PADDING_12,
	PADDING_13,
	PADDING_14,
	PADDING_15,
	PADDING_16,
	PADDING_17,
	PADDING_18,
	PADDING_19,
	PADDING_20,
	
	KEYBINDING,
	SETTING,
}
/** Prints bulk entry to console
 **/
fn void BulkEntry.print(&self) {
	io::printf("%s - %p", self.type, self.data);
}

/**
 **/
struct BulkFile {
	Compression compression;
	char* data;
	usz head;
	usz length;
}
/** Different compression methods
 **/
enum Compression {
	NONE,
	DEFLATE,
}
/** Initializes a new Bulk file using the desired length
 @param length "Length of file"
 @require length > 0
 **/
fn void BulkFile.init_len(&self, usz length) {
	self.data = malloc(length);
	libc::memset(self.data, 0, length);

	self.length = length;
	self.head = 0;
}
/** Initializes a new Bulk file using a saved file
 @param filename "Name of file to load"
 @param compression "Compression type"
 **/
fn void! BulkFile.init_file(&self, String filename, Compression compression = NONE) {
	io::File! file = file::open(filename, "rb");

	//* Catch File error
	if (catch file) {
		debug::log("Cannot find Bulk file", LOW, filename);
		return BulkFault.FILE_NOT_FOUND?;
	}

	//* Catch file length error
	usz! length = file::get_size(filename);
	if (catch length) {
		debug::log("Bulk file is zero length", LOW);
		return BulkFault.FILE_ZERO_LENGTH?;
	}

	//* Catch buffer copy error
	char[] buffer = allocator::alloc_array(allocator::heap(), char, length);
	usz! result = file.read(buffer);
	if (catch result) {
		debug::log("Failed to read file to buffer", LOW);
		return BulkFault.FILE_FAILED_BUFFER?;
	}

	//* Decompress data
	switch (compression) {
		case NONE:
			self.init_len(length);
			self.write_array(buffer);
		case DEFLATE: // TODO Create compression library
			int decompressed_size = 0;
			char* data = raylib::decompress(buffer, (int)length, &decompressed_size);
			self.init_len(decompressed_size);
			self.write_ptr((void*)data, decompressed_size);
	}

	(void)file.close();
	self.head = 0;
}
/** Saves bulk to inputted filename
 @param filename "Name of file to load"
 @param compression "Compression type"
 **/
fn void! BulkFile.save(&self, String filename, Compression compression = NONE) {
	io::File! file = file::open(filename, "wb");
	if (catch file) {
		debug::log("Failed to open file", LOW, filename);
		return BulkFault.FILE_NOT_FOUND?;
	}

	switch (compression) {
		case NONE:
			for (int i = 0; i < self.length; i++) {
				if (try file.write_byte(self.data[i])) {}
			}
		case DEFLATE:
			int compressed_size = 0;
			char* data = raylib::compress(self.data, (int)self.length, &compressed_size);
			for (int i = 0; i < compressed_size; i++) {
				if (try file.write_byte(data[i])) {}
			}
	}

	(void)file.close();
	self.close();
}
/** Closes bulk file
 **/
fn void BulkFile.close(&self) {
	free(self.data);
}

/** Writes inputted byte to the bulkfile at the head
 @param input "Byte to write"
 **/
fn void BulkFile.write_8(&self, char input) {
	self.data[self.head++] = input;
}
/** Writes inputted int to the bulkfile at the head
 @param input "Short to write"
 **/
fn void BulkFile.write_16(&self, short input) {
	self.data[self.head++] = (char)(input >>  0);
	self.data[self.head++] = (char)(input >>  8);
}
/** Writes inputted int to the bulkfile at the head
 @param input "Int to write"
 **/
fn void BulkFile.write_32(&self, int input) {
	self.data[self.head++] = (char)(input >>  0);
	self.data[self.head++] = (char)(input >>  8);
	self.data[self.head++] = (char)(input >> 16);
	self.data[self.head++] = (char)(input >> 24);
}
/** Writes inputted long to the bulkfile at the head
 @param input "Long to write"
 **/
fn void BulkFile.write_64(&self, long input) {
	self.data[self.head++] = (char)(input >>  0);
	self.data[self.head++] = (char)(input >>  8);
	self.data[self.head++] = (char)(input >> 16);
	self.data[self.head++] = (char)(input >> 24);
	self.data[self.head++] = (char)(input >> 32);
	self.data[self.head++] = (char)(input >> 40);
	self.data[self.head++] = (char)(input >> 48);
	self.data[self.head++] = (char)(input >> 56);
}
/** Writes inputted float to the bulkfile at the head
 @param input "Float to write"
 **/
fn void BulkFile.write_float(&self, float input) {
	float* fl = mem::new(float);
	*fl = input;

	self.data[self.head++] = *((char*)fl);
	self.data[self.head++] = *(((char*)fl)+1);
	self.data[self.head++] = *(((char*)fl)+2);
	self.data[self.head++] = *(((char*)fl)+3);
}
/** Writes contents of inputted ptr to the bulkfile at the head
 @param ptr "Pointer to data to write"
 @require ptr != null
 @param length "Amount to copy from data"
 @require length > 0
 **/
fn void BulkFile.write_ptr(&self, void* ptr, usz length) {
	for (int i = 0; i < length; i++) {
		self.data[self.head + i] = ((char*)ptr)[i];
	}
	self.head += length;
}
/** Writes contents of inputted array to the bulkfile at the head
 @param array "Array to write"
 **/
fn void BulkFile.write_array(&self, char[] array) {
	for (int i = 0; i < array.len; i++) {
		self.data[self.head + i] = array[i];
	}
	self.head += array.len;
}
/** Writes contents of inputted null-terminated string to the bulkfile at the head
 @param str "String to write"
 @require str != null
 **/
fn void BulkFile.write_string(&self, char* str) {
	int length = 0;
	for (int i = 0; str[i] != '\0'; i++) {
		self.data[self.head + i] = ((char*)str)[i];
		length++;
	}
	self.head += length;
}

/** Reads byte from the bulkfile at the head, moving it forward
 @return "Char read"
 **/
fn char BulkFile.read_8(&self) {
	char result = self.data[self.head];
	self.head++;
	return result;
}
/** Reads short from the bulkfile at the head, moving it forward
 @return "Short read"
 **/
fn short BulkFile.read_16(&self) {
	short result = self.data[self.head] + ((long)self.data[self.head + 1] <<  8);
	self.head += 2;
	return result;
}
/** Reads int from the bulkfile at the head, moving it forward
 @return "Int read"
 **/
fn int BulkFile.read_32(&self) {
	int result = self.data[self.head]
		+ ((long)self.data[self.head + 1] <<  8)
		+ ((long)self.data[self.head + 2] << 16)
		+ ((long)self.data[self.head + 3] << 24);
	self.head += 4;
	return result;
}
/** Reads long from the bulkfile at the head, moving it forward
 @return "Long read"
 **/
fn long BulkFile.read_64(&self) {
	long result = self.data[self.head]
		+ ((long)self.data[self.head + 1] <<  8)
		+ ((long)self.data[self.head + 2] << 16)
		+ ((long)self.data[self.head + 3] << 24)
		+ ((long)self.data[self.head + 4] << 32)
		+ ((long)self.data[self.head + 5] << 40)
		+ ((long)self.data[self.head + 6] << 48)
		+ ((long)self.data[self.head + 7] << 56);
	self.head += 8;
	return result;
}
/** Reads float from the bulkfile at the head, moving it forward
 @return "Float read"
 **/
fn float BulkFile.read_float(&self) {
	float* result = (float*)&self.data[self.head];
	self.head += 4;
	return *result;
}
/** Reads string from the bulkfile at the head, moving it forward
 @require length > 0
 @return "String read"
 **/
fn String BulkFile.read_string(&self, usz length) {
	char[] result = allocator::alloc_array(allocator::heap(), char, length);
	for (int i = 0; i < length; i++) {
		result[i] = self.data[self.head + i];
	}
	
	self.head += length;
	
	return (String)result;
}
/** Read data at pointer to array
 @param length "Amount of data to copy"
 @return "Array of copied data"
 **/
fn char[] BulkFile.read_array(&self, usz length) {
	char[] result = allocator::alloc_array(allocator::heap(), char, length);

	for (int i = 0; i < length; i++) {
		result[i] = self.data[self.head++];
	}

	return result;
}
/** Read data at pointer to a pointer
 @param length "Amount of data to copy"
 @return "Array of copied data"
 **/
fn char* BulkFile.read_pointer(&self, usz length) {
	char* result = malloc(length);

	for (int i = 0; i < length; i++) {
		result[i] = self.data[self.head++];
	}

	return result;
}
/** Gets a pointer to where the head is in the data
 @return "Data from pointer"
 **/
fn void* BulkFile.get_cur_ptr(&self) {
	return self.data + self.head;
}
