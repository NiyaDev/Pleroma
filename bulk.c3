
module pleroma::bulkfile;
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
fn void! BulkFile.init(&self, usz size) {
	self.data = mem::new_array(char, size);
	self.head = 0;
}
/** Loads bulkfile from file
 **/
fn void! BulkFile.load(&self, String filename, Compression compression = NONE) {
	self.compression = compression;
	
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
	usz! result = file.read(buffer);
	if (catch result) {
		debug::log("Failed to read file to buffer", LOW);
		return BulkFault.FILE_FAILED_BUFFER?;
	}

	//* Decompress data
	switch (compression) {
		case NONE:
			self.data = buffer;
		case DEFLATE:
			int decompressed_size = 0;
			char* data = raylib::decompress(buffer, (int)length, &decompressed_size);
			char[] new_buffer = mem::new_array(char, decompressed_size);
			for (int i = 0; i < decompressed_size; i++) { new_buffer[i] = data[i]; }
			self.data = new_buffer;
			free(data);
	}
	
	free(buffer);
	(void)file.close();
	self.head = 0;
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
