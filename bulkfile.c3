module pleroma::bulk;


import libc;
import std::io::file;


/**
 *
 **/
struct BulkFile {
	char* data;
	usz head;
	usz length;
}

/**
 * Initializes a new Bulk file using the desired length
 * @require length > 0
 **/
fn void BulkFile.init_len(&self, usz length) {
	self.data = (char*)malloc(length);
	libc::memset(self.data, 0, length);

	self.length = length;
	self.head = 0;
}
/**
 * Initializes a new Bulk file using a saved file
 * @param filename
 **/
fn void BulkFile.init_file(&self, String filename) {
	io::File! file = file::open(filename, "rb");
	if (try file) {
		usz! length = file::get_size(filename);

		if (try length && length != 0) {
			char[] buffer = allocator::alloc_array(allocator::heap(), char, length);
			usz! result = file.read(buffer);
			if (try result && buffer.len != 0) {
				self.init_len(length);
				self.write_array(buffer, length);
			}
		}

		if (try file.close()) {}
	}
	self.head = 0;
}

/**
 * Saves bulk to inputted filename
 * @param filename
 **/
fn void BulkFile.save(&self, String filename) {
	io::File! file = file::open(filename, "wb");
	if (try file) {
		for (int i = 0; i < self.length; i++) {
			if (try file.write_byte(self.data[i])) {}
		}

		if (try file.close()) {}
	}
}

//= Writing
/**
 * Writes inputted byte to the bulkfile at the head
 * @param input
 **/
fn void BulkFile.write_byte(&self, char input) {
	self.data[self.head++] = input;
}
/**
 * Writes inputted long to the bulkfile at the head
 * @param input
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
 * @param ptr
 * @require ptr != null
 * @param length
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
 * @param array
 * @param length
 * @require length > 0
 **/
fn void BulkFile.write_array(&self, char[] array, usz length) {
	for (int i = 0; i < length; i++) {
		self.data[self.head + i] = array[i];
	}
	self.head += length;
}
/**
 * Writes contents of inputted null-terminated string to the bulkfile at the head
 * @param str
 * @require str != null
 **/
fn void BulkFile.write_string(&self, char* str) {
	int length = 0;
	for (int i = 0; str[i] != '\0'; i++) {
		self.data[self.head + i] = ((char*)str)[i];
		length++;
	}
	length++;
	self.head += length;
}

//= Reading
/**
 * Reads byte from the bulkfile at the head, moving it forward
 **/
fn char BulkFile.read_byte(&self) {
	char result = self.data[self.head];
	self.head++;
	return result;
}
/**
 * Reads int from the bulkfile at the head, moving it forward
 **/
fn int BulkFile.read_int(&self) {
	int result = self.data[self.head]
		+ ((long)self.data[self.head + 1] <<  8)
		+ ((long)self.data[self.head + 2] << 16)
		+ ((long)self.data[self.head + 3] << 24);
	self.head += 4;
	return result;
}
/**
 * Reads long from the bulkfile at the head, moving it forward
 **/
fn long BulkFile.read_long(&self) {
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
 * 
 **/
fn void* BulkFile.get_cur_ptr(&self) {
	return self.data + self.head;
}