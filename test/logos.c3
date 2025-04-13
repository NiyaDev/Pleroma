
import pleroma::logos;
import std::io;


fn void logos() @test {
  // Test converting a char array to logos
  char[] array = file::load(allocator::heap(), "test/test.yml")!!;
  Logos lg = array.to_logos();
  assert(lg.data == array, "Failed to transfer data.");
  lg.free();

  // Test file loading and saving
  lg = logos::file("test/test.yml");
  assert(lg.data == array, "Failed to load file properly.");
  // Uncompressed
  lg.save("test/test_saved.yaml");
  assert(file::get_size("test/test.yml")!! == file::get_size("test/test_saved.yaml")!!, "Failed to save uncompressed file properly.");
  // Deflate compression
  lg.compression = DEFLATE;
  lg.save("test/test_deflate");
  lg.free();
  lg = logos::file("test/test_deflate", DEFLATE);
  assert(lg.data == array, "Failed to load ");
  lg.free();

  // Create test file
  lg = logos::new();
  lg.write({.type=CHAR, .as_char =10});
  lg.write({.type=SHORT,.as_short=1000});
  lg.write({.type=INT,.as_int=1000000000});
  lg.write({.type=LONG,.as_long=1000000000000000000});
  lg.write({.type=FLOAT,.as_float=0.12345678});
  lg.write({.type=DOUBLE,.as_double=0.123456789101112});
  lg.write({.type=CHAR_ARRAY,.as_char_array={10,12,16}});
  lg.write({.type=SHORT_ARRAY,.as_short_array={1000,1200,1600}});
  lg.write({.type=INT_ARRAY,.as_int_array={1000000000,1200000000,1600000000}});
  lg.write({.type=LONG_ARRAY,.as_long_array={1000000000000000000,1200000000000000000,1600000000000000000}});
  lg.write({.type=FLOAT_ARRAY,.as_float_array={0.12345678,0.12345678,0.12345678}});
  lg.write({.type=DOUBLE_ARRAY,.as_double_array={0.123456789101112,0.123456789101112,0.123456789101112}});
  lg.write({.type=STRING,.as_string="Fugandulu"});

  lg.head = 0;
  assert(lg.read(CHAR).as_char == 10, "Reading CHAR failed.");
  assert(lg.read(SHORT).as_short == 1000, "Reading SHORT failed.");
  assert(lg.read(INT).as_int == 1000000000, "Reading INT failed.");
  assert(lg.read(LONG).as_long == 1000000000000000000, "Reading LONG failed.");
  assert(lg.read(FLOAT).as_float == 0.123456783592700958251953125, "Reading FLOAT failed.");
  assert(lg.read(DOUBLE).as_double == 0.123456789101112, "Reading DOUBLE failed.");
  LogosData data = lg.read(CHAR_ARRAY);
  assert(data.as_char_array == {10,12,16}, "Reading CHAR_ARRAY failed.");
  data.free();
  data = lg.read(SHORT_ARRAY);
  assert(data.as_short_array == {1000,1200,1600}, "Reading SHORT_ARRAY failed.");
  data.free();
  data = lg.read(INT_ARRAY);
  assert(data.as_int_array == {1000000000,1200000000,1600000000}, "Reading INT_ARRAY failed.");
  data.free();
  data = lg.read(LONG_ARRAY);
  assert(data.as_long_array == {1000000000000000000,1200000000000000000,1600000000000000000}, "Reading LONG_ARRAY failed.");
  data.free();
  data = lg.read(FLOAT_ARRAY);
  assert(data.as_float_array == {0.123456783592700958251953125,0.123456783592700958251953125,0.123456783592700958251953125}, "Reading FLOAT_ARRAY failed.");
  data.free();
  data = lg.read(DOUBLE_ARRAY);
  assert(data.as_double_array == {0.123456789101112,0.123456789101112,0.123456789101112}, "Reading DOUBLE_ARRAY failed.");
  data.free();
  data = lg.read(STRING);
  assert(data.as_string == "Fugandulu", "Reading STRING failed.");
  data.free();
  lg.free();

}

