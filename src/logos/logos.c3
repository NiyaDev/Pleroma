
module pleroma::logos;
import std::io;
import pleroma::raylib;


struct Logos {
  inline char[] data;
  Compression compression;
  usz head;
}

enum Compression {
  NONE,
  DEFLATE,
}

struct LogosData {
  LogosType type;
  union {
    char as_char;
    short as_short;
    int as_int;
    long as_long;

    float as_float;
    double as_double;

    char[] as_char_array;
    short[] as_short_array;
    int[] as_int_array;
    long[] as_long_array;
    float[] as_float_array;
    double[] as_double_array;

    String as_string;
  }
}

enum LogosType : char (usz size) {
  CHAR         = 1,
  SHORT        = 2,
  INT          = 4,
  LONG         = 8,
  FLOAT        = 4,
  DOUBLE       = 8,
  CHAR_ARRAY   = 1,
  SHORT_ARRAY  = 2,
  INT_ARRAY    = 4,
  LONG_ARRAY   = 8,
  FLOAT_ARRAY  = 4,
  DOUBLE_ARRAY = 8,
  STRING       = 1,
}

<* Convert a char array into a logos *>
fn Logos char[].to_logos(&self) @export("logos_tologos") {
  return {
    *self,
    NONE,
    0,
  };
}
<* Create new empty logos *>
fn Logos new(usz size = 0, Compression comp = NONE) @export("logos_new") {
  Logos output;
  output.data = mem::new_array(char, size);
  output.compression = comp;

  return output;
}
<* Load file into logos *>
fn Logos file(String filename, Compression comp = NONE) @export("logos_file") {
  raylib::set_trace_log_level(NONE);
  // Grab data from file
  char[] data = file::load(allocator::heap(), filename)!!;

  // Decompress if necesary
  switch (comp) {
    case DEFLATE:
      int new_size;
      char* new_data = raylib::decompress((char*)data, data.len, &new_size);
      free(data);

      data = mem::new_array(char, new_size);
      for (int i; i < new_size; i++) {
        data[i] = new_data[i];
      }
      raylib::memfree(new_data);
    default:
  }

  // Return data
  return {
    data,
    comp,
    0,
  };
}
<* Saves logos to file *>
fn void Logos.save(&self, String filename) @export("logos_save") {
  raylib::set_trace_log_level(NONE);
  // Open file to write
  File file = file::open(filename, "wb")!!;

  // Compress data
  switch (self.compression) {
    case DEFLATE:
      int new_size;
      char* new_data = raylib::compress(self.data, self.data.len, &new_size);
      
      char[] new_array = mem::new_array(char, new_size);
      for (int i; i < new_size; i++) {
        new_array[i] = new_data[i];
      }
      raylib::memfree(new_data);
      file.write(new_array)!!;
      free(new_array);
    default:
      file.write(self.data)!!;
  }

  // Close file
  file.close()!!;
}
<* Frees logos *>
fn void Logos.free(&self) @export("logos_free") {
  free(self.data);
}

<* Writes data into logos *>
fn void Logos.write(&self, LogosData data) @export("logos_write") {
  if (self.head + data.type.size >= self.data.len) {
    usz new_size = self.data.len;
    switch (data.type) {
      case CHAR_ARRAY:   new_size += (data.type.size * data.as_char_array.len) + 4;
      case SHORT_ARRAY:  new_size += (data.type.size * data.as_short_array.len) + 4;
      case INT_ARRAY:    new_size += (data.type.size * data.as_int_array.len) + 4;
      case LONG_ARRAY:   new_size += (data.type.size * data.as_long_array.len) + 4;
      case FLOAT_ARRAY:  new_size += (data.type.size * data.as_float_array.len) + 4;
      case DOUBLE_ARRAY: new_size += (data.type.size * data.as_double_array.len) + 4;
      case STRING:       new_size += (data.type.size * data.as_string.len) + 1;
      default:           new_size +=  data.type.size;
    }
    // TODO: debug mode that enables/disables this
    // io::printfn("Allocating more to logos [%d]->[%d]",self.data.len, new_size);
    char[] new_array = mem::new_array(char, new_size);
    mem::copy(new_array, self.data, self.data.len);
    free(self.data);
    self.data = new_array;
  }

  switch (data.type) {
    case CHAR:
      self.data[self.head++] = data.as_char;
    case SHORT:
      self.data[self.head++] = (char)(data.as_short >> 0);
      self.data[self.head++] = (char)(data.as_short >> 8);
    case INT:
      self.data[self.head++] = (char)(data.as_int >>  0);
      self.data[self.head++] = (char)(data.as_int >>  8);
      self.data[self.head++] = (char)(data.as_int >> 16);
      self.data[self.head++] = (char)(data.as_int >> 24);
    case LONG:
      self.data[self.head++] = (char)(data.as_long >>  0);
      self.data[self.head++] = (char)(data.as_long >>  8);
      self.data[self.head++] = (char)(data.as_long >> 16);
      self.data[self.head++] = (char)(data.as_long >> 24);
      self.data[self.head++] = (char)(data.as_long >> 32);
      self.data[self.head++] = (char)(data.as_long >> 40);
      self.data[self.head++] = (char)(data.as_long >> 48);
      self.data[self.head++] = (char)(data.as_long >> 56);
    case FLOAT:
      self.data[self.head++] = *(((char*)&data.as_float)+0);
	    self.data[self.head++] = *(((char*)&data.as_float)+1);
	    self.data[self.head++] = *(((char*)&data.as_float)+2);
	    self.data[self.head++] = *(((char*)&data.as_float)+3);
	  case DOUBLE:
	    self.data[self.head++] = *(((char*)&data.as_double)+0);
	    self.data[self.head++] = *(((char*)&data.as_double)+1);
	    self.data[self.head++] = *(((char*)&data.as_double)+2);
	    self.data[self.head++] = *(((char*)&data.as_double)+3);
	    self.data[self.head++] = *(((char*)&data.as_double)+4);
	    self.data[self.head++] = *(((char*)&data.as_double)+5);
	    self.data[self.head++] = *(((char*)&data.as_double)+6);
	    self.data[self.head++] = *(((char*)&data.as_double)+7);
	  case CHAR_ARRAY:
	    // Write length of array
	    int length = (int)data.as_char_array.len;
	    self.data[self.head++] = (char)(length >>  0);
      self.data[self.head++] = (char)(length >>  8);
      self.data[self.head++] = (char)(length >> 16);
      self.data[self.head++] = (char)(length >> 24);
      // Write each member
	    for (int i; i < data.as_char_array.len; i++) {
	      self.data[self.head++] = data.as_char_array[i];
	    }
	  case SHORT_ARRAY:
	    // Write length of array
	    int length = (int)data.as_short_array.len;
	    self.data[self.head++] = (char)(length >>  0);
      self.data[self.head++] = (char)(length >>  8);
      self.data[self.head++] = (char)(length >> 16);
      self.data[self.head++] = (char)(length >> 24);
      // Write each member
	    for (int i; i < data.as_short_array.len; i++) {
	      self.data[self.head++] = (char)(data.as_short_array[i] >> 0);
        self.data[self.head++] = (char)(data.as_short_array[i] >> 8);
	    }
	  case INT_ARRAY:
	    // Write length of array
	    int length = (int)data.as_int_array.len;
	    self.data[self.head++] = (char)(length >>  0);
      self.data[self.head++] = (char)(length >>  8);
      self.data[self.head++] = (char)(length >> 16);
      self.data[self.head++] = (char)(length >> 24);
      // Write each member
	    for (int i; i < data.as_int_array.len; i++) {
	      self.data[self.head++] = (char)(data.as_int_array[i] >>  0);
        self.data[self.head++] = (char)(data.as_int_array[i] >>  8);
        self.data[self.head++] = (char)(data.as_int_array[i] >> 16);
        self.data[self.head++] = (char)(data.as_int_array[i] >> 24);
	    }
	  case LONG_ARRAY:
	    // Write length of array
	    int length = (int)data.as_long_array.len;
	    self.data[self.head++] = (char)(length >>  0);
      self.data[self.head++] = (char)(length >>  8);
      self.data[self.head++] = (char)(length >> 16);
      self.data[self.head++] = (char)(length >> 24);
      // Write each member
	    for (int i; i < data.as_long_array.len; i++) {
	      self.data[self.head++] = (char)(data.as_long_array[i] >>  0);
        self.data[self.head++] = (char)(data.as_long_array[i] >>  8);
        self.data[self.head++] = (char)(data.as_long_array[i] >> 16);
        self.data[self.head++] = (char)(data.as_long_array[i] >> 24);
        self.data[self.head++] = (char)(data.as_long_array[i] >> 32);
        self.data[self.head++] = (char)(data.as_long_array[i] >> 40);
        self.data[self.head++] = (char)(data.as_long_array[i] >> 48);
        self.data[self.head++] = (char)(data.as_long_array[i] >> 56);
	    }
	  case FLOAT_ARRAY:
	    // Write length of array
	    int length = (int)data.as_float_array.len;
	    self.data[self.head++] = (char)(length >>  0);
      self.data[self.head++] = (char)(length >>  8);
      self.data[self.head++] = (char)(length >> 16);
      self.data[self.head++] = (char)(length >> 24);
      // Write each member
	    for (int i; i < data.as_float_array.len; i++) {
	      self.data[self.head++] = *(((char*)&data.as_float_array[i])+0);
	      self.data[self.head++] = *(((char*)&data.as_float_array[i])+1);
	      self.data[self.head++] = *(((char*)&data.as_float_array[i])+2);
	      self.data[self.head++] = *(((char*)&data.as_float_array[i])+3);
	    }
	  case DOUBLE_ARRAY:
	    // Write length of array
	    int length = (int)data.as_double_array.len;
	    self.data[self.head++] = (char)(length >>  0);
      self.data[self.head++] = (char)(length >>  8);
      self.data[self.head++] = (char)(length >> 16);
      self.data[self.head++] = (char)(length >> 24);
      // Write each member
	    for (int i; i < data.as_double_array.len; i++) {
	      self.data[self.head++] = *(((char*)&data.as_double_array[i])+0);
	      self.data[self.head++] = *(((char*)&data.as_double_array[i])+1);
	      self.data[self.head++] = *(((char*)&data.as_double_array[i])+2);
	      self.data[self.head++] = *(((char*)&data.as_double_array[i])+3);
	      self.data[self.head++] = *(((char*)&data.as_double_array[i])+4);
	      self.data[self.head++] = *(((char*)&data.as_double_array[i])+5);
	      self.data[self.head++] = *(((char*)&data.as_double_array[i])+6);
	      self.data[self.head++] = *(((char*)&data.as_double_array[i])+7);
	    }
	  case STRING:
	    for (int i; i < data.as_string.len; i++) {
	      self.data[self.head++] = data.as_string[i];
	    }
	    self.data[self.head++] = '\0';
    default: io::printfn("ERROR - Type(%s) not yet implemented!", data.type);
  }
}
<* Reads data from logos *>
fn LogosData Logos.read(&self, LogosType type) @export("logos_read") {
  // TODO: debug mode that enables/disables this
  // io::printfn("Reading [%s] at %d",type,self.head);
  assert(self.head < self.data.len, "Position of head out of range of data.");

  switch (type) {
    case CHAR:
      return {.type=CHAR,.as_char=self.data[self.head++]};
    case SHORT:
      LogosData output;
      output.type = SHORT;
      output.as_short += (short)self.data[self.head++] <<  0;
      output.as_short += (short)self.data[self.head++] <<  8;
      return output;
    case INT:
      LogosData output;
      output.type = INT;
      output.as_int += (int)self.data[self.head++] <<  0;
      output.as_int += (int)self.data[self.head++] <<  8;
      output.as_int += (int)self.data[self.head++] << 16;
      output.as_int += (int)self.data[self.head++] << 24;
      return output;
    case LONG:
      LogosData output;
      output.type = LONG;
      output.as_long += (long)self.data[self.head++] <<  0;
      output.as_long += (long)self.data[self.head++] <<  8;
      output.as_long += (long)self.data[self.head++] << 16;
      output.as_long += (long)self.data[self.head++] << 24;
      output.as_long += (long)self.data[self.head++] << 32;
      output.as_long += (long)self.data[self.head++] << 40;
      output.as_long += (long)self.data[self.head++] << 48;
      output.as_long += (long)self.data[self.head++] << 56;
      return output;
    case FLOAT:
      LogosData output;
      output.type = FLOAT;
      mem::copy(&output.as_float, &self.data[self.head], 4);
      self.head += 4;
      return output;
    case DOUBLE:
      LogosData output;
      output.type = DOUBLE;
      mem::copy(&output.as_double, &self.data[self.head], 8);
      self.head += 8;
      return output;
    case CHAR_ARRAY:
      LogosData output;
      output.type = CHAR_ARRAY;
      usz length = (usz)self.read(INT).as_int;
      output.as_char_array = mem::new_array(char, length);
      for (int i; i < length; i++) {
        output.as_char_array[i] = self.read(CHAR).as_char;
      }
      return output;
    case SHORT_ARRAY:
      LogosData output;
      output.type = SHORT_ARRAY;
      usz length = (usz)self.read(INT).as_int;
      output.as_short_array = mem::new_array(short, length);
      for (int i; i < length; i++) {
        output.as_short_array[i] = self.read(SHORT).as_short;
      }
      return output;
    case INT_ARRAY:
      LogosData output;
      output.type = INT_ARRAY;
      usz length = (usz)self.read(INT).as_int;
      output.as_int_array = mem::new_array(int, length);
      for (int i; i < length; i++) {
        output.as_int_array[i] = self.read(INT).as_int;
      }
      return output;
    case LONG_ARRAY:
      LogosData output;
      output.type = LONG_ARRAY;
      usz length = (usz)self.read(INT).as_int;
      output.as_long_array = mem::new_array(long, length);
      for (int i; i < length; i++) {
        output.as_long_array[i] = self.read(LONG).as_long;
      }
      return output;
    case FLOAT_ARRAY:
      LogosData output;
      output.type = FLOAT_ARRAY;
      usz length = (usz)self.read(INT).as_int;
      output.as_float_array = mem::new_array(float, length);
      for (int i; i < length; i++) {
        output.as_float_array[i] = self.read(FLOAT).as_float;
      }
      return output;
    case DOUBLE_ARRAY:
      LogosData output;
      output.type = DOUBLE_ARRAY;
      usz length = (usz)self.read(INT).as_int;
      output.as_double_array = mem::new_array(double, length);
      for (int i; i < length; i++) {
        output.as_double_array[i] = self.read(DOUBLE).as_double;
      }
      return output;
    case STRING:
      LogosData output;
      output.type = STRING;
      // Get length of string
      usz length;
      usz start = self.head;
      for (int i; self.data[start++] != '\0'; i++) length++;
      // Create string and copy
      output.as_string = (String)mem::new_array(char, length);
      for (int i; i < length; i++) {
        output.as_string[i] = self.read(CHAR).as_char;
      }
      self.head++;
      return output;
    default: io::printfn("ERROR - Type(%s) not yet implemented!", type); return {};
  }
}

<* Frees Logos data struct if it contains an array *>
fn void LogosData.free(&self) @export("logos_freedata") {
  switch (self.type) {
    case CHAR_ARRAY:   free(self.as_char_array);
    case SHORT_ARRAY:  free(self.as_short_array);
    case INT_ARRAY:    free(self.as_int_array);
    case LONG_ARRAY:   free(self.as_long_array);
    case FLOAT_ARRAY:  free(self.as_float_array);
    case DOUBLE_ARRAY: free(self.as_double_array);
    case STRING:       free(self.as_string);
    default:
  }
}

