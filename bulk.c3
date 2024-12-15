
module bulk;
import std::io;
import std::collections;
import pleroma::debug;
import raylib;


const char MAJOR = 1;
const char MINOR = 0;
const char PATCH = 0;


/** Bulk
 **/
struct Bulk {
	String name;
	char major, minor, patch;
	HashMap(<String, BulkValue>) entries;
}
/** Initialize a blank bulkfile
 **/
fn Bulk*! init(String name) {
	Bulk* result = mem::new(Bulk);
	*result = {
		.name = name,
		.major = MAJOR,
		.minor = MINOR,
		.patch = PATCH,
	};
	result.entries.new_init();

	return result;
}
/** Load a Bulk from file
 **/
fn Bulk*! load(String filename, Compression compression = NONE) {
	//* Grab name of file
	String[] name_ls = filename.split("/");
	String[] bkname = name_ls[name_ls.len-1].split(".");

	//* Create Bulk
	Bulk* result = init(bkname[0])!!;

	//* Create file
	BulkFile* file = file::load(filename, compression)!!;

	//* Read Version
	result.major = file.read_8();
	result.minor = file.read_8();
	result.patch = file.read_8();

	// TODO: Create seperate functions for different versions

	//* Get number of entries
	char number_of_entries = file.read_8();
	usz offset = 4;

	//* Load each BulkEntry from file
	for (int i = 0; i < number_of_entries; i++) {
		//* Get name
		usz entry_name_length = file.read_64();
		usz ptr = file.read_64();
		String entry_name = file.read_string(entry_name_length);

		//* Save head value and set it to data
		usz old_head = file.head;
		file.head = ptr;

		//* Copy data
		result.entries.set(entry_name, file.copydata()!!);

		//* Return head to old value
		file.head = old_head;
	}

	return result;
}
/** Close Bulk
 TODO:
 **/
fn void! Bulk.close(&self) {

}
/** Save Bulk to file
 **/
fn void Bulk.save(&self, Compression compression = NONE) {
	//* Building table of contents
	List(<BulkTableEntry>) table;
	self.entries.@each(; String key, BulkValue val) {
		BulkTableEntry table_entry = {
			.name = key,
			.val = val,
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
		switch (ent.val.as_def.type) {
			default:
			case STRING:		// 00
				String str = ent.val.as_string.data;
				//* Length of string
				offset += 8;
				//* String
				io::printf("%d - ",offset);
				offset += str.len;
				//for (int j = 0; str[j] != '\0'; j++) { offset++; }
				//offset++;
				io::printf("%d\n",offset);
			case IMAGE:			// 01
				//* Length of data
				//offset += 8;
				//* Data
				//offset += ent.data.length;
			case AUDIO:			// 02
				//* Length of data
				//offset += 8;
				//* Data
				//offset += ent.data.length;
			case SPRITE:		// 03
				//Sprite* spr = (Sprite*)ent.data.data;
				
				//* Number of animations
				//offset += 8;

				//* Loop through all animations
				//spr.animations.@each(; String key, SpriteAnimation* ani) {
				//	//* Name of animation
				//	offset += 8;
				//	offset += key.len;
				//	//* Frames
				//	offset += 8;
				//	offset += (4 * ani.frames.len);
				//	//* Speed
				//	offset += 8;
				//};
			case FONT:			// 04
				//* Length of data
				//offset += 8;
				//* Data
				//offset += ent.data.length;
			case KEYBINDING:	// 21
				//* Length of name
				//offset += 8;
				
				//* Name
				//offset += ((KeybindBulk*)ent.data.data).key.len;
	
				//* Keybind
				//offset += 1; // Type
				//offset += 4; // ID
				//offset += 1; // Gamepad index
			case SETTING:		// 22
				//* Type
				//offset += 1;

				//* Value
				//offset += (SettingsValue.sizeof - SettingValueType.sizeof);
		}
	}

	BulkFile* new_file = file::init(offset, compression)!!;
	defer new_file.unload()!!;

	//* Write version
	new_file.write_8(MAJOR);
	new_file.write_8(MINOR);
	new_file.write_8(PATCH);
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
		new_file.write_8((char)ent.val.as_def.type);
		switch (ent.val.as_def.type) {
			default:
			case STRING:		// 00
				String str = ent.val.as_string.data;
				//* Length
				new_file.write_64((long)str.len);
				//* Data
				new_file.write_string(str);
			case IMAGE:			// 01
				//new_file.write_64(ent.data.length);
				//new_file.write_ptr(ent.data.data, ent.data.length);
			case AUDIO:			// 02
				//new_file.write_64(ent.data.length);
				//new_file.write_ptr(ent.data.data, ent.data.length);
			case SPRITE:		// 03
				//Sprite* spr = (Sprite*)ent.data.data;

				//* Number of animations
				//new_file.write_64(spr.animations.len());

				//spr.animations.@each(; String key, SpriteAnimation* ani) {
				//	//* Name of animation
				//	new_file.write_64(key.len);
				//	new_file.write_string(key);
				//	//* Frames
				//	new_file.write_64(ani.frames.len);
				//	for (int i = 0; i < ani.frames.len; i++) {
				//		new_file.write_32(ani.frames[i]);
				//	}
				//	//* Speed
				//	new_file.write_64(ani.speed);
				//};
			case FONT:			// 04
				//new_file.write_64(ent.data.length);
				//new_file.write_ptr(ent.data.data, ent.data.length);
			case KEYBINDING:	// 21
				//KeybindBulk* kb = (KeybindBulk*)ent.data.data;
			
				//* Length of name
				//new_file.write_64(kb.key.len);
				
				//* Name
				//new_file.write_string(kb.key);
	
				//* Keybind
				//new_file.write_8((char)kb.value.type);
				//new_file.write_32(kb.value.key);
				//new_file.write_8(kb.value.index);
			case SETTING:		// 22
				//SettingsValue* sv = (SettingsValue*)ent.data.data;

				//* Type
				//new_file.write_8((char)sv.type);
				
				//* Value
				//switch (sv.type) {
				//	case BOOL:
				//		new_file.write_8((char)sv.as_bool);
				//		new_file.head += (SettingsValue.sizeof - SettingValueType.sizeof - bool.sizeof);
				//	case BYTE:
				//		new_file.write_8(sv.as_char);
				//		new_file.head += (SettingsValue.sizeof - SettingValueType.sizeof - char.sizeof);
				//	case SHORT:
				//		new_file.write_16(sv.as_short);
				//		new_file.head += (SettingsValue.sizeof - SettingValueType.sizeof - short.sizeof);
				//	case INT:
				//		new_file.write_32(sv.as_int);
				//		new_file.head += (SettingsValue.sizeof - SettingValueType.sizeof - int.sizeof);
				//	case LONG:
				//		new_file.write_64(sv.as_long);
				//		new_file.head += (SettingsValue.sizeof - SettingValueType.sizeof - long.sizeof);
				//	case FLOAT:
				//		new_file.write_float(sv.as_float);
				//		new_file.head += (SettingsValue.sizeof - SettingValueType.sizeof - float.sizeof);
				//	case DOUBLE:
				//		new_file.write_64((long)sv.as_double);
				//		new_file.head += (SettingsValue.sizeof - SettingValueType.sizeof - double.sizeof);
				//	case VECTOR2:
				//		new_file.write_32((int)sv.as_vector2.x);
				//		new_file.write_32((int)sv.as_vector2.y);
				//		new_file.head += (SettingsValue.sizeof - SettingValueType.sizeof - Vector2.sizeof);
				//	case VECTOR3:
				//		new_file.write_32((int)sv.as_vector3.x);
				//		new_file.write_32((int)sv.as_vector3.y);
				//		new_file.write_32((int)sv.as_vector3.z);
				//		new_file.head += (SettingsValue.sizeof - SettingValueType.sizeof - Vector3.sizeof);
				//	case RESOLUTION:
				//		new_file.write_32(sv.as_resolution.width);
				//		new_file.write_32(sv.as_resolution.height);
				//		new_file.head += (SettingsValue.sizeof - SettingValueType.sizeof - Resolution.sizeof);
				//	default:
				//		new_file.head += (SettingsValue.sizeof - SettingValueType.sizeof);
				//}
		}
	}

	String filename = string::tformat("resources/%s.blk", self.name);
	(void)new_file.save(filename);
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
	BulkValue val;

	switch (data.type) {
		case String:
			val.as_string = {
				.type = STRING,
				.data = *(String*)data,
			};
	}

	self.entries.set(name, val);
}
/** Retrieves value from bulk entry
 @param name "Name of desired entry"
 @return "Value"
 **/
fn BulkValue! Bulk.get(&self, String name) {
	//* Entry error checking
	BulkValue! entry = self.entries[name];
	if (catch entry) {
		debug::log("Failed to find inputted entry in Bulk.", LOW, self.name, name);
		return BulkFault.ENTRY_DOESNT_EXIST?;
	}

	return entry;
}


/** Bulk Value
 **/
union BulkValue {
	BulkGeneral as_def;
	BulkString as_string;
	BulkImage as_image;
	BulkAudio as_audio;
	BulkSprite as_sprite;
	BulkFont as_font;

	BulkKeybinding as_keybinding;
	BulkSetting as_setting;
}
/** Bulk general
 **/
struct BulkGeneral {
	BulkValueType type;
}
/** Bulk value data types
 **/
enum BulkValueType {
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
/** String
 **/
struct BulkString {
	BulkValueType type;
	String data;
}
/** Image
 TODO:
 **/
struct BulkImage {
	BulkValueType type;
	Image* data;
}
/** Audio
 TODO:
 **/
struct BulkAudio {
	BulkValueType type;
}
/** Sprite
 TODO:
 **/
struct BulkSprite {
	BulkValueType type;
	String data;
}
/** Font
 TODO:
 **/
struct BulkFont {
	BulkValueType type;
	Font* data;
}
/** Keybinding
 TODO:
 **/
struct BulkKeybinding {
	BulkValueType type;
	String data;
}
/** Setting
 TODO:
 **/
struct BulkSetting {
	BulkValueType type;
	String data;
}
/** Copy data from file
 **/
fn BulkValue! BulkFile.copydata(&self) {
	BulkValue val;

	BulkValueType type = (BulkValueType)self.read_8();
	val.as_def.type = type;

	switch (type) {
		default: break;
		case STRING:		// 00
			long str_len = self.read_64();
			ZString str = (ZString)malloc(str_len);
			for (int i = 0; i < str_len; i++) {
				str[i] = self.read_8();
			}
			val.as_string.data = str.str_view();
	}

	return val;
}

/** Entry for bulk table
 **/
struct BulkTableEntry {
	String name;
	usz ptr;
	BulkValue val;
}



module bulk::file;
import std::io;
import pleroma::debug;
import raylib;


/** Bulk File
 **/
struct BulkFile {
	Compression compression;
	char[] data;
	usz head;
}
/** Bulk file faults
 **/
fault BulkFault {
	FILE_NOT_FOUND,
	FILE_ZERO_LENGTH,
	FILE_FAILED_BUFFER,
	FILE_CANNOT_WRITE,
	ENTRY_EXISTS,
	ENTRY_DOESNT_EXIST,
	ENTRY_NOT_CORRECT_TYPE,
	ENTRY_NO_TYPE,
}
/** Compression methods
 **/
enum Compression {
	NONE,
	DEFLATE,
}

/** Initialize bulkfile using length
 @param size "size of data"
 @require size > 1
 **/
fn BulkFile*! init(usz size, Compression compression = NONE) {
	BulkFile* result = mem::new(BulkFile);
	*result = {
		.compression = NONE,
		.data = mem::new_array(char, size),
		.head = 0,
	};

	return result;
}
/** Loads bulkfile from file
 **/
fn BulkFile*! load(String filename, Compression compression = NONE) {
	BulkFile* result = mem::new(BulkFile);
	result.compression = compression;
	result.head = 0;
	
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
	char[] buffer = mem::new_array(char, length);
	usz! result_len = file.read(buffer);
	if (catch result_len) {
		debug::log("Failed to read file to buffer", LOW);
		return BulkFault.FILE_FAILED_BUFFER?;
	}

	//* Decompress data
	switch (compression) {
		case NONE:
			result.data = buffer;
		case DEFLATE:
			int decompressed_size = 0;
			char* data = raylib::decompress(buffer, (int)length, &decompressed_size);
			char[] new_buffer = mem::new_array(char, decompressed_size);
			for (int i = 0; i < decompressed_size; i++) { new_buffer[i] = data[i]; }
			result.data = new_buffer;
			free(data);
	}
	
	free(buffer);
	(void)file.close();
	return result;
}
/** Closes bulkFile and frees all allocated data
 **/
fn void! BulkFile.unload(&self) {
	free(self.data);
	self.head = 0;
}
/** Saves bulkfile
 @param filename "directory to save to"
 **/
fn void! BulkFile.save(&self, String filename) {
	io::File! file = file::open(filename, "wb");

	//* Make sure file can be opened
	if (catch file) {
		debug::log("Failed to open file", LOW, filename);
		return BulkFault.FILE_NOT_FOUND?;
	}

	//* Write byte to file based on compression
	switch (self.compression) {
		case NONE:
			for (int i = 0; i < self.data.len; i++) {
				if (catch file.write_byte(self.data[i])) {
					debug::log("Failed to write to file", LOW, filename, i);
					return BulkFault.FILE_CANNOT_WRITE?;
				}
			}
		case DEFLATE:
			int compressed_size = 0;
			char* data = raylib::compress(self.data, (int)self.data.len, &compressed_size);
			for (int i = 0; i < compressed_size; i++) {
				if (catch file.write_byte(data[i])) {
					debug::log("Failed to write to file", LOW, filename, i);
					return BulkFault.FILE_CANNOT_WRITE?;
				}
			}
	}

	(void)file.close();
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
 @param str "Char* to write"
 @require str != null
 **/
fn void BulkFile.write_charptr(&self, char* str) {
	int length = 0;
	for (int i = 0; str[i] != '\0'; i++) {
		self.data[self.head + i] = ((char*)str)[i];
		length++;
	}
	self.head += length;
}
/** Writes contents of inputted string to the bulkfile at the head
 @param str "String to write"
 **/
fn void BulkFile.write_string(&self, String str) {
	for (int i = 0; i < str.len; i++) {
		self.data[self.head + i] = ((char*)str)[i];
	}
	self.head += str.len;
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
///** Gets a pointer to where the head is in the data
// @return "Data from pointer"
// **/
//fn void* BulkFile.get_cur_ptr(&self) {
//	return self.data + self.head;
//}
