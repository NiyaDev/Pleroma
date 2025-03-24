
module pleroma::bulk::file;
import std::io;
import std::os;


<* File for reading a bulk from file *>
struct BulkFile {
  Compression compression;
  
  char[] data;
  usz head;
}


faultdef TESTFAULT;
<**>
fn bool? test() @export("bulk_test") {
  return TESTFAULT?;
}
<* Create a new file for loading bulk
  @param size "Size of file"
  @param comp "Compression algo for file"
 *>
fn BulkFile new(usz size, Compression comp = NONE) {
  char[] data;
  if (size != 0) data = mem::new_array(char, size);

  return {
    .compression = comp,
    .data = data,
    .head = 0,
  };
}
<* Load file and decompress
  @param filename "Name of file to load"
  @param comp "Compression algorithm used"
 *>
fn BulkFile load(String filename, Compression comp = NONE) {
  //* Load file and error check
  // load_new isn't recognized, using load_temp but unknown if works
  //char[]? buffer = io::file::load_temp(filename);
  //if (catch buffer) unreachable();
  usz length = file::get_size(filename)!!;
  File file = file::open(filename, "rb")!!;
  defer file.close()!!;
  char[] buffer = mem::new_array(char, length);
  file.read(buffer)!!;

  BulkFile output = new(0, comp);

  //* Decompress data
  switch (comp) {
    case NONE:
      output.data = buffer;
    case DEFLATE:
      output.data = decompress_deflate(buffer);
  }

  return output;
}
<* Frees data *>
fn void BulkFile.free(&self) {
  free(self.data);
}
<* Saves file *>
fn void BulkFile.save(&self, String filename) {
  //* Open file and error check
  File? file = file::open(filename, "wb");
  assert(@ok(file), "Failed to open file for saving.");

  //* Write data to file based on compression
  switch (self.compression) {
    case NONE:
      for (int i; i < self.data.len; i++) {
        assert(@ok(file.write_byte(self.data[i])), "Failed to write to file.");
      }
    case DEFLATE:
      char[] comp_data = compress_deflate(self.data);
      for (int i; i < comp_data.len; i++) {
        assert(@ok(file.write_byte(comp_data[i])), "Failed to write to file.");
      }
  }

  file.close()!!;
}
<* Print BulkFile data to console *>
fn void BulkFile.print(&self) {
  for (int i; i < self.data.len; i++) {
    io::printf("%2X-", self.data[i]);
  }
  io::print("\n");
}

// TODO:
<* Decompress data using Deflate algo *>
fn char[] decompress_deflate(char[] data) {
  return data;
}
// TODO:
<* Compress data using Deflate algo *>
fn char[] compress_deflate(char[] data) {
  return data;
}

<* Writes byte to bulk file *>
fn void BulkFile.write_8(&self, char input) {
  self.data[self.head++] = input;
}
<* Writes short to bulk file *>
fn void BulkFile.write_16(&self, short input) {
  self.data[self.head++] = (char)(input >> 0);
  self.data[self.head++] = (char)(input >> 8);
}
<* Writes int to bulk file *>
fn void BulkFile.write_32(&self, int input) {
  self.data[self.head++] = (char)(input >>  0);
  self.data[self.head++] = (char)(input >>  8);
  self.data[self.head++] = (char)(input >> 16);
  self.data[self.head++] = (char)(input >> 24);
}
<* Writes long to bulk file *>
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
<* Writes float to the bulkfile *>
fn void BulkFile.write_float(&self, float input) {
  self.data[self.head++] = *(((char*)&input)+0);
	self.data[self.head++] = *(((char*)&input)+1);
	self.data[self.head++] = *(((char*)&input)+2);
	self.data[self.head++] = *(((char*)&input)+3);
}
<* Writes contents of ptr to the bulkfile
  @param ptr "Pointer to data to write"
  @require ptr != null
  @param length "Amount to copy from data"
  @require length > 0
 *>
fn void BulkFile.write_ptr(&self, void* ptr, usz length) {
	for (int i = 0; i < length; i++) {
		self.data[self.head + i] = ((char*)ptr)[i];
	}
	self.head += length;
}
<* Writes contents of array to the bulkfile *>
fn void BulkFile.write_array(&self, char[] array) {
	for (int i = 0; i < array.len; i++) {
		self.data[self.head + i] = array[i];
	}
	self.head += array.len;
}
<* Writes contents of null-terminated string to the bulkfile
 @param str "Char* to write"
 @require str != null
 *>
fn void BulkFile.write_charptr(&self, char* str) {
	int length = 0;
	for (int i = 0; str[i] != '\0'; i++) {
		self.data[self.head + i] = ((char*)str)[i];
		length++;
	}
	self.head += length;
}
<* Writes contents of string to the bulkfile *>
fn void BulkFile.write_string(&self, String str) {
	for (int i = 0; i < str.len; i++) {
		self.data[self.head + i] = ((char*)str)[i];
	}
	self.head += str.len;
	self.data[self.head++] = '\0';
}

<* Reads byte from the bulkfile *>
fn char BulkFile.read_8(&self) {
  return self.data[self.head++];
}
<* Reads short from the bulkfile *>
fn short BulkFile.read_16(&self) {
  short result;
  result += (short)self.data[self.head++] <<  0;
  result += (short)self.data[self.head++] <<  8;
	
	return result;
}
<* Reads int from the bulkfile *>
fn int BulkFile.read_32(&self) {
  int result;
  result += (int)self.data[self.head++] <<  0;
  result += (int)self.data[self.head++] <<  8;
  result += (int)self.data[self.head++] << 16;
  result += (int)self.data[self.head++] << 24;

  return result;
}
<* Reads long from the bulkfile *>
fn long BulkFile.read_64(&self) {
  long result;
  result += (long)self.data[self.head++] <<  0;
  result += (long)self.data[self.head++] <<  8;
  result += (long)self.data[self.head++] << 16;
  result += (long)self.data[self.head++] << 24;
  result += (long)self.data[self.head++] << 32;
  result += (long)self.data[self.head++] << 40;
  result += (long)self.data[self.head++] << 48;
  result += (long)self.data[self.head++] << 56;

	return result;
}
<* Reads float from the bulkfile *>
fn float BulkFile.read_float(&self) {
  float output;
  mem::copy(&output, &self.data[self.head], 4);
  self.head += 4;

  return output;
}
<* Reads string from the bulkfile *>
fn String BulkFile.read_string(&self) {
  usz start = self.head;

  // Count characters
  int count = 0;
  for (int i; self.data[self.head] != '\0'; i++) {
    count++;
    self.head++;
  }
  self.head = start;

  // Copy string
  char[] output = mem::new_array(char,count);
  for (int i; i < count; i++) {
    output[i] = self.data[self.head++];
  }
  self.head++;
  
  return (String)output;
}
<* Read data at pointer to array
 @param length "Amount of data to copy"
 @return "Array of copied data"
 *>
fn char[] BulkFile.read_array(&self, usz length) {
	char[] result = allocator::alloc_array(allocator::heap(), char, length);

	for (int i = 0; i < length; i++) {
		result[i] = self.data[self.head++];
	}

	return result;
}
<* Read data at pointer to a pointer
 @param length "Amount of data to copy"
 @return "Array of copied data"
 *>
fn char* BulkFile.read_ptr(&self, usz length) {
	char* result = malloc(length);

	for (int i = 0; i < length; i++) {
		result[i] = self.data[self.head++];
	}

	return result;
}

