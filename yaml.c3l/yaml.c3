
module yaml;
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
  void* value;
}

fault TypedValueFault {
  SIZE_WRONG_TYPE,
  GET_WRONG_TYPE,
}
struct TypedValue {
  YAMLType type;
  void* value;
}
fn usz! TypedValue.size(&self) {
  switch (self.type) {
    case ARRAY:  return ((List(<TypedValue>)*)self.value).len();
    case OBJECT: return ((HashMap(<String, TypedValue>)*)self.value).len();
    default:
      io::printfn("ERROR - Unable to get length of type %s. This is only applicable to Arrays and Objects.", self.type.to_string());
      return TypedValueFault.SIZE_WRONG_TYPE?;
  }
}
fn TypedValue! TypedValue.get_array(&self, usz index) {
  if (self.type != ARRAY) {
    io::printfn("ERROR - Attempting to cast TypedValue of type %s to array.", self.type.to_string());
    return TypedValueFault.GET_WRONG_TYPE?;
  }
  return ((List(<TypedValue>)*)self.value).get(index);
}
fn TypedValue! TypedValue.get_object(&self, String name) {
  if (self.type != OBJECT) {
    io::printfn("ERROR - Attempting to cast TypedValue of  type %s to object.", self.type.to_string());
    return TypedValueFault.GET_WRONG_TYPE?;
  }
  return ((HashMap(<String, TypedValue>)*)self.value).get(name);
}

def Array = List(<TypedValue>);
def Map   = HashMap(<String, TypedValue>);

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
  String new_str;
  int trailing = 0;

  for (int i = self.len - 1; i >= 0; i--) {
    if (new_str.len == 0 && (self[i] == ' ' || self[i] == '\t')) {
      trailing++;
      continue;
    }
    break;
  }
  
  char[] temp = mem::new_array(char,1);
  for (int i; i < self.len - trailing; i++) {
    if (new_str.len == 0 && (self[i] == ' ' || self[i] == '\t')) continue;
    temp[0] = self[i];
    new_str = new_str.concat((String)temp);
  }
  free(temp);

  return new_str;
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
  usz index = self.index_of_char(c)!!;
  
  int count = 0;
  for (int i = (int)index+1; i < self.len - 1; i++) {
    if (self[i] != ' ') break;
    count++;
  }

  char[] temp = mem::new_array(char, self.len - count);
  int inc;
  for (int i; i < self.len; i++) {
    if (index+1 == i) i += count;
    temp[inc] = self[i];
    inc++;
  }

  return (String)temp;
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
<*  *>
fn YAMLType String.get_type(self) {
  if (self.len == 0) return YAMLType.NONE;
  
  //* Boolean
  if (self == "true" || self == "false") return YAMLType.BOOL;

  //* Array
  if (self[0] == '[' && self[self.len - 1] == ']') return YAMLType.ARRAY;

  //* Int
  bool is_int = true;
  for (int i; i < self.len; i++) {
    if ((self[i] < '0' || self[i] > '9') && self[i] != '-') {
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
