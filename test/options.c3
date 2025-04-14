

import std::io;
import pleroma::options;


fn void tests() @test {
  Options options;

  Option opt_byte = {.type=CHAR,.as_char=10};
  options.set("opt_byte", opt_byte);

  Option opt_short = {.type=SHORT,.as_short=1000};
  options.set("opt_short", opt_short);

  Option opt_int = {.type=INT,.as_int=1000000000};
  options.set("opt_int", opt_int);

  Option opt_long = {.type=LONG,.as_long=1000000000000000000};
  options.set("opt_long", opt_long);

  Option opt_float = {.type=FLOAT,.as_float=0.12345678};
  options.set("opt_float", opt_float);

  Option opt_double = {.type=DOUBLE,.as_double=0.123456789101112};
  options.set("opt_double", opt_double);

  // TODO: Arrays

  Option opt_string = {.type=STRING,.as_string="Fugandulu"};
  options.set("opt_string", opt_string);

  assert(options.get("opt_byte")!!.as_char == 10, "Failed to correctly apply BYTE.");
  assert(options.get("opt_short")!!.as_short == 1000, "Failed to correctly apply SHORT.");
  assert(options.get("opt_int")!!.as_int == 1000000000, "Failed to correctly apply INT.");
  assert(options.get("opt_long")!!.as_long == 1000000000000000000, "Failed to correctly apply LONG.");
  assert(options.get("opt_float")!!.as_float == 0.123456783592700958251953125, "Failed to correctly apply FLOAT.");
  assert(options.get("opt_double")!!.as_double == 0.123456789101112, "Failed to correctly apply DOUBLE.");
  // TODO: Arrays
  assert(options.get("opt_string")!!.as_string == "Fugandulu", "Failed to correctly apply STRING.");
}
