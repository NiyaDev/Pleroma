module pleroma::bulk;


import std::io;
import std::collections;
import pleroma::sprite;
import pleroma::debug;


struct BulkTableEntry {
	String name;
	usz ptr;
	BulkEntry data;
}

struct BulkEntry {
	BulkEntryType type;
	usz length;
	void* data;
}
enum BulkEntryType {
	STRING,
	SPRITE,
}

struct Bulk {
	String name;
	char major,minor,patch;
	HashMap(<String, BulkEntry>) entries;
}


const char BULK_MAJOR = 1;
const char BULK_MINOR = 0;
const char BULK_PATCH = 0;


//= Saving / Loading
/**
 * Opens bulk into structure
 * @param filename
**/
//fn void Bulk.open(&self, String filename) {
fn Bulk open(String filename) {
	Bulk self = {
		.name = filename,
	};
	self.entries.new_init();

	BulkFile file = {};
	file.init_file(filename);
	
	self.major = file.read_byte();
	self.minor = file.read_byte();
	self.patch = file.read_byte();
	
	char number_of_entries = file.read_byte();
	usz offset = 4;
	
	for (int i = 0; i < number_of_entries; i ++) {
		usz entry_name_length = file.read_long();
		String entry_name = file.read_string(entry_name_length);
		usz ptr = file.read_long();
		
		//* Save head value and set it to data
		usz old_head = file.head;
		file.head = ptr;
		
		//* Create entry
		BulkEntry entry = {};
		entry.type = (BulkEntryType)file.read_byte();
		
		//* Copy data
		switch (entry.type) {
			default:
			case BulkEntryType.STRING:
				entry.length = (usz)file.read_long();
				entry.data = malloc(entry.length);
				for (int j = 0; j < entry.length; j++) {
					((char*)entry.data)[j] = file.read_byte();
				}
			case BulkEntryType.SPRITE:
				//* Create Image
				entry.length = (usz)file.read_long();
				Sprite* data = sprite::from_image(pleroma::load_image_from_memory(".png", (char*)file.get_cur_ptr(), (int)entry.length));
				file.head += entry.length;
				
				//* Create animations
				usz number_of_animations = file.read_long();
				for (int j = 0; j < number_of_animations; j++) {
					usz ani_name_length = file.read_long();
					String ani_name = file.read_string(ani_name_length);
					usz ani_length = file.read_long();
					
					int[] anim = allocator::alloc_array(allocator::heap(), int, ani_length);
					for (int k = 0; k < ani_length; k++) {
						anim[k] = file.read_int();
					}
					data.new_animation(ani_name, anim, ani_length);
				}
				
				//* Save
				entry.data = (void*)data;
		}
		
		
		self.entries.set(entry_name, entry);
		
		//* Return head to old value
		file.head = old_head;
	}
	
	self.print();
	return self;
}
/**
 * Saves bulk to file
 * @param filename
 **/
fn void Bulk.save(&self, String filename) {
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
			case BulkEntryType.STRING:
				char* ptr = ent.data.data;
				//* Length of string
				offset += 8;
				//* String
				for (int j = 0; ptr[j] != '\0'; j++) { offset++; }
				offset++;
			case BulkEntryType.SPRITE:
				Sprite* spr = (Sprite*)ent.data.data;
				//* Length of data
				offset += 8;
				//* Data
				int image_length = 0;
				char* data = pleroma::export_image_to_memory(spr.original, ".png", &image_length);
				offset += image_length;
				free(data);

				//* Number of animations
				offset += (8 * spr.animations.len());

				spr.animations.@each(; String key, Animation entry) {
					//* Animation name length
					offset += 8;
					//* Animation name
					offset += key.len;
					//* Number of frames
					offset += 8;
					//* Frames
					offset += (entry.length * 4);
				};
		}
	}

	BulkFile new_file = {};
	new_file.init_len(offset);

	//* Write version
	new_file.write_byte(BULK_MAJOR);
	new_file.write_byte(BULK_MINOR);
	new_file.write_byte(BULK_PATCH);
	new_file.write_byte((char)self.entries.len());

	//* Write table to file
	foreach (BulkTableEntry ent : table) {
		usz key_length = ent.name.len;
		new_file.write_64(key_length);
		new_file.write_ptr(ent.name, key_length);
		new_file.write_64((ulong)ent.ptr);
	}

	//* Write each entry to file
	foreach (BulkTableEntry ent : table) {
		//* Type
		new_file.write_byte((char)ent.data.type);
		switch (ent.data.type) {
			default:
			case BulkEntryType.STRING:
				char* ptr = ent.data.data;
				
				//* Length
				usz length = 0;
				for (int j = 0; ptr[j] != '\0'; j++) { length++; }
				new_file.write_64(length+1);
				
				//* Data
				new_file.write_string(ptr);
			case BulkEntryType.SPRITE:
				Sprite* spr = (Sprite*)ent.data.data;
				int image_length = 0;
				char* data = pleroma::export_image_to_memory(spr.original, ".png", &image_length);

				//* Length of data
				new_file.write_64(image_length);

				//* Data
				new_file.write_ptr(data, image_length);
				free(data);

				//* Number of animations
				new_file.write_64(spr.animations.len());

				spr.animations.@each(; String key, Animation entry) {
					//* Animation name length
					new_file.write_64(key.len);
					//* Animation name
					new_file.write_ptr(key, key.len);
					//* Number of frames
					new_file.write_64(entry.length);
					//* Frames
					new_file.write_ptr(entry.data, entry.length * 4);
				};
		}
	}

	new_file.save(filename);
}
//= Conversion
/**
 * Retrieves string from bulk entry
 * @param entry_name
 **/
fn String! Bulk.get_string(&self, String entry_name) {
	BulkEntry! entry = self.entries[entry_name];
	
	if (try entry) {
		usz length = 0;
		for (int i = 0; ((char*)entry.data)[i] != '\0'; i++) { length++; }
		length++;
		
		char[] result = allocator::alloc_array(allocator::heap(), char, length);
		for (int i = 0; i < length; i++) { result[i] = ((char*)entry.data)[i]; }
		
		return (String)result;
	} else { return PleromaFault.BULK_FAILED_FIND_ENTRY?; }
	
}
/**
 * Retrieves Sprite ptr from bulk entry
 * @param entry_name
 **/
fn Sprite* Bulk.get_sprite(&self, String entry_name) {
	BulkEntry! entry = self.entries[entry_name];
	
	if (try entry) {
		return entry.data;
	} else {
		debug::log(PleromaFault.BULK_FAILED_FIND_ENTRY, self.name, entry_name);
		return pleroma::data.default_texture;
	}
}
//= Debug
/**
 * Prints bulk to console
 **/
fn void Bulk.print(&self) {
	io::printfn("Bulk Version %d.%d.%d - %d entries [", self.major, self.minor, self.patch, self.entries.len());
	self.entries.@each(; String key, BulkEntry entry) {
		io::printf("\t%s-", key);
		entry.print();
		io::printn(",");
	};
	io::print("]\n");
}
/**
 * Prints bulk entry to console
 **/
fn void BulkEntry.print(&self) {
	io::printf("%s - %p", self.type, self.data);
}
