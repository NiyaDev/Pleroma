
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
import pleroma::debug;
import raylib;


const char BULK_MAJOR = 1;
const char BULK_MINOR = 0;
const char BULK_PATCH = 0;


/*
	? To add a new filetype to the bulk system
	? Load, two in Save, and then getter and setter
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
}
/** Initialize a blank Bulk
 @return "Pointer to new Bulk"
 **/
fn Bulk* init(String name) {
	Bulk* result = malloc(Bulk.sizeof);
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
				//for (int j = 0; ent.data.key[j] != '\0'; j++) { offset++; }
				offset += ((KeybindBulk*)ent.data.data).key.len;
	
				//* Keybind
				offset += 1; // Type
				offset += 4; // ID
				offset += 1; // Gamepad index
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
		}
	}

	String filename = string::tformat("resources/%s.blk", self.name);
	(void)new_file.save(filename, compression);
}

/** Add file to Bulk
 @param name "Name of entry in Bulk"
 @param filename "Name of file to add to Bulk"
 **/
fn void! Bulk.add_file(&self, String name, String filename) {
	//* Checking if it already exists
	if (self.entries.has_key(name)) {
		debug::log("Attempted to replace a bulk entry.", LOW);
		return BulkFault.ENTRY_EXISTS?;
	}

	File! f = file::open(filename, "rb");
	if (catch f) {
		debug::log("File not found", LOW, filename);
		return BulkFault.FILE_NOT_FOUND?;
	}

	usz! len = file::get_size(filename);
	if (catch len) {
		debug::log("File not found", LOW);
		return BulkFault.FILE_ZERO_LENGTH?;
	}

	char[] data = allocator::alloc_array(allocator::heap(), char, len);
	usz! result = f.read(data);
	if (catch result) {
		debug::log("File not found", LOW);
		return BulkFault.FILE_FAILED_BUFFER?;
	}

	(void)f.close();

	BulkEntry entry = {
		.type = AUDIO,
		.length = data.len,
		.data = (char*)data,
	};
	self.entries.set(name, entry);
}
/** Add string to Bulk
 @param name "Name of entry in Bulk"
 @param data "String to add to Bulk"
 **/
fn void! Bulk.add_string(&self, String name, String data) {
	//* Checking if it already exists
	if (self.entries.has_key(name)) {
		debug::log("Attempted to replace a bulk entry.", LOW);
		return BulkFault.ENTRY_EXISTS?;
	}

	//* Convert String to pointer
	usz length = data.len+1;
	char* data_ptr = malloc(length);
	for (usz i = 0; i < length; i++) {
		data_ptr[i] = data[i];
	}

	BulkEntry entry = {
		.type = STRING,
		.length = length,
		.data = (void*)data_ptr,
	};
	self.entries.set(name, entry);
}
/** Retrieves string from bulk entry
 @param entry_name
 @return "String entry"
 **/
fn String! Bulk.get_string(&self, String entry_name) {
	//* Entry error checking
	BulkEntry! entry = self.entries[entry_name];
	if (catch entry) {
		debug::log("Failed to find inputted entry in Bulk.", LOW, self.name, entry_name);
		return BulkFault.ENTRY_DOESNT_EXIST?;
	}
	
	//* Get string length
	usz length = 0;
	for (int i = 0; ((char*)entry.data)[i] != '\0'; i++) { length++; }
	length++;
	
	//* Copy to actual string
	char[] result = allocator::alloc_array(allocator::heap(), char, length);
	for (int i = 0; i < length; i++) { result[i] = ((char*)entry.data)[i]; }
		
	return (String)result;
}
/** Add image to Bulk
 @param name "Name of entry in Bulk"
 @param data "Image to add to Bulk"
 **/
fn void! Bulk.add_image(&self, String name, Image* data) {
	//* Checking if it already exists
	if (self.entries.has_key(name)) {
		debug::log("Attempted to replace a bulk entry.", LOW);
		return BulkFault.ENTRY_EXISTS?;
	}

	int length = 0;
	char* mem = data.to_mem_ptr(".png", &length);
	data.unload();
	//free(mem);

	BulkEntry entry = {
		.type = IMAGE,
		.length = length,
		.data = mem,
	};
	self.entries.set(name, entry);
}
/** Retrieves image from bulk entry
 @param entry_name
 @return "Image entry"
 **/
fn Image*! Bulk.get_image(&self, String entry_name) {
	//* Entry error checking
	BulkEntry! entry = self.entries[entry_name];
	if (catch entry) {
		debug::log("Failed to find inputted entry in Bulk.", LOW, self.name, entry_name);
		return BulkFault.ENTRY_DOESNT_EXIST?;
	}

	return image::load_mem_ptr(".png", entry.data, entry.length);
}
/** Add audio to Bulk
 @param name "Name of entry in Bulk"
 @param data "DRaw data to add to Bulk"
 **/
fn void! Bulk.add_audio(&self, String name, char[] data) {
	//* Checking if it already exists
	if (self.entries.has_key(name)) {
		debug::log("Attempted to replace a bulk entry.", LOW);
		return BulkFault.ENTRY_EXISTS?;
	}

	BulkEntry entry = {
		.type = AUDIO,
		.length = data.len,
		.data = (char*)data,
	};
	self.entries.set(name, entry);
}
/** Retrieves audio from bulk entry as Music
 @param entry_name
 @return "Music"
 **/
fn Music*! Bulk.get_music(&self, String entry_name) {
	//* Entry error checking
	BulkEntry! entry = self.entries[entry_name];
	if (catch entry) {
		debug::log("Failed to find inputted entry in Bulk.", LOW, self.name, entry_name);
		return BulkFault.ENTRY_DOESNT_EXIST?;
	}

	return music::load_mem(".mp3", entry.data, (int)entry.length);
}
/** Retrieves audio from bulk entry as Sound
 @param entry_name
 @return "Sound"
 **/
fn Sound*! Bulk.get_sound(&self, String entry_name) {
	//* Entry error checking
	BulkEntry! entry = self.entries[entry_name];
	if (catch entry) {
		debug::log("Failed to find inputted entry in Bulk.", LOW, self.name, entry_name);
		return BulkFault.ENTRY_DOESNT_EXIST?;
	}

	Wave* wave = wave::load_mem(".mp3", entry.data, (int)entry.length)!!;
	Sound* output = wave.sound()!!;
	wave.unload();
	return output;
}
/** Add keybinding to Bulk
 @param name "Name of entry in Bulk"
 @param data "Keybind to add to Bulk"
 **/
fn void! Bulk.add_keybinding(&self, String name, KeybindBulk* data) {
	//* Checking if it already exists
	if (self.entries.has_key(name)) {
		debug::log("Attempted to replace a bulk entry.", LOW);
		return BulkFault.ENTRY_EXISTS?;
	}

	BulkEntry entry = {
		.type = KEYBINDING,
		.length = KeybindBulk.sizeof,
		.data = data,
	};
	self.entries.set(name, entry);
}
/** Add Sprite to bulk
 @param name "Name of entry in Bulk"
 @param data "Sprite data to add to Bulk"
 **/
fn void! Bulk.add_sprite(&self, String name, Sprite* data) {
	//* Checking if it already exists
	if (self.entries.has_key(name)) {
		debug::log("Attempted to replace a bulk entry.", LOW);
		return BulkFault.ENTRY_EXISTS?;
	}

	BulkEntry entry = {
		.type = AUDIO,
		.length = Sprite.sizeof,
		.data = data,
	};
	self.entries.set(name, entry);
}
/** Retrieves sprite from bulk entry
 @param entry_name
 @return "Sprite"
 **/
fn Sprite*! Bulk.get_sprite(&self, String entry_name) {
	//* Entry error checking
	BulkEntry! entry = self.entries[entry_name];
	if (catch entry) {
		debug::log("Failed to find inputted entry in Bulk.", LOW, self.name, entry_name);
		return BulkFault.ENTRY_DOESNT_EXIST?;
	}

	return entry.data;
}
/** Retrieves font from bulk entry
 @param entry_name
 @return "Font"
 **/
fn Font*! Bulk.get_font(&self, String entry_name) {
	//* Entry error checking
	BulkEntry! entry = self.entries[entry_name];
	if (catch entry) {
		debug::log("Failed to find inputted entry in Bulk.", LOW, self.name, entry_name);
		return BulkFault.ENTRY_DOESNT_EXIST?;
	}

	Font* output = font::load_memory(".ttf", entry.data, (int)entry.length, 16, {})!!;
	return output;
}

// TODO

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
