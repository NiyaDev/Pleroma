
import pleroma::yaml;
import std::io;
import std::collections;


fn void yaml_test() @test {
  String str = "  \t test ";
  String pair = "test: test";
  String str_NONE = "";
  String str_BOOL_t = "true";
  String str_BOOL_f = "false";
  String str_ARRAY = "[]";
  String str_INT_p = "100";
  String str_INT_n = "-100";
  String str_DOUBLE = "1.006";
  String str_STRING = "fug";
  String str_split_array_s = "[test,10,false,buckwheat]";
  String str_split_array_m = "[\n\ttest,\n\t10,\n\tfalse,\n\tbuckwheat]";

  //* Count spaces/tabs
  int count = str.count_spaces(2);
  assert(count == 5, "Count spaces failed");
  
  //* Truncate Spaces
  String tr = str.truncate_spaces();
  assert(tr == "test", "Failed to truncate spaces");

  //* Truncate Spaces at end
  String tra = str.truncate_spaces_after();
  defer tra.free(allocator::heap());
  assert(tra == "  \t test", "Failed to truncate later spaces");

  //* Remove spaces/tabs
  String rst = pair.remove_spaces_after_char(':');
  defer rst.free(allocator::heap());
  assert(rst == "test:test", "Failed to remove spaces");

  //* Checking for variable pair
  assert(pair.is_value_pair(), "Failed to check if pair was a value");

  //* Split variable
  String rem = pair.remove_spaces_after_char(':');
  defer rem.free(allocator::heap());
  String[] spv = rem.split_variable();
  defer free(spv);
  assert(spv[0] == "test" && spv[1] == "test", "Failed to split variable");

  //* Testing for variable
  assert(str_NONE.get_type() == YAMLType.NONE, "Failed to get NONE type");
  assert(str_BOOL_t.get_type() == YAMLType.BOOL && str_BOOL_f.get_type() == YAMLType.BOOL, "Failed to get BOOL type");
  assert(str_ARRAY.get_type() == YAMLType.ARRAY, "Failed to get ARRAY type");
  assert(str_INT_p.get_type() == YAMLType.INT && str_INT_n.get_type() == YAMLType.INT, "Failed to get INT type");
  assert(str_DOUBLE.get_type() == YAMLType.DOUBLE, "Failed to get DOUBLE type");
  assert(str_STRING.get_type() == YAMLType.STRING, "Failed to get STRING type");

  //* Split Array
  String[] l1 = str_split_array_s.split_array();
  defer free(l1);
  assert(l1[0] == "test" && l1[1] == "10" && l1[2] == "false" && l1[3] == "buckwheat", "Failed to split single line array");
  String[] l2 = str_split_array_m.split_array();
  defer free(l2);
  assert(l2[0] == "test" && l2[1] == "10" && l2[2] == "false" && l2[3] == "buckwheat", "Failed to split multi-line array");

  //* Named Value validity
  int value = 20;
  NamedValue nval = {
    .type = INT,
    .name = "test",
    .value = &value,
  };
  assert(nval.type == INT && nval.name == "test" && nval.value == &value, "Failed to created NamedValue correctly");
  assert(nval.valid(), "Failed to validate NamedValue");

  //* Yaml Parsing
  Yaml yml = yaml::parse_file("test/test.yml");
  defer yml.clean();
  assert(yml.len() == 2, "Failed to organize yaml");

  //* Singleline test
  TypedValue singleline = yml.get("Singleline test")!!;
  assert(singleline.v_string == "Testing a single line.", "Failed to parse Single line");

  //* Object test
  TypedValue object_test = yml.get("Object test")!!;
  assert(object_test.type == OBJECT && object_test.size() == 4, "Failed to load Object test");

  //* String inside object
  TypedValue a_string = object_test.get_object("A string");
  assert(a_string.v_string == "test", "Failed to get string inside object");

  //* Object inside object
  TypedValue tag = object_test.get_object("A Tag");
  assert(tag.get_object("float").v_double == 0.1, "Failed to validate float");
  assert(tag.get_object("bool").v_bool == true, "Failed to validate boolean");
  assert(tag.get_object("str").v_string == "i42", "Failed to validate string");
  assert(tag.get_object("int").v_int == 10, "Failed to validate integer");

  //* Array
  TypedValue array = object_test.get_object("Array test");
  assert(array.get_array(0).v_int == 10 && array.get_array(1).v_int == 9 && array.get_array(2).v_int == 25 && array.get_array(3).v_int == 6, "Failed to validate array");
}

