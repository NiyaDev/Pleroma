
module pleroma::yaml;
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
<* Converts YAMLType to string *>
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

alias Array  = List{TypedValue};
alias Yaml   = HashMap{String, TypedValue};
alias Object = Yaml;

<* Creates a TypedValue out of NamedValue *>
fn TypedValue NamedValue.to_typed(&self) {
  TypedValue output;
  output.type = self.type;
  switch (self.type) {
    case STRING: output.v_string = self.v_string;
    default: output.value = self.value;
  }
  return output;
}

<* Get size of Array or Object member *>
fn usz TypedValue.size(&self) @export("yaml_size") {
  assert(self.type == ARRAY || self.type == OBJECT, "Tried to get length of incorrect type.");
  switch (self.type) {
    case ARRAY:  return ((List{TypedValue}*)self.value).len();
    case OBJECT: return ((HashMap{String, TypedValue}*)self.value).len();
    default: return 0;
  }
}
<* Indexes TypedValue as array *>
fn TypedValue TypedValue.get_array(&self, usz index) @export("yaml_getarray") {
  assert(self.type == ARRAY, "Attempted to index non-Array as array.");
  return ((Array*)self.value).get(index);
}
<* Indexes TypedValue as HashMap *>
fn TypedValue TypedValue.get_object(&self, String name) @export("yaml_getobject") {
  assert(self.type == OBJECT, "Attempted to index non-Object as Object.");
  return ((Object*)self.value).get(name)!!;
}
<* Returns whether TypedValue objects contains a member with name *>
fn bool TypedValue.has_key(&self, String key) @export("yaml_haskey") {
  return ((Object*)self.value).has_key(key);
}

<* Removes tabs and spaces at the beginning and end of the string
  E.g. "   name: person " -> "name: person"
 *>
fn String String.truncate_spaces(self) {
  int trailing;
  int forward;

  for (int i = self.len - 1; i >= 0; i--) {
    if (self[i] == ' ' || self[i] == '\t') {
      trailing++;
      continue;
    }
    break;
  }

  for (int i; i < self.len - trailing; i++) {
    if (self[i] == ' ' || self[i] == '\t') {
      forward++;
      continue;
    }
    break;
  }

  return self[forward .. self.len - trailing - 1];
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
  char[] newstr = mem::new_array(char, self.len - self.count_spaces_after_char(c));
  char last = '\0';
  usz head;

  for (int i; i < self.len; i++) {
    if (self[i] != ' ') last = self[i];
    if (last == c && self[i] == ' ') continue;
    newstr[head++] = self[i];
  }

  String str = ((String)newstr).copy(allocator::heap());
  free(newstr);

  return str;
}
<*Returns true if the YAML line is a variable-value pair, otherwise returns false *>
fn bool String.is_value_pair(&self) {
  return self.contains(":");
}
<*Splits a string into the name and value based on the : delimiter
  Example: "variable_name:value" -> {"variable_name", "value"}
 *>
fn String[] String.split_variable(&self) {
  return self.split(allocator::heap(), ":");
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
  //usz start = 0;
  //usz pointer = 0;

  //while (self[pointer] != ']')

  String[] output = self.strip("[").strip_end("]").split(allocator::heap(), ",");
  for (int i; i < output.len; i++) output[i] = output[i].strip("\n\t");

  return output;
}
<* Converts a value string to an actual value *>
fn NamedValue String.to_value(self) {
  NamedValue val;

  String[] name_value = self.split_variable();
  defer free(name_value);

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
      val.v_string = name_value[1].copy(allocator::heap());
    case ARRAY:
      val.value = mem::new(Array);

      String[] values_split = name_value[1].split_array();
      defer free(values_split);

      for (int i; i < values_split.len; i++) {
        //String named_val = string::format(allocator::heap(), "_:%s", values_split[i]);
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
fn Yaml parse_file(String filename) @export("yaml_parsefile") {
  char[] buffer = io::file::load_temp(filename)!!;

  return parse((String)buffer);
}
<* Parses Yaml data *>
fn Yaml parse(String file) @export("yaml_parse") {
  Yaml yaml;

  //* Split up lines
  String[] lines_array = file.split(allocator::heap(), "\n");
  assert(lines_array[0][0..4] == "%YAML", "No header found.");
  assert(lines_array[0][6..8] == "1.2", "Incorrect version.");

  int file_indent;
  List{String} lines;
  for (int i = 2; i < lines_array.len; i++) {
    String temp;

    //* Remove comments
    if (lines_array[i].contains("#")) {
      temp = lines_array[i][0:lines_array[i].index_of("#")!!]; 
    } else {
      temp = lines_array[i];
    }

    //* Ignore empty lines
    if (temp.count_spaces() == temp.len) continue;

    //* Count indent
    int spaces = temp.count_spaces();
    if (spaces > 0 && file_indent == 0) file_indent = spaces;

    //* Remove spaces
    if (temp.contains(":")) {
      String truncated = temp.truncate_spaces_after();
      defer truncated.free(allocator::heap());

      String removed_comma = truncated.remove_spaces_after_char(',');
      defer removed_comma.free(allocator::heap());

      String removed_colon = removed_comma.remove_spaces_after_char(':');
      lines.push(removed_colon);
    } else {
      String trunc = temp.truncate_spaces();
      String after_c = trunc.remove_spaces_after_char(':');
      defer after_c.free(allocator::heap());
      String after_m = after_c.remove_spaces_after_char(',');
      defer after_m.free(allocator::heap());

      String lineminusone = lines[lines.len()-1].copy(allocator::heap());
      lines.get_ref(lines.len()-1).free(allocator::heap());
      lines[lines.len()-1] = string::format(
        allocator::heap(),
        "%s %s",
        lineminusone,
        after_m,
      );
      lineminusone.free(allocator::heap());
      //lines_array[lines_array.len-1] = string::tformat("%s%s", lines_array[lines_array.len-1], temp.truncate_spaces().remove_spaces_after_char(':').remove_spaces_after_char(','));
      //lines[lines.len()-1] = string::format(allocator::heap(), "%s %s", lines[lines.len()-1], temp.truncate_spaces().remove_spaces_after_char(':').remove_spaces_after_char(','));
      //lines[lines.len()-1] = string::tformat("%s %s", lines[lines.len()-1], temp.truncate_spaces().remove_spaces_after_char(':').remove_spaces_after_char(','));
    }
  }

  List{void*} scope_stack;
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
      TypedValue tv = v.to_typed();
      (*((Object*)(scope_stack[scope_stack.len()-1]))).set(v.name, v.to_typed());
    } else {
      //* Add a new object to the deepest object if no value
      (*((Object*)(scope_stack[scope_stack.len()-1]))).set(v.name, {OBJECT, mem::new(Object)});
      scope_stack.push((*((Object*)(scope_stack[scope_stack.len()-1]))).get(v.name)!!.value);
    }
    prev_indent = indent;
  }
  free(lines_array);
  for (int i; i < lines.len(); i++) {
    //lines.get_ref(i).free(allocator::heap());
    //free((char[])*lines.get_ref(i));
    lines[i].free(allocator::heap());
  }
  //yaml.print();

  return yaml;
}
<**>
fn void Yaml.clean(&self) @export("yaml_free") {
  //io::printfn("fug");
  self.@each(; String key, TypedValue val) {
    self.get_ref(key)!!.free();
    //free(self.get_ref(key)!!.value);
  };
  self.free();
}
<**>
fn void TypedValue.free(&self) {
  //io::printfn("[%s]",self.type);
  switch (self.type) {
    case STRING: self.v_string.free(allocator::heap());
    case OBJECT:
      ((Object*)self.value).@each(; String key, TypedValue val) {
        ((Object*)self.value).get_ref(key)!!.free(); 
      };
      ((Object*)self.value).free();
      free(self.value);
    case ARRAY:
      for (int i; i < self.size(); i++) {
        ((Array*)self.value)[i].free();
      }
      //free((Array*)self.value);
      free(self.value);
    default:
  }
}

<* Prints yaml info *>
fn void Yaml.print(&self) @export("yaml_print") {
  io::print("\n");
  self.@each(; String key, TypedValue val) {
    self.get_ref(key)!!.print(1);
  };
}

<* Prints TypedValue info *>
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
        self.get_object(key).print(tabs+1);
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


<* Pushes an entire String into VString *>
fn void List{char}.push_string(&self, String str) {
  for (int i; i < str.len; i++) {
    self.push(str[i]);
  }
}
<* Converts VString into String and frees original *>
fn String List{char}.string(&self) {
  char[] output = mem::new_array(char, self.len());

  for (int i; i < self.len(); i++) output[i] = self.get(i);

  self.free();

  return (String)output;
}
