
module pleroma::options;
import std::io;
import std::collections;


alias Options = HashMap{String, Option};

struct Option {
  OptionType type;
  union {
    bool as_bool;
    char as_byte;
    short as_short;
    int as_int;
    long as_long;
    float as_float;
    double as_double;
    int[] as_array;
    String as_string;
  }
}

enum OptionType {
  BOOL,
  BYTE,
  SHORT,
  INT,
  LONG,
  FLOAT,
  DOUBLE,
  ARRAY,
  STRING,
}

faultdef INVALID_ENTRY;

<* Frees any data in option *>
fn void Option.free(&self) {
  switch (self.type) {
    case ARRAY:
      free(self.as_array);
    case STRING:
    default:
  }
}

<* Creates Options map from char array *>
fn Options? load(char[] data) @export("options_load") {
  usz head;
  long number_of_entries = data.read_64(head);
  head += 8;

  Options output;

  for (int i; i < number_of_entries; i++) {
    Option opt;

    usz key_len = data.read_string_length(head);
    String key = data.read_string(head);
    head += key_len + 1;

    char type = data.read_8(head++);
    opt.type = OptionType.from_ordinal(type);

    switch (opt.type) {
      case BOOL:
        opt.as_byte = data.read_8(head);
        head += 1;
      case BYTE:
        opt.as_byte = data.read_8(head);
        head += 1;
      case SHORT:
        opt.as_short = data.read_16(head);
        head += 2;
      case INT:
        opt.as_int = data.read_32(head);
        head += 4;
      case LONG:
        opt.as_long = data.read_64(head);
        head += 8; 
      case FLOAT:
        opt.as_float = data.read_float(head);
        head += 4; 
      case DOUBLE:
        opt.as_double = data.read_double(head);
        head += 8; 
      case ARRAY:
        usz length = data.read_64(head);
        head += 8;
        int[] arr = mem::new_array(int, length);
        for (int l; l < length; l++) {
          arr[l] = data.read_32(head);
          head += 4;
        }
        opt.as_array = arr;
      case STRING:
        usz length = data.read_string_length(head);
        opt.as_string = data.read_string(head);
        head += length + 1;
    }

    output.set(key, opt);
  }

  return output;
}
<* Saves Options map to a char array *>
fn char[] Options.save(&self) @export("options_save") {
  // Calculate length
  usz length = 8;
  self.@each(; String key, Option opt) {
    length += key.len + 2;
    length += 1; // Type
    switch (opt.type) {
      case BOOL:   length += 1;
      case BYTE:   length += 1;
      case SHORT:  length += 2;
      case INT:    length += 4;
      case LONG:   length += 8;
      case FLOAT:  length += 4;
      case DOUBLE: length += 8;
      case ARRAY:  length += (opt.as_array.len * 4);
      case STRING: length += opt.as_string.len + 2;
    }
  };

  // Create array
  usz head;
  char[] output = mem::new_array(char, length);
  output.write_64((long)self.len(), head);
  head += 8;

  self.@each(; String key, Option opt) {
    // Key
    output.write_string(key, head);
    head += key.len + 1;

    // Type
    output.write_8((char)opt.type.ordinal, head);
    head += 1;

    // Data
    switch (opt.type) {
      case BOOL:
        output.write_8(opt.as_byte, head);
        head += 1; //io::printfn("8:%s",opt.as_bool);
      case BYTE:
        output.write_8(opt.as_byte, head);
        head += 1; //io::printfn("8:%d",opt.as_byte); 
      case SHORT:
        output.write_16(opt.as_short, head);
        head += 2; //io::printfn("16:%d",opt.as_short);
      case INT:
        output.write_32(opt.as_int, head);
        head += 4; //io::printfn("32:%d",opt.as_int); 
      case LONG:
        output.write_64(opt.as_long, head);
        head += 8; //io::printfn("64:%d",opt.as_long);
      case FLOAT:
        output.write_float(opt.as_float, head);
        head += 4; //io::printfn("32:%.8f",opt.as_float); 
      case DOUBLE:
        output.write_double(opt.as_double, head);
        head += 8; //io::printfn("64:%.16f",opt.as_double); 
      case ARRAY:
        output.write_64(opt.as_array.len, head);
        head += 8; //io::printfn("array:%d",opt.as_array.len);
        for (int i; i < opt.as_array.len; i++) {
          output.write_32(opt.as_array[i], head);
          head += 4; //io::printfn("  32:%d",opt.as_array[i]);
        }
      case STRING:
        output.write_string(opt.as_string, head);
        head += opt.as_string.len + 1; //io::printfn("string:%s",opt.as_string); 
    }
  };

  return output;
}
<* Frees all data in options *>
fn void Options.clean(&self) {
  self.@each(; String key, Option opt) {
    //self.get_ref(key)!!.free();
    //Option* optp = self.get_ref(key)!!;
    //switch (optp.type) {
    //  case ARRAY: free(self.get_ref(key)!!.as_array);
    //  default:
    //}
  };
  self.free();
}

<* Reads byte from the bulkfile *>
fn char char[].read_8(self, usz i) {
  return self[i];
}
<* Reads short from the bulkfile *>
fn short char[].read_16(self, usz i) {
  short result;
  result += (short)self[i + 0] <<  0;
  result += (short)self[i + 1] <<  8;
	
	return result;
}
<* Reads int from the bulkfile *>
fn int char[].read_32(self, usz i) {
  int result;
  result += (int)self[i + 0] <<  0;
  result += (int)self[i + 1] <<  8;
  result += (int)self[i + 2] << 16;
  result += (int)self[i + 3] << 24;

  return result;
}
<* Reads long from the bulkfile *>
fn long char[].read_64(self, usz i) {
  long result;
  result += (long)self[i + 0] <<  0;
  result += (long)self[i + 1] <<  8;
  result += (long)self[i + 2] << 16;
  result += (long)self[i + 3] << 24;
  result += (long)self[i + 4] << 32;
  result += (long)self[i + 5] << 40;
  result += (long)self[i + 6] << 48;
  result += (long)self[i + 7] << 56;

	return result;
}
<* Reads float from the bulkfile *>
fn float char[].read_float(self, usz i) {
  float output;
  mem::copy(&output, &self[i], 4);

  return output;
}
<* Reads float from the bulkfile *>
fn double char[].read_double(self, usz i) {
  double output;
  mem::copy(&output, &self[i], 8);

  return output;
}
<* Reads length of string *>
fn usz char[].read_string_length(self, usz i) {
  usz start = i;
  usz count;
  for (int l; self[start] != '\0'; l++) {
    count++;
    start++;
  }

  return count;
}
<* Reads string from the bulkfile *>
fn String char[].read_string(self, usz i) {
  usz start = i;

  // Count characters
  int count = 0;
  for (int l; self[start] != '\0'; l++) {
    count++;
    start++;
  }
  start = i;

  return (String)self[i:count];
}

<* Writes byte to bulk file *>
fn void char[].write_8(&self, char input, usz i) {
  (*self)[i] = input;
}
<* Writes short to bulk file *>
fn void char[].write_16(&self, short input, usz i) {
  (*self)[i + 0] = (char)(input >> 0);
  (*self)[i + 1] = (char)(input >> 8);
}
<* Writes int to bulk file *>
fn void char[].write_32(&self, int input, usz i) {
  (*self)[i + 0] = (char)(input >>  0);
  (*self)[i + 1] = (char)(input >>  8);
  (*self)[i + 2] = (char)(input >> 16);
  (*self)[i + 3] = (char)(input >> 24);
}
<* Writes long to bulk file *>
fn void char[].write_64(&self, long input, usz i) {
  (*self)[i + 0] = (char)(input >>  0);
	(*self)[i + 1] = (char)(input >>  8);
	(*self)[i + 2] = (char)(input >> 16);
	(*self)[i + 3] = (char)(input >> 24);
	(*self)[i + 4] = (char)(input >> 32);
	(*self)[i + 5] = (char)(input >> 40);
	(*self)[i + 6] = (char)(input >> 48);
	(*self)[i + 7] = (char)(input >> 56);
}
<* Writes float to the bulkfile *>
fn void char[].write_float(&self, float input, usz i) {
  (*self)[i + 0] = *(((char*)&input) + 0);
	(*self)[i + 1] = *(((char*)&input) + 1);
	(*self)[i + 2] = *(((char*)&input) + 2);
	(*self)[i + 3] = *(((char*)&input) + 3);
}
<* Writes float to the bulkfile *>
fn void char[].write_double(&self, double input, usz i) {
  (*self)[i + 0] = *(((char*)&input) + 0);
	(*self)[i + 1] = *(((char*)&input) + 1);
	(*self)[i + 2] = *(((char*)&input) + 2);
	(*self)[i + 3] = *(((char*)&input) + 3);
	(*self)[i + 4] = *(((char*)&input) + 4);
	(*self)[i + 5] = *(((char*)&input) + 5);
	(*self)[i + 6] = *(((char*)&input) + 6);
	(*self)[i + 7] = *(((char*)&input) + 7);
}
<* Writes contents of string to the bulkfile *>
fn void char[].write_string(&self, String str, usz i) {
	for (int l = 0; l < str.len; l++) {
		(*self)[i + l] = (char)str[l];
	}
}



