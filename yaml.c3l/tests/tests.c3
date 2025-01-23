
import yaml;
import std::io;


fn void yaml_test() @test {
  //Yaml yml = yaml::file("yaml.c3l/tests/test.yml")!!;
  //assert(yml != null, "Loading failed");

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

  //* Count spaces/tabs
  int count = str.count_spaces(2);
  assert(count == 5, "Count spaces failed");
  
  //* Truncate Spaces
  String tr = str.truncate_spaces();
  assert(tr == "test", "Failed to truncate spaces");

  //* Truncate Spaces at end
  String tra = str.truncate_spaces_after();
  assert(tra == "  \t test", "Failed to truncate later spaces");

  //* Remove spaces/tabs
  String rst = pair.remove_spaces_after_char(':');
  assert(rst == "test:test", "Failed to remove spaces");

  //* Checking for variable pair
  assert(pair.is_value_pair(), "Failed to check if pair was a value");

  //* Split variable
  String[] spv = pair.remove_spaces_after_char(':').split_variable();
  assert(spv[0] == "test" && spv[1] == "test", "Failed to split variable");

  //* Testing for variable
  assert(str_NONE.get_type() == YAMLType.NONE, "Failed to get NONE type");
  assert(str_BOOL_t.get_type() == YAMLType.BOOL && str_BOOL_f.get_type() == YAMLType.BOOL, "Failed to get BOOL type");
  assert(str_ARRAY.get_type() == YAMLType.ARRAY, "Failed to get ARRAY type");
  assert(str_INT_p.get_type() == YAMLType.INT && str_INT_n.get_type() == YAMLType.INT, "Failed to get INT type");
  assert(str_DOUBLE.get_type() == YAMLType.DOUBLE, "Failed to get DOUBLE type");
  assert(str_STRING.get_type() == YAMLType.STRING, "Failed to get STRING type");
}
