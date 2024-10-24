
module pleroma::bulk;

import libc;
import std::io;
import std::collections;
import pleroma::keybindings;
import pleroma::debug;
import raylib;


const char BULK_MAJOR = 1;
const char BULK_MINOR = 0;
const char BULK_PATCH = 0;


/**
 * Bulk file
 **/
struct Bulk {
	String name;
	char major, minor, patch;
	HashMap(<String, BulkEntry>) entries;
}
/**
 * Bulk file faults
 **/
fault BulkFault {
	FILE_NOT_FOUND,
	FILE_ZERO_LENGTH,
	FILE_FAILED_BUFFER,
	ENTRY_EXISTS,
	ENTRY_DOESNT_EXIST,
}
/**
 * Initialize a blank Bulk
 * @return "Pointer to new Bulk"
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
/**
 * Loads bulk from file
 * @param filename "Name of file to load"
 * @param compression "Compression of file"
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
			case STRING: // 00
				entry.length = (usz)file.read_64();
				entry.data = malloc(entry.length);
				for (int j = 0; j < entry.length; j++) {
					((char*)entry.data)[j] = file.read_8();
				}
			case SPRITE: // 01

			case KEYBINDING: // 21
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
				keybindings::add(name, kb);
				
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

	return self;
}
/**
 * Closes Bulk
 **/
fn void Bulk.close(&self) {
	self.entries.@each(; String key, BulkEntry value) {
		free(value.data);
	};
	self.entries.free();
}
/**
 * Save Bulk to file
 **/
fn void Bulk.save(&self) {
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
			case STRING:
				char* ptr = ent.data.data;
				//* Length of string
				offset += 8;
				//* String
				for (int j = 0; ptr[j] != '\0'; j++) { offset++; }
				offset++;
			case SPRITE:

			case KEYBINDING:
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
			case STRING:
				char* ptr = ent.data.data;
				
				//* Length
				usz length = 0;
				for (int j = 0; ptr[j] != '\0'; j++) { length++; }
				new_file.write_64(length+1);
				
				//* Data
				new_file.write_string(ptr);
			case SPRITE:
				
			case KEYBINDING:
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

	(void)new_file.save(self.name);
}

/**
 * Add string to Bulk
 * @param name "Name of entry in Bulk"
 * @param data "String to add to Bulk"
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
/**
 * Retrieves string from bulk entry
 * @param entry_name
 * @return "String entry"
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
// TODO

/**
 * Entry for bulk table
 **/
struct BulkTableEntry {
	String name;
	usz ptr;
	BulkEntry data;
}

/**
 * Entry for bulk
 **/
struct BulkEntry {
	BulkEntryType type;
	usz length;
	void* data;
}
/**
 * Different types of files stored in Bulk
 **/
enum BulkEntryType : char {
	STRING,
	SPRITE,
	
	PADDING_2,
	PADDING_3,
	PADDING_4,
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
/**
 * Prints bulk entry to console
 **/
fn void BulkEntry.print(&self) {
	io::printf("%s - %p", self.type, self.data);
}

/**
 *
 **/
struct BulkFile {
	Compression compression;
	char* data;
	usz head;
	usz length;
}
/**
 * Different compression methods
 **/
enum Compression {
	NONE,
	DEFLATE,
}
/**
 * Initializes a new Bulk file using the desired length
 * @param length "Length of file"
 * @require length > 0
 **/
fn void BulkFile.init_len(&self, usz length) {
	self.data = malloc(length);
	libc::memset(self.data, 0, length);

	self.length = length;
	self.head = 0;
}
/**
 * Initializes a new Bulk file using a saved file
 * @param filename "Name of file to load"
 * @param compression "Compression type"
 **/
fn void! BulkFile.init_file(&self, String filename, Compression compression = NONE) {
	io::File! file = file::open(filename, "rb");

	//* Catch File error
	if (catch file) {
		debug::log("Cannot find Bulk file", LOW);
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
/**
 * Saves bulk to inputted filename
 * @param filename "Name of file to load"
 * @param compression "Compression type"
 **/
fn void! BulkFile.save(&self, String filename, Compression compression = NONE) {
	io::File! file = file::open(filename, "wb");
	if (catch file) {
		debug::log("Failed to open file", LOW);
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
}

/**
 * Writes inputted byte to the bulkfile at the head
 * @param input "Byte to write"
 **/
fn void BulkFile.write_8(&self, char input) {
	self.data[self.head++] = input;
}
/**
 * Writes inputted int to the bulkfile at the head
 * @param input "Short to write"
 **/
fn void BulkFile.write_16(&self, short input) {
	self.data[self.head++] = (char)(input >>  0);
	self.data[self.head++] = (char)(input >>  8);
}
/**
 * Writes inputted int to the bulkfile at the head
 * @param input "Int to write"
 **/
fn void BulkFile.write_32(&self, int input) {
	self.data[self.head++] = (char)(input >>  0);
	self.data[self.head++] = (char)(input >>  8);
	self.data[self.head++] = (char)(input >> 16);
	self.data[self.head++] = (char)(input >> 24);
}
/**
 * Writes inputted long to the bulkfile at the head
 * @param input "Long to write"
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
/**
 * Writes contents of inputted ptr to the bulkfile at the head
 * @param ptr "Pointer to data to write"
 * @require ptr != null
 * @param length "Amount to copy from data"
 * @require length > 0
 **/
fn void BulkFile.write_ptr(&self, void* ptr, usz length) {
	for (int i = 0; i < length; i++) {
		self.data[self.head + i] = ((char*)ptr)[i];
	}
	self.head += length;
}
/**
 * Writes contents of inputted array to the bulkfile at the head
 * @param array "Array to write"
 **/
fn void BulkFile.write_array(&self, char[] array) {
	for (int i = 0; i < array.len; i++) {
		self.data[self.head + i] = array[i];
	}
	self.head += array.len;
}
/**
 * Writes contents of inputted null-terminated string to the bulkfile at the head
 * @param str "String to write"
 * @require str != null
 **/
fn void BulkFile.write_string(&self, char* str) {
	int length = 0;
	for (int i = 0; str[i] != '\0'; i++) {
		self.data[self.head + i] = ((char*)str)[i];
		length++;
	}
	self.head += length;
}

/**
 * Reads byte from the bulkfile at the head, moving it forward
 * @return "Char read"
 **/
fn char BulkFile.read_8(&self) {
	char result = self.data[self.head];
	self.head++;
	return result;
}
/**
 * Reads short from the bulkfile at the head, moving it forward
 * @return "Short read"
 **/
fn short BulkFile.read_16(&self) {
	short result = self.data[self.head] + ((long)self.data[self.head + 1] <<  8);
	self.head += 2;
	return result;
}
/**
 * Reads int from the bulkfile at the head, moving it forward
 * @return "Int read"
 **/
fn int BulkFile.read_32(&self) {
	int result = self.data[self.head]
		+ ((long)self.data[self.head + 1] <<  8)
		+ ((long)self.data[self.head + 2] << 16)
		+ ((long)self.data[self.head + 3] << 24);
	self.head += 4;
	return result;
}
/**
 * Reads long from the bulkfile at the head, moving it forward
 * @return "Long read"
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
/**
 * Reads string from the bulkfile at the head, moving it forward
 * @require length > 0
 * @return "String read"
 **/
fn String BulkFile.read_string(&self, usz length) {
	char[] result = allocator::alloc_array(allocator::heap(), char, length);
	for (int i = 0; i < length; i++) {
		result[i] = self.data[self.head + i];
	}
	
	self.head += length;
	
	return (String)result;
}
/**
 * Gets a pointer to where the head is in the data
 * @return "Data from pointer"
 **/
fn void* BulkFile.get_cur_ptr(&self) {
	return self.data + self.head;
}