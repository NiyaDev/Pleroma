
module yaml;
import vstring;
import std::io;
import std::collections;


enum YAMLType {
  NONE,
  INT,
  DOUBLE,
  STRING,
  ARRAY,
  BOOL,
  OBJECT,
}
fn String YAMLType.to_string(self) {
  switch (self) {
    case INT:    return "int";
    case DOUBLE: return "double";
    case STRING: return "string";
    case ARRAY:  return "array";
    case BOOL:   return "bool";
    case OBJECT: return "object";
    default:     return "None";
  }
}

struct NamedValue {
  String name;
  YAMLType type;
  union {
    void* value;
    bool  v_bool;
    int   v_int;
    double v_double;
    String v_string;
    Object v_object;
    Array v_array;
  }
}

struct TypedValue {
  YAMLType type;
  union {
    void* value;
    bool  v_bool;
    int   v_int;
    double v_double;
    String v_string;
    Object v_object;
    Array v_array;
  }
}

def Array  = List(<TypedValue>);
def Yaml   = HashMap(<String, TypedValue>);
def Object = Yaml;


fault YamlFault {
  SIZE_WRONG_TYPE,
  GET_WRONG_TYPE,
  FILE_ERROR,
  NO_HEADER,
  INCORRECT_VERSION,
}

fn TypedValue NamedValue.to_typed(&self) {
  return {self.type, self.value};
}

fn usz! TypedValue.size(&self) {
  switch (self.type) {
    case ARRAY:  return ((List(<TypedValue>)*)self.value).len();
    case OBJECT: return ((HashMap(<String, TypedValue>)*)self.value).len();
    default:
      io::printfn("ERROR - Unable to get length of type %s. This is only applicable to Arrays and Objects.", self.type.to_string());
      return YamlFault.SIZE_WRONG_TYPE?;
  }
}
fn TypedValue! TypedValue.get_array(&self, usz index) {
  if (self.type != ARRAY) {
    io::printfn("ERROR - Attempting to cast TypedValue of type %s to array.", self.type.to_string());
    return YamlFault.GET_WRONG_TYPE?;
  }
  return ((Array*)self.value).get(index);
}
fn TypedValue! TypedValue.get_object(&self, String name) {
  if (self.type != OBJECT) {
    io::printfn("ERROR - Attempting to cast TypedValue of  type %s to object.", self.type.to_string());
    return YamlFault.GET_WRONG_TYPE?;
  }
  return ((Object*)self.value).get(name);
}

<* Counts the number of spaces set at the beginning of a string *>
fn int String.count_spaces(self, int tab_spaces = 4) {
  int spaces = 0;
  for (int i; i < self.len; i++) {
    if (self[i] == ' ') {
      spaces++;
    } else if (self[i] == '\t') {
      spaces += tab_spaces;
    } else {
      return spaces;
    } 
  }
  return spaces;
}
<* Removes tabs and spaces at the beginning and end of the string
  E.g. "   name: person " -> "name: person"
 *>
fn String String.truncate_spaces(self) {
  VString new_str;
  int trailing = 0;

  for (int i = self.len - 1; i >= 0; i--) {
    if (new_str.len() == 0 && (self[i] == ' ' || self[i] == '\t')) {
      trailing++;
      continue;
    }
    break;
  }
  
  for (int i; i < self.len - trailing; i++) {
    if (new_str.len() == 0 && (self[i] == ' ' || self[i] == '\t')) continue;
    new_str.push(self[i]);
  }

  return new_str.string();
}
<* Removes excess spaces and tabs that come after a line *>
fn String String.truncate_spaces_after(self) {
  int trailing = 0;

  for (int i = self.len - 1; i >= 0; i--) {
    if (self.len == 0 || (self[i] == ' ' || self[i] == '\t')) {
      trailing++;
      continue;
    }
    break;
  }

  char[] temp = mem::new_array(char, self.len - trailing);
  for (int i; i < temp.len; i++) { temp[i] = self[i]; }
  return (String)temp;
}
<* Removes all tabs and spaces that come after a specified char
  E.g. "name:    person" -> "name:person"
 *>
fn String String.remove_spaces_after_char(self, char c) {
  VString new_str;
  char last = '\0';
  for (int i = (int)new_str.len(); i < self.len; i++) {
    if (self[i] != ' ') last = self[i];
    if (last == c && self[i] == ' ') continue;
    new_str.push(self[i]);
  }

  return new_str.string();
}
<*Returns true if the YAML line is a variable-value pair, otherwise returns false *>
fn bool String.is_value_pair(&self) {
  return self.contains(":");
}
<*Splits a string into the name and value based on the : delimiter
  Example: "variable_name:value" -> {"variable_name", "value"}
 *>
fn String[] String.split_variable(&self) {
  return self.split(":");
} 
<* Get the data type of the YAML value *>
fn YAMLType String.get_type(self) {
  if (self.len == 0) return YAMLType.NONE;

  //* Boolean
  if (self == "true" || self == "false") return YAMLType.BOOL;

  //* Array
  if (self[0] == '[' && self[self.len - 1] == ']') return YAMLType.ARRAY;

  //* Int
  bool is_int = true;
  for (int i; i < self.len; i++) {
    if (((self[i] < '0' || self[i] > '9') && self[i] != '-') || (self[i] == '-' && i != 0)) {
      is_int = false;
      break;
    }
  }
  if (is_int) return YAMLType.INT;

  //* Double
  int number_dots;
  bool contains_other = false;
  for (int i;i < self.len; i++) {
    //* When only 1 dot is present but non-number chars are found, interpret value as string
    if ((self[i] < '0' || self[i] > '9') && self[i] != '.' && self[i] != '-') {
      contains_other = true;
      break;
    }
    if (self[i] == '.') number_dots++;
    if (number_dots > 1) break;
  }
  if (number_dots == 1 && !contains_other) return YAMLType.DOUBLE;

  //* Else
  return YAMLType.STRING;
}
<* Splits array string into multiple *>
fn String[] String.split_array(&self) { 
  String[] output = self.strip("[").strip_end("]").split(",");

  for (int i; i < output.len; i++) output[i] = output[i].strip("\n\t");

  return output;
}
<* Converts a value string to an actual value *>
fn NamedValue String.to_value(&self) {
  NamedValue val;

  String[] name_value = self.split_variable();
  if (name_value.len > 1) {
    val.type = name_value[1].get_type();
  } else {
    val.type == NONE;
  }
  val.name = name_value[0];

  if (val.type == NONE) return val;

  switch (val.type) {
    case INT:
      val.v_int = name_value[1].to_int()!!;
    case DOUBLE:
      val.v_double = name_value[1].to_double()!!;
    case STRING:
      val.v_string = name_value[1].copy();
    case ARRAY:
      val.value = mem::new(Array);
      ((Array*)val.value).new_init();
      String[] values_split = name_value[1].split_array();
      for (int i; i < values_split.len; i++) {
        String named_val = string::tformat("_:%s", values_split[i]);
        TypedValue new_val;
        NamedValue nval = named_val.to_value();
        new_val = nval.to_typed();
        ((Array*)val.value).push(new_val);
      }
    case BOOL:
      val.v_bool = (name_value[1] == "true");
    default:
  }

  return val;
}
<* Returns true if the input string is a valid key-value pair *>
fn bool NamedValue.valid(&self) {
  return (self.value != null);
}
<* Loads a file to pass into parse function *>
fn Yaml! parse_file(String filename) {
  File! file = file::open(filename, "r");
  if (catch file) {
    io::printfn("ERROR - Failed to find file");
    return YamlFault.FILE_ERROR?;
  }
  usz! length = file::get_size(filename);
  if (catch length) {
    io::printfn("ERROR - Failed to fin file");
    return YamlFault.FILE_ERROR?;
  }
  char[] buffer = mem::new_array(char, length);
  file.read(buffer)!!;
  file.close()!!;

  return parse((String)buffer);
}
<* Parses Yaml data *>
fn Yaml! parse(String file) {
  Yaml yaml;

  //* Split up lines
  String[] lines_array = file.split("\n");
  if (lines_array[0].len < 5 || lines_array[0][0..4] != "%YAML") {
    io::printfn("ERROR - No header found");
    return YamlFault.NO_HEADER?;
  }
  if (lines_array[0].len < 9 || lines_array[0][6..8] != "1.2") {
    io::printfn("ERROR - Version %s incompatible", lines_array[0][6:8]);
    return YamlFault.INCORRECT_VERSION?;
  }

  int file_indent;
  List(<String>) lines;
  for (int i = 2; i < lines_array.len; i++) {
    String temp;

    //* Remove comments
    if (lines_array[i].contains("#")) {
      temp = lines_array[i][0:lines_array[i].index_of("#")!!]; 
    } else {
      temp = lines_array[i];
    }

    //* Ignore empty lines
    if (temp.truncate_spaces().len == 0) continue;

    //* Count indent
    int spaces = temp.count_spaces();
    if (spaces > 0 && file_indent == 0) file_indent = spaces;

    //* Remove spaces
    if (temp.contains(":")) {
      //lines_array[i] = temp.truncate_spaces_after().remove_spaces_after_char(',').remove_spaces_after_char(':');
      lines.push(temp.truncate_spaces_after().remove_spaces_after_char(',').remove_spaces_after_char(':'));
    } else {
      //lines_array[lines_array.len-1] = string::tformat("%s%s", lines_array[lines_array.len-1], temp.truncate_spaces().remove_spaces_after_char(':').remove_spaces_after_char(','));
      lines[lines.len()-1] = string::tformat("%s %s", lines[lines.len()-1], temp.truncate_spaces().remove_spaces_after_char(':').remove_spaces_after_char(',')); 
    }
  }

  List(<void*>) scope_stack;
  scope_stack.push(&yaml);
  int prev_indent;

  for (int i; i < lines.len(); i++) {
    if (lines[i].truncate_spaces() == "") continue; 

    int indent = lines[i].count_spaces();
    if (indent < prev_indent) {
      for (int f; f < (prev_indent - indent) / file_indent; f++) {
        scope_stack.pop()!!;
      }
    }

    NamedValue v = lines[i].truncate_spaces().to_value();

    if (v.valid()) {
      //* Adding value to deepest object
      (*((Object*)(scope_stack[scope_stack.len()-1]))).set(v.name, v.to_typed());
    } else {
      //* Add a new object to the deepest object if no value
      (*((Object*)(scope_stack[scope_stack.len()-1]))).set(v.name, {OBJECT, mem::new(Object)});
      scope_stack.push((*((Object*)(scope_stack[scope_stack.len()-1]))).get(v.name)!!.value);
    }
    prev_indent = indent;
  }
  //yaml.print();

  return yaml;
}

fn void Yaml.print(&self) {
  self.@each(; String key, TypedValue val) {
    self.get(key)!!.print(1);
  };
}

fn void TypedValue.print(&self, int tabs = 0) {
  ((Object*)self.value).@each(; String key, TypedValue val) {
    for (int i; i < tabs; i++) io::print("  ");
    switch (val.type) {
      case BOOL:    io::printfn("%s [%s]: %b", key, val.type, val.v_bool);
      case INT:     io::printfn("%s [%s]: %d", key, val.type, val.v_int);
      case DOUBLE:  io::printfn("%s [%s]: %f", key, val.type, val.v_double);
      case STRING:  io::printfn("%s [%s]: %s", key, val.type, val.v_string);
      case OBJECT:
        io::printfn("%s [%s]: {", key, val.type);
        self.get_object(key)!!.print(tabs+1);
        for (int i; i < tabs; i++) io::print("  ");
        io::printfn("}");
      case ARRAY:
        io::printfn("%s [%s]: {", key, val.type);
        for (int i; i < tabs; i++) io::print("  ");
        io::printfn("}");
      case NONE:    io::printfn("%s [%s]", key, val.type); 
    }
  };
}

