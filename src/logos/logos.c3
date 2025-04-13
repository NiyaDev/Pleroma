
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
fn Logos char[].to_logos(&self) {
  return {
    *self,
    NONE,
    0,
  };
}
<* Create new empty logos *>
fn Logos new(usz size = 0, Compression comp = NONE) {
  Logos output;
  output.data = mem::new_array(char, size);
  output.compression = comp;

  return output;
}
<* Load file into logos *>
fn Logos file(String filename, Compression comp = NONE) {
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
<* Saves mlogos to file *>
fn void Logos.save(&self, String filename) {
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
fn void Logos.free(&self) {
  free(self.data);
}

<* Writes data into logos *>
fn void Logos.write(&self, LogosData data) {
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
    io::printfn("Allocating more to logos [%d]->[%d]",self.data.len, new_size);
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
    default: io::printfn("ERROR - Type(%s) not yet implemented!", data.type);
  }
}
<* Reads data from logos *>
fn LogosData Logos.read(&self, LogosType type) {
  // TODO: debug mode that enables/disables this
  io::printfn("Reading [%s] at %d",type,self.head);
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
    default: io::printfn("ERROR - Type(%s) not yet implemented!", type); return {};
  }
}

<* Frees Logos data struct if it contains an array *>
fn void LogosData.free(&self) {
  switch (self.type) {
    case CHAR_ARRAY:
    case SHORT_ARRAY:
    case INT_ARRAY:
    case LONG_ARRAY:
    case FLOAT_ARRAY:
    case DOUBLE_ARRAY:
    case STRING:
      free(self.as_char_array);
    default:
  }
}

