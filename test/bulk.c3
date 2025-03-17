
import std::io;
import pleroma::bulk;



fn void bulk_new() @test {
  Bulk new_bulk = bulk::new("TEST");
  defer new_bulk.free();

  //* Name and path
  assert(new_bulk.name == "TEST", "Name is incorrect");
  assert(new_bulk.path == "resources/", "Path is incorrect");
  assert(new_bulk.save_path() == "resources/TEST", "Full path is incorrect");
  //* Version
  assert(new_bulk.major == bulk::MAJOR, "Major incorrect");
  assert(new_bulk.minor == bulk::MINOR, "Minor incorrect");
  assert(new_bulk.patch == bulk::PATCH, "Patch incorrect");
  assert(new_bulk.version() == "1.0.0", "Version string incorrect");
}

fn void bulk_save() @test {
  Bulk new_bulk = bulk::new("Test");
  defer new_bulk.free();

  String test_str = "Testing this shit my duderino.";
  new_bulk.add("test", (char[])test_str);
  new_bulk.save();

  Bulk bulk_2 = bulk::load("resources/Test");
  char[] ent = bulk_2.get("test");
  assert(ent == test_str, "Loading failed");
}

fn void file_new() @test {
  BulkFile new = file::new(1);

  assert(new.compression == NONE, "Inited wrong compression");
  assert(new.head == 0, "Head inited wrong");
  assert(new.data.len == 1, "Array defauled wrong");

  new.free();
  
  new = file::new(30);
  assert(new.data.len == 30, "Array length wrong");

  new.write_8(1);
  new.write_16(2);
  new.write_32(3);
  new.write_64(4);
  new.write_float(0.5);
  new.write_string("TEST");
  new.write_array({10,11,12,13,14});
  char[] ptr = mem::new_array(char, 3);
  ptr = {15};
  new.write_ptr(ptr,1);

  new.head = 0;
  assert(new.read_8() == 1, "new -read_8");
  assert(new.read_16() == 2, "new - read_16");
  assert(new.read_32() == 3, "new - read_32");
  assert(new.read_64() == 4, "new - read_64");
  assert(new.read_float() == 0.5, "new - read_float");
  assert(new.read_string() == "TEST", "new - read_string");
  assert(new.read_array(5) == {10,11,12,13,14}, "new - read_array");
  assert(*new.read_ptr(1) == 15, "new - read_ptr");

  new.free();
}

fn void file_save() @test {
  BulkFile file = file::new(30);

  file.write_8(1);
  file.write_16(2);
  file.write_32(3);
  file.write_64(4);
  file.write_float(0.5);
  file.write_string("TEST");
  file.write_array({10,11,12,13,14});
  char[] ptr = mem::new_array(char, 3);
  ptr = {15};
  file.write_ptr(ptr,1);

  file.save("resources/test.bin");
  file.free();

  BulkFile new = file::load("resources/test.bin");
  
  assert(new.read_8() == 1, "save - read_8");
  assert(new.read_16() == 2, "save - read_16");
  assert(new.read_32() == 3, "save - read_32");
  assert(new.read_64() == 4, "save - read_64");
  assert(new.read_float() == 0.5, "save - read_float");
  assert(new.read_string() == "TEST", "save - read_string");
  assert(new.read_array(5) == {10,11,12,13,14}, "save - read_array");
  assert(*new.read_ptr(1) == 15, "save - read_ptr");

  new.free();
}
