
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
    case ARRAY:  return ((List(<TypedValue>))self.value).len;
    case OBJECT: return ((HashMap(<String, TypedValue>))self.value).len;
  }
  io::printfn("ERROR - Unable to get length of type %s. This is only applicable to Arrays and Objects.", self.type.to_string());
  return TypedValueFault.SIZE_WRONG_TYPE?;
}
fn TypedValue! TypedValue.get_array(&self, usz index) {
  if (self.type != ARRAY) {
    io::printfn("ERROR - Attempting to cast TypedValue of type %s to array.", self.type.to_string());
    return TypedValueFault.GET_WRONG_TYPE?;
  }
  return ((List(<TypedValue>))self.value)[index];
}
fn TypedValue! TypedValue.get_object(&self, String name) {
  if (self.type != OBJECT) {
    io::printfn("ERROR - Attempting to cast TypedValue of  type %s to object.", self.type.to_string());
    return TypedValueFault.GET_WRONG_TYPE?;
  }
  return ((HashMap(<String, TypedValue>))self.value)[name];
}

def Array = List(<TypedValue>);
def Map   = HashMap(<String, TypedValue>);

<* Counts the number of spaces set at the beginning of a string *>
fn int count_spaces(String str, int tab_spaces = 4) {
  int spaces = 0;
  for (int i; i < str.len; i++) {
    if (str[i] == ' ') {
      spaces++;
    } else if (str[i] == '\t') {
      spaces += tab_spaces;
    } else {
      return spaces;
    } 
  }
  return spaces;
}

