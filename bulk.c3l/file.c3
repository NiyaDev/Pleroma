
module bulk;
import std::io;


<* File for reading a bulk from file *>
struct BulkFile {
  Compression compression;
  
  char[] data;
  usz head;
}

<* Compression method *>
enum Compression {
  NONE,
  DEFLATE,
}


<* Create new Bulk file
  @param size "Size of file"
  @param compression "Compression method, default of NONE"
  @return "Pointer to new Bulk file or error"
 *>
fn BulkFile*! new_file(usz size = 0, Compression compression = NONE) {
  BulkFile* output = mem::new(BulkFile);

  char[] data;
  if (size != 0) { data = mem::new_array(char, size); }
  else           { data = mem::new_array(char, 1); }

  *output = {
    .compression = compression,
    .data = data,
    .head = 0,
  };

  return output;
}
<* Load file and ready to read it
  @param filename "Name of file to load"
  @param compression "Compression of file"
 *>
fn BulkFile*! load_file(String filename, Compression compression = NONE) {
  BulkFile* output = new_file()!;

  //* Load file and error check
  File! file = file::open(filename, "rb");
  if (catch file) {
    io::printfn("ERROR - Cannot find Bulk file [%s]", filename);
    return BulkFault.FILE_NOT_FOUND?;
  }
  //* Get file length and error check
  usz! length = file::get_size(filename);
  if (catch length) {
    io::printfn("ERROR - Bulk file is zero length");
    return BulkFault.FILE_ZERO_LENGTH?;
  }
  //* Copy buffer
  char[] buffer = mem::new_array(char, length);
  usz! resulting_length = file.read(buffer);
  if (catch resulting_length) {
    io::printfn("ERROR - Failed to read file to buffer");
    return BulkFault.FILE_FAILED_BUFFER?;
  }

  //* Decompress data
  switch (compression) {
    case DEFLATE:
      // TODO: 
    default:
      free(output.data);
      output.data = buffer;
  }
  
  //free(buffer);
  file.close()!;

  return output;
}
<* Frees bulk file data *>
fn void! BulkFile.free(&self) {
  free(self.data);
  free(self);
}
<* Save bulk file to disk *>
fn void! BulkFile.save(&self, String filename) {
  //* Open file and error check
  File! file = file::open(filename, "wb");
  if (catch file) {
    io::printfn("ERROR - Failed to open file [%s]", filename);
    return BulkFault.FILE_NOT_FOUND?;
  }

  //* Write data to file based on compression
  switch (self.compression) {
    case DEFLATE:
      // TODO: 
    default:
      for (int i; i< self.data.len; i++) {
        if (catch file.write_byte(self.data[i])) {
          io::printfn("ERROR - Failed to write to file [%d] byte %i at position %d", filename, self.data[i], i);
          return BulkFault.FILE_CANNOT_WRITE?;
        }
      }
  }

  file.close()!;
}
<* *>
fn void BulkFile.print(&self) {
  for (int i; i < self.data.len; i++) {
    io::printf("%2X-",self.data[i]);
  }
  io::printn("");
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
	float* fl = mem::new(float);
	*fl = input;

	self.data[self.head++] = *((char*)fl);
	self.data[self.head++] = *(((char*)fl)+1);
	self.data[self.head++] = *(((char*)fl)+2);
	self.data[self.head++] = *(((char*)fl)+3);
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
  short* result = (short*)&self.data[self.head];
  self.head += 2;
	
	return *result;
}
<* Reads int from the bulkfile *>
fn int BulkFile.read_32(&self) {
  int* result = (int*)&self.data[self.head];
	self.head += 4;

  return *result;
}
<* Reads long from the bulkfile *>
fn long BulkFile.read_64(&self) {
  long* result = (long*)&self.data[self.head];
  self.head += 8;

	return *result;
}
<* Reads float from the bulkfile *>
fn float BulkFile.read_float(&self) {
	float* result = (float*)&self.data[self.head];
	self.head += 4;

	return *result;
}
<* Reads string from the bulkfile *>
fn String BulkFile.read_string(&self) {
  usz start = self.head;

  //* Count characters
  int count = 0;
  for (int i; self.data[self.head] != '\0'; i++) {
    count++;
    self.head++;
  }
  self.head = start;

  //* Copy string
  String output = (String)mem::new_array(char,count);
  for (int i; i < count; i++) {
    output[i] = self.data[self.head++];
  }
  self.head++;
  
  return output;
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


