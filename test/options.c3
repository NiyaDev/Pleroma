

import std::io;
import pleroma::options;


fn void tests() @test {
  Options options;

  Option opt_bool;
  opt_bool.type = BOOL;
  opt_bool.as_bool = true;
  options.set("opt_bool", opt_bool);

  Option opt_byte;
  opt_byte.type = BYTE;
  opt_byte.as_byte = 10;
  options.set("opt_byte", opt_byte);

  Option opt_short;
  opt_short.type = SHORT;
  opt_short.as_short = 1000;
  options.set("opt_short", opt_short);

  Option opt_int;
  opt_int.type = INT;
  opt_int.as_int = 1000000000;
  options.set("opt_int", opt_int);

  Option opt_long;
  opt_long.type = LONG;
  opt_long.as_long = 1000000000000000000;
  options.set("opt_long", opt_long);

  Option opt_float;
  opt_float.type = FLOAT;
  opt_float.as_float = 0.12345678;
  options.set("opt_float", opt_float);

  Option opt_double;
  opt_double.type = DOUBLE;
  opt_double.as_double = 0.123456789101112;
  options.set("opt_double", opt_double);

  Option opt_array;
  opt_array.type = ARRAY;
  opt_array.as_array = {10,20,30};
  options.set("opt_array", opt_array);

  Option opt_string;
  opt_string.type = STRING;
  opt_string.as_string = "Fugandulu";
  options.set("opt_string", opt_string);

  assert(options.get("opt_bool")!!.as_bool == true, "Failed to correctly apply BOOL.");
  assert(options.get("opt_byte")!!.as_byte == 10, "Failed to correctly apply BYTE.");
  assert(options.get("opt_short")!!.as_short == 1000, "Failed to correctly apply SHORT.");
  assert(options.get("opt_int")!!.as_int == 1000000000, "Failed to correctly apply INT.");
  assert(options.get("opt_long")!!.as_long == 1000000000000000000, "Failed to correctly apply LONG.");
  assert(options.get("opt_float")!!.as_float == 0.123456783592700958251953125, "Failed to correctly apply FLOAT.");
  assert(options.get("opt_double")!!.as_double == 0.123456789101112, "Failed to correctly apply DOUBLE.");
  assert(options.get("opt_array")!!.as_array == {10,20,30}, "Failed to correctly apply ARRAY.");
  assert(options.get("opt_string")!!.as_string == "Fugandulu", "Failed to correctly apply STRING.");

  char[] file = options.save();
  defer free(file);
  
  options.clean();
  options = options::load(file)!!;

  assert(options.get("opt_bool")!!.as_bool == true, "Failed to correctly apply BOOL.");
  assert(options.get("opt_byte")!!.as_byte == 10, "Failed to correctly apply BYTE.");
  assert(options.get("opt_short")!!.as_short == 1000, "Failed to correctly apply SHORT.");
  assert(options.get("opt_int")!!.as_int == 1000000000, "Failed to correctly apply INT.");
  assert(options.get("opt_long")!!.as_long == 1000000000000000000, "Failed to correctly apply LONG.");
  assert(options.get("opt_float")!!.as_float == 0.123456783592700958251953125, "Failed to correctly apply FLOAT.");
  assert(options.get("opt_double")!!.as_double == 0.123456789101112, "Failed to correctly apply DOUBLE.");
  assert(options.get("opt_array")!!.as_array == {10,20,30}, "Failed to correctly apply ARRAY.");
  assert(options.get("opt_string")!!.as_string == "Fugandulu", "Failed to correctly apply STRING.");

  free(options.get_ref("opt_array")!!.as_array);

  options.clean();
}
